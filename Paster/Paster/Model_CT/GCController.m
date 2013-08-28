//
//  GCController.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-7.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCController.h"
//#import "UIColor+DeepCopy.h"

@implementation GCController
@synthesize keyPoint;
-(void)createGraph:(NSMutableArray *)arrayPointsInStroke
      nowGraphList:(NSMutableArray *)nowGraphList
          unitList:(NSMutableArray *)unitList
         graphList:(NSMutableArray *)graphList
    pointGraphList:(NSMutableArray *)pointGraphList
     savePointList:(NSMutableArray *)savePointList
     saveGraphList:(NSMutableArray *)saveGraphList
    penColor:(UIColor *)color

{
    /*-------------*/

    int graphListSize = nowGraphList.count;
    UIColor * currentColor =color;//
    //图元工厂尝试第一次拟合
    GCUnitFactory * unitFactory = [[GCUnitFactory alloc]init];
    GCGraphicUnit * unit = [unitFactory createWithPoint:arrayPointsInStroke Unit:unitList Graph:graphList PointGraph:pointGraphList NewGraph:nowGraphList];
    //图形工厂生成
    GCGraphFactory * graphFactory = [[GCGraphFactory alloc]initWithParameter:arrayPointsInStroke];
    
    GCGraph * graph = nil;
    if(unit.type != 3 && unit != NULL)
    {
        graph = [graphFactory createWithSimpleUnit:unit UnitList:unitList];
    }
    
    NSMutableArray * tempGraphList = nil;
    //第一次拟合失败，进入二次拟合阶段
    if(graph==NULL)
    {
        NSLog(@"第一次拟合失败！");
         //调用图元工厂获取特征点
        Stroke * stroke = [unitFactory getStroke];
        //调用图形工厂生成图形，储存于数组中
        tempGraphList = [graphFactory createComplexGraph:stroke UnitList:unitList];
        keyPoint=[[NSMutableArray alloc] initWithArray:stroke.pList];//ADD
        //将获取的所有图形装入图形列表
        if(tempGraphList)
            for(GCGraph * nowGraph in tempGraphList)
            {
                if([nowGraph isKindOfClass:[GCPointGraph class]])
                {
                    [pointGraphList addObject:(GCPointGraph*)nowGraph];
                }
                [nowGraphList addObject:nowGraph];
                //[graphList addObject:nowGraph];
            }
    }
    
    else
    {   //图形装入列表
        NSLog(@"第一次拟合成功");
 

        if([graph isKindOfClass:[GCPointGraph class]])
        {
            [pointGraphList addObject:(GCPointGraph*)graph];
        }
        [nowGraphList addObject:graph];
        //[graphList addObject:graph];
    }
    
    //约束
    Constraint* constructor = [[Constraint alloc]initWithPointList:pointGraphList GraphList:graphList SeletedList:nowGraphList];
    [constructor setLastGraphSize:graphListSize];
    [constructor setLastSelectedGraphSize:graphListSize];
    //构建约束
    [constructor recognizeConstraint];
    float currentSize = 5.0f;
//    UIColor * currentColor =color;//
    
    if(graphListSize >= graphList.count)
    {
        GCGraph* lastGraph = [graphList lastObject];
        lastGraph.strokeSize = currentSize;
        [lastGraph setGraphColorWithColorRef:currentColor.CGColor];
    }
    else
    {
        //对一笔多直线情况改变其余直线的颜色和宽度
        for(int i=graphListSize; i<graphList.count; i++)
        {
            GCGraph* graphTemp = [graphList objectAtIndex:i];
            graphTemp.strokeSize = currentSize;
            [graphTemp setGraphColorWithColorRef:currentColor.CGColor];
        }
    }
    
    //更新savepointlist
    [savePointList removeAllObjects];
    for(int i=0; i<[pointGraphList count]; i++)
    {
        GCPointGraph* pointGraph = [pointGraphList objectAtIndex:i];
        
        if(pointGraph.isDraw)
            [savePointList addObject:pointGraph];
    }
    
    //更新savegraphlist的个数
    [saveGraphList removeAllObjects];
    for(int i=0; i<[graphList count]; i++)
    {
        GCGraph* graphTemp = [graphList objectAtIndex:i];
        if(graphTemp.isDraw)
            NSLog(@"graphtemp类型:%d",graphTemp.graphType);
            [saveGraphList addObject:graphTemp];
    }
    
    //删除newgraphlist图形
    for(GCGraph* graphDel in constructor.delete_graph)
    {
        [nowGraphList removeObject:graphDel];
    }
    NSMutableArray* deleteGraph = constructor.delete_graph;
    [constructor.delete_graph removeAllObjects];
    if(deleteGraph.count != 0)
    {
        //更新图形数
        graphListSize -= deleteGraph.count;
    }
}

@end
