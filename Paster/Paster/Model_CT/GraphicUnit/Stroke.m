//
//  Stroke.m
//  Dudel
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "Stroke.h"

@implementation Stroke
@synthesize pList;
@synthesize gList;
@synthesize specialList;

-(id)initWithPoints:(NSMutableArray *)x 
{
    self = [super init];
    
    gList = [[NSMutableArray alloc] init];
    specialList = [[NSMutableArray alloc] init];
    
    self.pList = x;
    
    as = 0.0;
    ad = 0.0;
    ac = 0.0;
    
    return  self;
}

-(void)findSpecialPoints 
{
    [self speed];
    [self direction];
    [self curvity];
    [self space];
    
    GCPoint *point;
    [specialList addObject:[[NSNumber alloc]initWithInt:0]];
    for (int i = 1; i < [pList count]-1; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.total>=4)      // 过 滤 掉 权 重 小 于 4 的 点
        {
            [specialList addObject:[[NSNumber alloc]initWithInt:i]];
        }
    }
    [specialList addObject:[[NSNumber alloc]initWithInt:[pList count]-1]];
    NSLog(@"识别出来的特征点:%d",specialList.count);
}

-(void)speed 
{
    int pointNum = [pList count];
    float average = 0.0;
    
    // 首 尾 点 的 速 度 为 0
    GCPoint *start;
    GCPoint *end;
    GCPoint *point;
    GCPoint *nextPoint;
    GCPoint *prePoint;
    
    start = [pList objectAtIndex:0];
    start.s = 0.0;                   //pList[i].s 表 示 i 点 的 速 度
    end = [pList lastObject];
    end.s = 0.0;
    
    for (int i = 1; i + 1 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        nextPoint = [pList objectAtIndex:i+1];
        prePoint  = [pList objectAtIndex:i-1];
        float dx  = [Threshold Distance:prePoint :point];
        float dx1 = [Threshold Distance:point :nextPoint];
        point.s   = dx + dx1;  // 使 用 该 点 的 相 邻 两 点 间 的 距 离 作 为 该 点 的 速 度
        average += point.s;
    }
    average /= pointNum;
    as = average;
    for (int i = 0; i < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.s < average * 0.42)   // 阀 值 ，由 i 点 的 速 度 进 行 筛 选
        {
            point.total++;              //pList[i].total 表 示 i 点 的 权 重
        }
    }
}

