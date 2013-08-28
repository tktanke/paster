//
//  GCBoardView.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 20 13年 QFire. All rights reserved.
//

#import<QuartzCore/QuartzCore.h>
#import "GCBoardView.h"
#import "PWGeoPaster.h"
#import "RootViewController.h"
@implementation GCBoardView
 
@synthesize arrayAbandonedStrokes,arrayStrokes;
@synthesize currentColor,currentSize;
@synthesize owner;
@synthesize unitList,graphList,nowGraphList,pointGraphList,saveGraphList;
@synthesize context;
@synthesize hasDrawed;
@synthesize graphImageView;
@synthesize currentImage,lastImage;
@synthesize savePointList;
@synthesize indexTemplePaste;
@synthesize goodOrNot;
static GCController * graphProcesser = nil;

-(GCController *)getGCController
{
    if(graphProcesser == nil)
    {
        graphProcesser = [[GCController alloc]init];
    }
    return graphProcesser;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    
        arrayStrokes = [[NSMutableArray alloc]init];
        arrayAbandonedStrokes = [[NSMutableArray alloc]init];
        self.frame=frame;
        currentSize = 5.0f;
        self.currentColor=nil;
        hasDrawed = NO;
        
        unitList = [[NSMutableArray alloc]init];
        graphList = [[NSMutableArray alloc]init];
        nowGraphList = [[NSMutableArray alloc]init];
        pointGraphList = [[NSMutableArray alloc]init];
        saveGraphList = [[NSMutableArray alloc]init];
        savePointList = [[NSMutableArray alloc]init];
        isDrawing = NO;
        
        [self loadSound];
     
     }
    return self;
}

-(void) viewJustLoaded
{
    [self setFrame:CGRectMake(0, 0, 1024, 768)];
}
//
-(BOOL)isMultipleTouchEnabled
{
	return NO;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@" board touch");
    isDrawing=YES;
    goodOrNot=NO;
    NSMutableArray*      arrayPointsInStroke = [[NSMutableArray alloc]init];
    NSMutableDictionary* dictStroke          = [[NSMutableDictionary alloc]init];
    [dictStroke setObject:arrayPointsInStroke forKey:@"points"];
    
    UITouch* touch = [touches anyObject];
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    NSLog(@"touch point:(x:%f,y:%f)",currentPoint.x,currentPoint.y);
    
    GCPoint* gcPoint = [[GCPoint alloc]initWithX:currentPoint.x andY:currentPoint.y];
    [arrayPointsInStroke addObject:gcPoint];
    [self.arrayStrokes addObject:dictStroke];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    //???????????
    CGContextRef  currentContext = UIGraphicsGetCurrentContext();
 	[self.layer renderInContext:currentContext];
    self.lastImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