-(void)curvity 
{
    //一：将五个点平移，使得i点在原点
    //二：将五个点绕原点旋转[0,180)，记录五个点|y|的绝对值的和
    //三：使得绝对值和最小的角度为i点切线与x轴的夹角
    //旋转矩阵：cosA   -sinA
    //         sinA    cosA
    //原来坐标(x,y),旋转后(xcosA+ysinA,-xsinA+ycosA);
    //所以只需枚举[0,180)，计算所有-xsinA+ycosA的和，就是切线与x轴夹角
    //求出夹角后，求曲率：
    //double rate = System.Math.Sin(30*pi/180.0);
    
    int pointNum = [pList count];
    GCPoint *tempPoint;
    GCPoint *point;
    GCPoint *prePoint;
    GCPoint *nextPoint;
    
    NSMutableArray *sita = [[NSMutableArray alloc] init];
    for(int k=0; k<pointNum; k++)
        [sita addObject:[[NSNumber alloc] initWithFloat:-0.0f]];
    
    for (int i = 2; i + 2 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        float mint = 0.0;    // 保 存 绝 对 值 之 和 的 最 小 值
        for (int k = 0; k <=4; k++)
        {
            tempPoint = [pList objectAtIndex:i-2+k];
            mint += abs(tempPoint.y - point.y);
        }
        [sita replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithFloat:0.0]];
        for (int j = 1; j < 180; j++)
        {
            float tmp = 0.0;
            for (int k = 0; k <= 4; k++)
            {
                tempPoint = [pList objectAtIndex:i-2+k];
                tmp+=abs((tempPoint.y-point.y)*cos(j*3.141/180.0)-(tempPoint.x-point.x)*sin(j*3.141/180.0));
            }
            if (tmp < mint)     // 求 绝 对 值 之 和 的 最 小 值
            {
                mint = tmp;
                [sita replaceObjectAtIndex:i withObject:[[NSNumber alloc] initWithFloat:j]];
            }
        }
    }
    for (int i = 2; i + 2 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        prePoint = [pList objectAtIndex:i-2];
        nextPoint = [pList objectAtIndex:i+2];
        float tmp = 0.0;
        for (int k = 1; k < 4; k++)
        {
            NSNumber *tempNumber;
            NSNumber *nextNumber;
            tempNumber = [sita objectAtIndex:i - 2 + k];
            nextNumber = [sita objectAtIndex:i - 3 + k];
            tmp+= abs([tempNumber floatValue] - [nextNumber floatValue]);
        }
        point.c = tmp / [Threshold Distance:prePoint :nextPoint];
        if(abs(point.c)>100)// 处 理 可 能 为 异 常 抖 动 的 点
        {
            point.c=0.0;
            point.total--;
            if(point.d<170.0 && point.s<as*0.42)  // 由 i 点 速 度 s 和 方 向 d 进 行 筛 选
            {
                point.total++;
            }
        }
    }
    float average = 0.0;
    for (int i = 0; i < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        average += point.c;
    }
    average /= pointNum;
    for (int i = 1; i < pointNum-1; i++)
    {
        point = [pList objectAtIndex:i];
        if (point.c > average*1.0)
        {
            point.total += 2;
        }
        else if(point.d<170.0 && point.s<as*0.42)
        {
            point.total++;
        }
    }
    ac = average;
    
    GCPoint *s;
    GCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    s.total++;
    e.total++;
    //[sita release];
}

-(void)direction 
{
    // 对 于 点 i ； 边<i-1,i> 和 边<i,i+1> 之 间 的 夹 角 来 判 断 是 否 平 滑 过 渡
    // 夹 角 大 于 175 度 时 ，平 滑 过 渡 ， 否 则 ， 点 i 为 一 个 转 折 点
    // 运 用 余 弦 定 理 求 解 角 度
    int pointNum = [pList count];
    GCPoint *point;
    GCPoint *prePoint;
    GCPoint *nextPoint;
    for (int i = 1; i + 1 < pointNum; i++)
    {
        nextPoint = [pList objectAtIndex:i+1];
        prePoint = [pList objectAtIndex:i-1];
        point = [pList objectAtIndex:i];
        float A = [Threshold Distance:prePoint :nextPoint];
        float B = [Threshold Distance:nextPoint :point];
        float C = [Threshold Distance:prePoint :point];

        double tmp = (B * B + C * C - A * A);
        tmp = tmp / (2 * B * C + 0.00001);
        float test=acos(tmp);
        point.d=test*180.0/3.141;
    }
    GCPoint *s;
    GCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    s.total+=2;
    e.total+=2;
    for (int i = 1; i + 1 < pointNum; i++)
    {
        point = [pList objectAtIndex:i];
        prePoint = [pList objectAtIndex:i-1];
        if (point.d <= 170.0)
        {
            if(prePoint.d>170.0)// 考 察 前 一 个 点 的 d ， 若 前 一 个 点 的 d 不 符 合 条 件 ， 则 要 考 察 i 点 的 s
            {
                if(point.s<as*0.42)// 即 i 点 的 S 已 经 符 合 条 件 了
                {
                    prePoint.total-=3;
                    point.total+=3;
                }
            }
            else// 若 前 一 个 点 的 d 也 符 合 条 件 ， 则 考 察 前 一 个 点 的 s
            {
                if (prePoint.s<as*0.42)// 表 明 前 一 个 点 的 s 符 合 条 件 ， 则 比 较 则 两 个 点 的 角 度 大 小 ， 取 较 小 的 那 个 点
                {
                    if(prePoint.d>point.d)
                    {
                        prePoint.total-=3;
                        point.total+=3;
                    }
                }
                else if(point.s<as*0.42)// 前 一 个 点 的 s 不 符 合 条 件 ， 但 当 前 点 符 合 ， 则 当 前 点 加 2
                {
                    prePoint.total-=3;
                    point.total+=3;
                }
            }
        }
    }
}

-(void)space 
{
    int pointNum = [pList count];
    GCPoint *point;
    GCPoint *anotherPoint;
    GCPoint *tempPoint;
    if(pointNum>25)
    {
        for (int i=1;i<pointNum-1;i++)
        {
            point = [pList objectAtIndex:i];
            if(i<25)// 去 除 起 始 点 附 近 的 噪 点
            {
                point.total-=2;
            }
            else if(point.total>=4)
            {
                for(int j=i-1;j>=0;j--)       // 去 除 起 始 点 后 第 i 点 周 围 的 噪 点 ， 25 是 估 计 值 ，估 计 以 25 个 点 为 一 个 单 位
                {
                    anotherPoint = [pList objectAtIndex:j];
                    if (anotherPoint.total>=4&&abs(i-j)<=25)
                    {
                        point.total-=1;
                    }
                }
            }
        }
        for(int k=2;k<=25;k++)// 搞 掉 末 尾 点 附 近 点 的 冗 余
        {
            tempPoint = [pList objectAtIndex:pointNum - k];
            tempPoint.total-=1;
        }
    }
}

-(GCGraphicUnit *)recognize:(NSMutableArray *)tempPoints
{
    // 首 先 识 别 是 否 为 点 图 元
    //if ((int)pList.size()<=2){
    //	Point_Unit apoint(pList[0]);
    //	//aunit=&apoint;
    //	GUnit* point=new Point_Unit();
    //	return 0;
    //}
    //*********************************************************************************************
    // 若 不 是 点 图 元 ， 再 次 识 别 是 否 为 直 线 图 元
    // 方 法 ： 若 首 末 两 点 的 距 离 比 上 所 有 的 两 两 相 邻 的 点 之 间 的 距 离 之 和 ， 比 之 大 于 阀 值 的 话 ， 则 判 断 为 直 线 图 元
    // 阀 值 暂 定 为 0.95
//    Gunit* aunit = [[Gunit alloc]init];// 将 要 返 回 的 那 个GUnit
    double totalLength,tempLength;
    totalLength=0.0;
    GCPoint *s;
    GCPoint *e;
    GCPoint *point;
    GCPoint *prePoint;
    s = [tempPoints objectAtIndex:0];
    e = [tempPoints lastObject];
    tempLength = [Threshold Distance:s :e];

    if(tempPoints.count <= 2)
    {
        GCPointUnit* aPoint = [[GCPointUnit alloc]initWithPoint:[tempPoints objectAtIndex:0]];
        return aPoint;
    }
    
    for (int i=1;i<[tempPoints count]-1;i++)
    {
        point = [tempPoints objectAtIndex:i];
        prePoint = [tempPoints objectAtIndex:i-1];
        totalLength += [Threshold Distance:prePoint :point];
    }
    if (tempLength/totalLength>=0.95)
    {
        GCGraphicUnit* aline = [[GCLineUnit alloc] initWithPoints:tempPoints];
        return aline;
    }
    else
    {
        GCCurveUnit* acurve = [[GCCurveUnit alloc]initWithPointArray:tempPoints];
        if([acurve isSecondDegreeCurveWithPointArray:tempPoints])
        {
            [acurve judgeCurveWithPointArray:tempPoints];
            return acurve ;
        }
        else
        {
            return NULL;
        }
    }
}


//-(void)dealloc
//{
//    [pList release];
//    [gList release];
//    [specialList release];
//    
//    [super dealloc];
//}

@end