//       [self setNeedsDisplay];
 
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:self];
    currentPoint   = [touch locationInView:self];
    
    //计算中点
    CGPoint mid1 = CGPointMake((previousPoint1.x+previousPoint2.x)*0.5, (previousPoint1.y+previousPoint2.y)*0.5);
    CGPoint mid2 = CGPointMake((currentPoint.x+previousPoint1.x)*0.5, (currentPoint.y+previousPoint1.y)*0.5);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.currentSize * 2;
    drawBox.origin.y        -= self.currentSize * 2;
    drawBox.size.width      += self.currentSize * 4;
    drawBox.size.height     += self.currentSize * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.currentImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    GCPoint* gcPoint = [[GCPoint alloc]initWithX:currentPoint.x andY:currentPoint.y];
    NSMutableArray* arrayPointsInStroke = [[arrayStrokes lastObject]objectForKey:@"points"];
    [arrayPointsInStroke addObject:gcPoint];
    
    [self setNeedsDisplayInRect:drawBox];
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"board end");
    isDrawing = NO;
    self.currentImage = nil;
    [self.arrayAbandonedStrokes removeAllObjects];
    NSLog(@"%@",self.superview);
    //arrayPointsInStroke 储存所有点
    NSMutableArray* arrayPointsInStroke = [[arrayStrokes lastObject]objectForKey:@"points"];
    NSLog(@"%d",arrayPointsInStroke.count);
    hasDrawed = YES;
    GCController * controller = [self getGCController];
    [controller createGraph:arrayPointsInStroke nowGraphList:nowGraphList unitList:unitList graphList:graphList pointGraphList:pointGraphList savePointList:savePointList saveGraphList:saveGraphList penColor:self.currentColor];
    [self setNeedsDisplay];
    
    NSLog(@"savelist成员个数:%d",saveGraphList.count);
    NSLog(@"savelist:%@",saveGraphList);
    
    GCGraph * g=[saveGraphList objectAtIndex:0];
    NSLog(@"%d",g.graphType);
    NSLog(@"%d",indexTemplePaste);
    if (saveGraphList.count==1&&g.graphType>1) {
        [self judgeGoodOrNO:controller.keyPoint];//keyPoint 暂时没用到
    }
    else if(indexTemplePaste==0&&saveGraphList.count>=3)//不成功
    {
        NSLog(@"0000");
        int t=0;
        int tt=1;
        [self drawSmileViewOrBadView:&t coutP:&tt];
    }
    else if((indexTemplePaste==1 || indexTemplePaste == 5 || indexTemplePaste == 6)&&saveGraphList.count>=4)//不成功
    {
        NSLog(@"111");
        int t=0;
        int tt=1;
         [self drawSmileViewOrBadView:&t coutP:&tt];
    }
   else if((indexTemplePaste == 0 || indexTemplePaste == 1 || indexTemplePaste == 5 || indexTemplePaste == 6)&&(saveGraphList.count==2||saveGraphList.count==3))//类型不同说明画的不好
   {
        NSLog(@"222");
       GCGraph * t1=[saveGraphList objectAtIndex: 0];
       GCGraph * t2=[saveGraphList objectAtIndex:1];
      
       if ((t1.graphType!=t2.graphType)||t1.graphType==2) {//类型2表示两条曲线
           int t=0;
           int tt=1;
           [self drawSmileViewOrBadView:&t coutP:&tt];
       }
       
       if(saveGraphList.count==3)
       {
        GCGraph * t3=[saveGraphList objectAtIndex: 2];
           if (t1.graphType!=t3.graphType) {
               int t=0;
               int tt=1;
               [self drawSmileViewOrBadView:&t coutP:&tt];
           }
       }
   }else if ((indexTemplePaste == 2 || indexTemplePaste == 4) && saveGraphList.count >= 2) {
        NSLog(@"画圆错误");
        int t=0;
        int tt=1;
        [self drawSmileViewOrBadView:&t coutP:&tt];
    }else if(indexTemplePaste == 3)
   {
       BOOL _tempLine = YES;
       for (int x = 0; x < saveGraphList.count; x++) {
           GCGraph * temp = [saveGraphList objectAtIndex:x];
           if (temp.graphType != 1) {
               _tempLine = NO;
           }
       }
       
       if (saveGraphList.count == 10 && _tempLine == YES) {
           [self judgeGoodOrNO:controller.keyPoint];//keyPoint 暂时没用到
       }else if (saveGraphList.count >= 10 || _tempLine == NO)
       {
           NSLog(@"五角星错误");
           int t=0;
           int tt=1;
           [self drawSmileViewOrBadView:&t coutP:&tt];
       }
   }
    
    NSLog(@"graph count:%d type of last object:%d", [self imageCount], [self imageType]);
}

-(void)judgeGoodOrNO:(NSMutableArray * )keyPointArray
{
    int coutPoint=0;//表示基本点的个数
    NSString *key=nil;
    int num=0;//表示成功匹配到的点数
    switch (indexTemplePaste) {//表示几何模板的序号
        case 0:
            coutPoint=3;
            key=[NSString  stringWithFormat:@"triangle"] ;
            break;
        case 1:
            coutPoint=4;
            key=[NSString stringWithFormat:@"Trapezium"];
            break;
        case 2:
            coutPoint=10;
            key=[NSString stringWithFormat:@"ellipse"];
            break;
        case 4:
            coutPoint = 10;
            key = [NSString stringWithFormat:@"Circle"];
            break;
        case 5:
            coutPoint = 4;
            key = [NSString stringWithFormat:@"Square"];
            break;
        case 6:
            coutPoint = 4;
            key = [NSString stringWithFormat:@"Rectangle"];
            break;
        case 3:
            coutPoint = 5;
            key = [NSString stringWithFormat:@"Pentacle"];
            break;
        default:
            key=nil;
            break;
    }
    
    NSString * path=[[NSBundle mainBundle] pathForResource:@"BasicPoint" ofType:@"plist"];
    NSLog(@"..%@",path);
    NSDictionary *dictionary=[[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray * arryP=[[NSArray alloc] initWithArray:[dictionary objectForKey:key]];//基本点数组
    NSLog(@"%d",arryP.count);
    NSLog(@"%d",coutPoint);
    NSLog(@"%d",savePointList.count);
    NSLog(@"%d",saveGraphList.count);
    //0 PointGraph 1 LineGraph 2 CurveGraph 3 TriangleGraph 4 RectangleGraph 5 OtherGraph
    
    GCGraph * g=[saveGraphList objectAtIndex:0];
    
    NSLog(@"类型:%d",g.graphType);
    if (saveGraphList.count==1) {
        if (indexTemplePaste==0&&g.graphType==3) {//三角形
            [self triangle:arryP num:&num];
        }
        else if((indexTemplePaste==1 || indexTemplePaste == 5 || indexTemplePaste == 6) && g.graphType==4)//矩形
        {
            [self rectangle:arryP num:&num];
        }
        else if((indexTemplePaste==2||indexTemplePaste== 4)&&g.graphType==2)//椭圆或者圆
        {
            [self circleOrEllipse:arryP num:&num];
        }
    }//savelist!=0
    else if (indexTemplePaste == 3 && saveGraphList.count == 10)
    {
        num = 5;
    }
    
    NSLog(@"找到点数%d",num);
    goodOrNot=[self drawSmileViewOrBadView:&num coutP:&coutPoint];
    [arryP release];
    [dictionary release];
    
}

-(void)loadSound{
    NSString *tone[13]={@"%@/sound_clearButton.wav",@"%@/sound_deleteButton.wav",@"%@/sound_doGood.wav",@"%@/sound_doNotGood.wav",@"%@/sound_editGeometryPasterButton.wav",@"%@/sound_finishTask.wav",@"%@/sound_normalButton.wav",@"%@/sound_noUse.wav",@"%@/sound_pageJump.wav",@"%@/sound_prompt.mp3",@"%@/sound_returnButton.wav",@"%@/sound_saveButton.wav",@"%@/sound_slip.wav"};
    NSURL * url;
    NSError *error;

    for(int i=0;i<13;i++){
        url = [NSURL fileURLWithPath:[NSString
                                      stringWithFormat:tone[i],  [[NSBundle mainBundle]  resourcePath]]];
        tonePlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        tonePlayer[i].numberOfLoops  = 0;
        if  (tonePlayer[i] == nil)      //文件不存在
            printf("音频加载失败T%d",i);
    }
}


-(BOOL)drawSmileViewOrBadView:(int *)num  coutP:(int *)coutPoint//比较匹配到的个数
{
    if ((*num)==(*coutPoint)) {
        NSLog(@"画的好");
        UIImageView * doGoodImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doGoodImage.png"]];
        doGoodImageView.center=CGPointMake(800, 20);
        [self addSubview:doGoodImageView];
        [UIView animateWithDuration:1.0 animations:^(void)
         {
             //             [self  setUserInteractionEnabled:NO];
             doGoodImageView.center = CGPointMake(650, 220);
             doGoodImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
             
             
         } completion:^(BOOL finished)
         {
             //清除drawstate状态
             
         }];
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^(void)
         {
             doGoodImageView.layer.opacity = 0.0f;
         } completion:^(BOOL finished)
         {
              
             [doGoodImageView removeFromSuperview];
             [doGoodImageView release];
         }];
        
        [tonePlayer[2] play];
        
        return YES;
    }
    else
    {
        NSLog(@"不好");
        UIImageView * doNotGoodImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doNotGoodImage.png"]];
        doNotGoodImageView.center=CGPointMake(800, 20);
        
        [self addSubview:doNotGoodImageView];
        [UIView animateWithDuration:0.5 animations:^(void)
         {
 
             doNotGoodImageView.center = CGPointMake(670, 220);
             doNotGoodImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
         }];
        [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseInOut animations:^(void)
         {
  
             doNotGoodImageView.layer.opacity = 0.0f;
             [self clearView];//清除笔迹
          } completion:^(BOOL finished)
         {
             
             [doNotGoodImageView removeFromSuperview];
             [doNotGoodImageView release];
         }];
        
        [tonePlayer[3] play];
        
        return NO;
    }


}
-(void)triangle:(NSArray * )arryP  num:(NSInteger *)num//三角形判定
{
    for (int j=0; j<arryP.count; j++) {
        NSDictionary * dic2=[arryP objectAtIndex:j];
        NSNumber * x=[dic2 objectForKey:@"X"];
        NSNumber * y=[dic2 objectForKey:@"Y"];
        int xx=[x intValue];
        int yy=[y intValue];
        NSLog(@"j=%d",j);
        CGPoint temp=CGPointMake(xx,yy);//关键点
        //        NSAssert(!(savePointList.count==0), @"没有点");
        if (saveGraphList.count==0) {
            break;
        }
        
        NSMutableArray * tempTriangle;
        for (GCTriangleGraph * t in saveGraphList) {
            [t isKindOfClass:[GCTriangleGraph class]];
            NSLog(@"triangle");
            tempTriangle=[t triangleVertexes];
        }
        if (tempTriangle.count==0) {
            break;
        }
        for (int i=0; i<tempTriangle.count; i++) {
            GCPoint  *tt=[tempTriangle objectAtIndex:i] ;
            NSLog(@"i=%d",i);
            CGPoint first=CGPointMake([tt x],[tt y]);
            float dx=abs(temp.x-first.x);
            float dy=abs(temp.y-first.y);
            NSLog(@"dx=%f",dx);
            NSLog(@"dy=%f",dy);
            if (dx<30&&dy<30) {
                NSLog(@"ok");
                (*num)++;
                NSLog(@"num==%d",(*num));
                break;
            }
        }
        
    }


}
-(void)rectangle:(NSArray * )arryP  num:(NSInteger *)num//矩形判定
{
    for (int j=0; j<arryP.count; j++) {
        NSDictionary * dic2=[arryP objectAtIndex:j];
        NSNumber * x=[dic2 objectForKey:@"X"];
        NSNumber * y=[dic2 objectForKey:@"Y"];
        int xx=[x intValue];
        int yy=[y intValue];
        NSLog(@"j=%d",j);
        CGPoint temp=CGPointMake(xx,yy);//关键点
        //        NSAssert(!(savePointList.count==0), @"没有点");
        NSMutableArray * tempG;
        for (GCRectangleGraph * t in saveGraphList) {
            [t isKindOfClass:[GCRectangleGraph class]];
            NSLog(@"rectangle");
            tempG=[t rec_vertexes];
        }
        if (tempG.count==0) {
            break;
        }
        for (int i=0; i<tempG.count; i++) {
            GCPoint  *tt=[tempG objectAtIndex:i] ;
            NSLog(@"i=%d",i);
            CGPoint first=CGPointMake([tt x],[tt y]);
            float dx=abs(temp.x-first.x);
            float dy=abs(temp.y-first.y);
            NSLog(@"dx=%f",dx);
            NSLog(@"dy=%f",dy);
            if (dx<30&&dy<30) {
                NSLog(@"ok");
                (*num)++;
                NSLog(@"num==%d",(*num));
                break;
            }
        }
    }



}
-(void)circleOrEllipse:(NSArray * )arryP  num:(NSInteger *)num//圆或椭圆判定
{

    
    float a=[[arryP objectAtIndex:0] floatValue];
    float c=[[arryP objectAtIndex:1] floatValue];
    float f=[[arryP objectAtIndex:2] floatValue];
    NSLog(@"savelist.cout=%d",saveGraphList.count);
    if (saveGraphList.count==1) {
        GCCurveGraph * temCurveGraph=[saveGraphList objectAtIndex:0];
        float aa=temCurveGraph.curveUnit.aFactor;
        float cc=temCurveGraph.curveUnit.cFactor;
        float ff=temCurveGraph.curveUnit.fFactor;
        NSLog(@"aa = %f",aa);
        NSLog(@"cc = %f",cc);
        NSLog(@"ff = %f",ff);

        float da=fabsf(aa-a);
        float dc=fabsf(cc-c);
        float df=fabsf(ff-f);
        
        NSLog(@"da=%f",da);
        NSLog(@"dc=%f",dc);
        NSLog(@"df=%f",df);
        if (da<1&&dc<1&&df<20000) {//.1  0.05  300
            (*num)=10;
        }
        
    }

}
-(void)clearView
{
    [graphList removeAllObjects];
    [arrayStrokes  removeAllObjects];
    [arrayAbandonedStrokes  removeAllObjects];
    [unitList  removeAllObjects];
    [nowGraphList removeAllObjects];
    [pointGraphList removeAllObjects] ;
    
    [savePointList removeAllObjects];
    [saveGraphList removeAllObjects];

}

-(void)drawRect:(CGRect)rect
{
    //bug修复：加入isDrawing判断去除清空界面不干净的bug 2013.6.7
//    NSLog(@"drawRect");
    if(isDrawing)
    {
        //计算中点
        CGPoint mid1 = CGPointMake((previousPoint1.x+previousPoint2.x)*0.5, (previousPoint1.y+previousPoint2.y)*0.5);
        CGPoint mid2 = CGPointMake((currentPoint.x+previousPoint1.x)*0.5, (currentPoint.y+previousPoint1.y)*0.5);
        
        context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetAllowsAntialiasing(context, YES);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetMiterLimit(context, 2.0);
        
        [self.currentImage drawAtPoint:CGPointMake(0, 0)];
        CGContextMoveToPoint(context, mid1.x, mid1.y);
        // Use QuadCurve is the key
        CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
        CGContextSetLineWidth(context, self.currentSize);
        CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
        CGContextStrokePath(context);
    }
    if(hasDrawed)
    {
        CGContextClearRect(context, self.bounds);
        hasDrawed = NO;
        //其他已经处理完成的线条
        for(int i=0; i<graphList.count; i++)
        {
            GCGraph* graph = [graphList objectAtIndex:i];
            if(graph.isDraw)
            {
                [graph drawWithContext:context];
            }
        }
    }

    [super drawRect:rect];
}
-(UIColor *)initWithColorType:(ColorType)ct
{
     switch (ct)
    {
        case 0:
        {
            NSLog(@"It's black");
             self.currentColor = [UIColor colorWithRed:1/255.0f green:1/255.0f blue:1/255.0f alpha:255/255.0f];
            break;
        }
        case 1:
            NSLog(@"Red");
             self.currentColor = [UIColor colorWithRed:254/255.0f green:0 blue:0 alpha:255/255.0f];
            break;
        case 2:
             
            NSLog(@"YELLOW");
             self.currentColor = [UIColor colorWithRed:237/255.0f green:226/255.0f blue:37/255.0f alpha:255/255.0f];
            break;
        case 3:
            
            NSLog(@"lightBlue");
             self.currentColor = [UIColor colorWithRed:0 green:254/255.0f blue:254/255.0f alpha:255/255.0f];
            break;
        case 4:
            NSLog(@"grassGreen");
             self.currentColor = [UIColor colorWithRed:1/255.0f green:255/255.0f blue:2/255.0f alpha:255/255.0f];
            break;
        case 5:
            NSLog(@"PURPLE");
             self.currentColor = [UIColor colorWithRed:127/255.0f green:0 blue:255/255.0f alpha:255/255.0f];
            break;
        case 6:
            
             self.currentColor = [UIColor colorWithRed:138/255.0f green:69/255.0f blue:2/255.0f alpha:1.0f];
            break;
        case 7:
             
             self.currentColor = [UIColor colorWithRed:255/255.0f green:128/255.0f blue:63/255.0f alpha:1.0f];
            break;
        case 8:
             
             self.currentColor = [UIColor colorWithRed:255/255.0f green:1/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 9:
             
             self.currentColor = [UIColor colorWithRed:255/255.0f green:0 blue:128/255.0f alpha:1.0f];
            break;
        case 10:
             
             self.currentColor = [UIColor colorWithRed:160/255.0f green:159/255.0f blue:79/255.0f alpha:1.0f];
            break;
        case 11:
             
             self.currentColor = [UIColor colorWithRed:108/255.0f green:8/255.0f blue:146/255.0f alpha:1.0f];
            break;
        case 12:
           
             self.currentColor = [UIColor colorWithRed:192/255.0f green:192/255.0f blue:192/255.0f alpha:1.0f];
            break;
        case 13:
            
             self.currentColor = [UIColor colorWithRed:0 green:129/255.0f blue:0 alpha:1.0f];
            break;
        case 14:
             
             self.currentColor = [UIColor colorWithRed:1/255.0f green:76/255.0f blue:255/255.0f alpha:1.0f];
            break;
        case 15:
            
             self.currentColor = [UIColor colorWithRed:0 green:36/255.0f blue:158/255.0f alpha:1.0f];
            break;
        case 16:
             
             self.currentColor = [UIColor colorWithRed:0 green:130/255.0f blue:130/255.0f alpha:1.0f];
            break;
        case 17:
             
             self.currentColor = [UIColor colorWithRed:255/255.0f green:153/255.0f blue:204/255.0f alpha:1.0f];
            break;
        default:
            self.currentColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            break;
    }

 
      return self.currentColor;


}
-(int)imageCount
{
    return graphList.count;
}

-(GeometryType) imageType
{
    int type = -1;
    if([self imageCount] > 0)
    {
        GCGraph * graph = [graphList lastObject];
        type = graph.graphType;
    }
    return type;
}
-(void)dealloc
{
    NSLog(@"boardView dealloc");
    [arrayStrokes  release];
    [arrayAbandonedStrokes  release];
    [unitList  release];
    [nowGraphList release];
    [pointGraphList release] ;
    [graphList release];
    [savePointList release];
    [saveGraphList release];
    [super dealloc];

}
@end
