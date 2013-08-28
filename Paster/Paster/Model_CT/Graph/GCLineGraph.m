//
//  GCLineGraph.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCPointGraph.h"
#import "GCLineGraph.h"
#import "Threshold.h"
#import "GCLineUnit.h"

#import "Constraint.h"
#import "ConstraintGraph.h"

@implementation GCLineGraph

@synthesize hasEnd,hasStart;
@synthesize lineUnit;
@synthesize isSpecial,isTangent;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        self.graphType = Line_Graph;
        isSpecial = isTangent = NO;
        lineUnit = [[GCLineUnit alloc]init];
    }
    
    return self;
}

-(id)initWithLine:(GCLineUnit *)lineUnit1 andId:(int)temp_local_graph_id
{
    self = [self init];
    
    self.lineUnit = lineUnit1;
    hasEnd = hasStart = NO;
    
    return self;
}

-(void)drawWithContext:(CGContextRef)context
{
    NSLog(@"start:%f,%f",lineUnit.start.x,lineUnit.start.y);
    NSLog(@"end:%f,%f",lineUnit.end.x,lineUnit.end.y);
    
    CGContextSetLineWidth(context, strokeSize);
    CGContextSetStrokeColorWithColor(context, graphColor);
    [lineUnit drawWithContext:context];
    
    //画端点
    //    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 1.0f, 1.0f);
    //    CGContextFillEllipseInRect(context, CGRectMake(lineUnit.start.x-5.0f,lineUnit.start.y-5.0f, 10.0f, 10.0f));
    //    CGContextFillEllipseInRect(context, CGRectMake(lineUnit.end.x-5.0f, lineUnit.end.y-5.0f, 10.0f, 10.0f));
}

-(int)judgeLegalIntersectionWithLine1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Point:(GCPoint *)p2
{
    if( (((p2.x-line1.start.x)*(p2.x-line1.end.x) >= 0) && ((p2.y-line1.start.y)*(p2.y-line1.end.y) >= 0)) &&
       (((p2.x-line2.start.x)*(p2.x-line2.end.x) >= 0) && ((p2.y-line2.start.y)*(p2.y-line2.end.y) >= 0)) )
    {
        return -1;
    }
    else if([Threshold Distance:line2.start :p2] <= is_point_connection)
    {
        return 1;
    }
    else if([Threshold Distance:line2.end :p2] <= is_point_connection)
    {
        return 2;
    }
    else
    {
        return 0;
    }
}

//总领函数
-(Boolean)recognizeConstraintWithGraph:(GCGraph *)graph PointList:(NSMutableArray *)plist
{
    if([graph isKindOfClass:[GCLineGraph class]])
    {
        /*!!!!!!!!not implement yet!!!!!!!!!!!!*/
        return [self recognizeConstraintWithLineGraph:(GCLineGraph*)graph PointList:plist];
    }
    //    else if([graph isKindOfClass:[GCTriangleGraph class]])
    //    {
    //        GCTriangleGraph* tempTriangleGraph = (GCTriangleGraph*)graph;
    //        /*!!!!!!!!not implement yet!!!!!!!!!!!!*/
    //        [tempTriangleGraph recognizeCommonConstraintWithLineGraph:self PointList:plist];
    //        return YES;
    //    }
    //    else if([graph isKindOfClass:[GCRectangleGraph class]])
    //    {
    //        /*!!!!!!!!not implement yet!!!!!!!!!!!!*/
    //        GCRectangleGraph* tempRecGraph = (GCRectangleGraph*)graph;
    //        return [self recognizeConstraintWithRectangleGraph:tempRecGraph PointList:plist];
    //    }
    else
        return NO;
    
}

////识别直线和三角形的约束关系
//-(Boolean)recognizeConstraintWithTriangleGraph:(GCTriangleGraph *)triangleGraphTemp PointList:(NSMutableArray *)pointList
//{
//    Boolean work = NO;
//    for(int j=0; j<3; j++)
//    {
//        GCPoint* tempPoint = [[GCPoint alloc]initWithX:-1000 andY:-1000];
//        if([Threshold intersectOfSegmentsWithLine1:lineUnit Line2:[triangleGraphTemp.triangleLines objectAtIndex:j] Point:tempPoint])
//        {
//            //计算得到这两个多边形的某两条边存在交点，下面就是判断需不需要生成这个交点
//
//        }
//    }
//}

//识别跟另外一条直线的交点或者这条直线的顶点在自己身上
-(Boolean)recognizeConstraintWithLineGraph:(GCLineGraph *)lineGraph PointList:(NSMutableArray *)plist
{
    GCPoint* p1 = [[GCPoint alloc]initWithX:-1 andY:-1];
    [Threshold intersectOfLine1:lineUnit Line2:lineGraph.lineUnit Point:p1];
    int  work = [self judgeLegalIntersectionWithLine1:lineUnit Line2:lineGraph.lineUnit Point:p1];
    if(work == -1)
    {
        return NO;
    }
    else if(work == 1)
    {
        if(!lineGraph.hasStart)
        {
            GCPointGraph* tempPointGraph = [Threshold createNewPoint:p1];
            [lineGraph.lineUnit setstart:p1];
            [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:Point_On_Line Graph2:(GCGraph*)self Type2:Point_On_Line];
            [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:Start_Vertex_Of_Line Graph2:(GCGraph*)lineGraph Type2:Start_Vertex_Of_Line];
            tempPointGraph.is_on_line = tempPointGraph.is_vertex = YES;
            tempPointGraph.freedomType++;
            lineGraph.hasStart = YES;
            [plist addObject:tempPointGraph];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if(work == 2)
    {
        if(!lineGraph.hasEnd)
        {
            GCPointGraph* tempPointGraph = [Threshold createNewPoint:p1];
            [lineGraph.lineUnit setend:p1];
            [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:Point_On_Line Graph2:(GCGraph*)self Type2:Point_On_Line];
            [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:End_Vertex_Of_Line Graph2:(GCGraph*)lineGraph Type2:End_Vertex_Of_Line];
            tempPointGraph.is_on_line = tempPointGraph.is_vertex = YES;
            tempPointGraph.freedomType++;
            lineGraph.hasEnd = YES;
            [plist addObject:tempPointGraph];
            
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if(work == 0)
    {
        GCPointGraph* tempPointGraph = [Threshold createNewPoint:p1];
        for(int i=0; i<lineGraph.constraintList.count; i++)
        {
            Constraint* tempConstraint = [lineGraph.constraintList objectAtIndex:i];
            if(tempConstraint.constraintType == Point_On_Line)
            {
                GCPointGraph* tempPointGraph1 = (GCPointGraph*)tempConstraint.relatedGraph;
                if([Threshold Distance:tempPointGraph.pointUnit.start :tempPointGraph1.pointUnit.start] <= is_point_connection)
                {
                    return YES;
                }
            }
        }
        [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:Point_On_Line Graph2:(GCGraph*)self Type2:Point_On_Line];
        [self constructConstraintGraph1:(GCGraph*)tempPointGraph Type1:Point_On_Line Graph2:(GCGraph*)lineGraph Type2:Point_On_Line];
        tempPointGraph.is_on_line = YES;
        tempPointGraph.freedomType+=2;
        [plist addObject:tempPointGraph];
        
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)recognizeConstraint:(NSMutableArray *)plist
{
    //首先判断首末点是否能跟点列表里的图元连在一起
    for(int i=0; i<plist.count; i++)
    {
        GCPointGraph* pointTemp = [plist objectAtIndex:i];
        if([Threshold Distance:lineUnit.start :pointTemp.pointUnit.start] <= is_point_connection)
        {
            [lineUnit setstart:pointTemp.pointUnit.start];
            self.hasStart = YES;
            pointTemp.is_vertex = YES;
            /*!!!!!!!!!!!function not check!!!!!!!!!!!!!!*/
            [self constructConstraintGraph1:(GCGraph*)self Type1:Start_Vertex_Of_Line Graph2:(GCGraph*)pointTemp Type2:Start_Vertex_Of_Line];
            
        }
        else if([Threshold Distance:lineUnit.end :pointTemp.pointUnit.start] <= is_point_connection)
        {
            [lineUnit setend:pointTemp.pointUnit.start];
            self.hasEnd = YES;
            pointTemp.is_vertex = YES;
            /*!!!!!!!!!!!function not check!!!!!!!!!!!!!!*/
            [self constructConstraintGraph1:(GCGraph*)self Type1:End_Vertex_Of_Line Graph2:(GCGraph*)pointTemp Type2:End_Vertex_Of_Line];
            
        }
    }
    /*!!!!!!!!!!!!!!!point constraint to line not implement!!!!!!!!!!!!!!!!!!!*/
    //然后，如果直线的两端都已经连到了某个点上，则返回；若只有其中一个或没有点跟点列表里面的点存在关系，则判断是否有点在直线上的关系
    if(hasStart && hasEnd)
    {
        return;
    }
    else
    {
        for(int i=0; i<plist.count; i++)
        {
            float length_of_line = [Threshold Distance:lineUnit.start :lineUnit.end];
            GCPointGraph* pointTemp = [plist objectAtIndex:i];
            if(([Threshold pointToLine:pointTemp :self] <= is_point_on_lines)
               && ([Threshold Distance:lineUnit.start :pointTemp.pointUnit.start] <= length_of_line)
               && ([Threshold Distance:lineUnit.end :pointTemp.pointUnit.start] <= length_of_line)
               && ([Threshold Distance:lineUnit.start :pointTemp.pointUnit.start] >= is_point_connection)
               && ([Threshold Distance:lineUnit.end :pointTemp.pointUnit.start] >= is_point_connection))
            {
                if(hasEnd && (!hasStart))
                {
                    //点在直线上的条件满足，则要以末尾点为基准，调整直线的K和B，以及起点的位置
                    /*!!!!!!!!!!!!!!function not define!!!!!!!!!!!!!!!!!*/
                    [self adjustVertex:pointTemp.pointUnit.start :0];
                }
                else
                {
                    //其他情况都是调整末尾点的位置
                    /*!!!!!!!!!!!!!!function not define!!!!!!!!!!!!!!!!!*/
                    [self adjustVertex:pointTemp.pointUnit.start :1];
                }
                pointTemp.is_on_line = true;
                pointTemp.freedomType++;
                [self constructConstraintGraph1:(GCGraph*)self Type1:Point_On_Line Graph2:(GCGraph*)pointTemp Type2:Point_On_Line];
            }
        }
    }
}

-(void)adjustVertex:(GCPoint *)point :(int)num
{
    float length = [Threshold Distance:lineUnit.start :lineUnit.end];
    if(num == 0)
    {
        //即要调整起点
        GCPoint* a = [[GCPoint alloc]initWithX:lineUnit.start.x-lineUnit.end.x andY:lineUnit.start.y-lineUnit.end.y];
        GCPoint* b = [[GCPoint alloc]initWithX:point.x-lineUnit.end.x andY:point.y-lineUnit.end.y];
        
        if([Threshold angle_of_vectors:a :b] >= can_be_adjust)
        {
            return;
        }
        //先给一个临时的新的起点，以便计算新的K值
        [lineUnit setstartX:point.x Y:point.y];
        if(lineUnit.k != MAX_K)
        {
            float x1 = (float)(lineUnit.end.x + sqrtf(length*length/(lineUnit.k*lineUnit.k+1)));
            float x2 = (float)(lineUnit.end.x - sqrtf(length*length/(lineUnit.k*lineUnit.k+1)));
            //即P点肯定要在这个线段的中
            float x = ((point.x-lineUnit.end.x)*(point.x-x1)<0)? x1:x2;
            float y = lineUnit.k*x + lineUnit.b;
            [lineUnit setstartX:x Y:y];
        }
        else if(lineUnit.k == MAX_K)
        {
            float y1 = (float)lineUnit.end.y+length;
            float y2 = (float)lineUnit.end.y-length;
            float y =  ((point.y-lineUnit.end.y)*(point.y-y1)<0)?y1:y2;
            [lineUnit setstartX:lineUnit.end.x Y:y];
        }
    }
    else if(num == 1)
    {
        //即要调整末尾点
        GCPoint* a = [[GCPoint alloc]initWithX:lineUnit.end.x-lineUnit.start.x andY:lineUnit.end.y-lineUnit.start.y];
        GCPoint* b = [[GCPoint alloc]initWithX:point.x-lineUnit.start.x andY:point.y-lineUnit.start.y];
        
        if([Threshold angle_of_vectors:a :b] >= can_be_adjust)
        {
            return;
        }
        //先给一个临时的新的起点，以便计算新的K值
        [lineUnit setendX:point.x Y:point.y];
        if(lineUnit.k != MAX_K)
        {
            float x1 = (float)(lineUnit.start.x + sqrtf(length*length/(lineUnit.k*lineUnit.k+1)));
            float x2 = (float)(lineUnit.start.x - sqrtf(length*length/(lineUnit.k*lineUnit.k+1)));
            //即P点肯定要在这个线段的中
            float x = ((point.x-lineUnit.start.x)*(point.x-x1)<0)? x1:x2;
            float y = lineUnit.k*x + lineUnit.b;
            [lineUnit setendX:x Y:y];
        }
        else if(lineUnit.k == MAX_K)
        {
            float y1 = (float)lineUnit.start.y+length;
            float y2 = (float)lineUnit.start.y-length;
            float y =  ((point.y-lineUnit.start.y)*(point.y-y1)<0)?y1:y2;
            [lineUnit setendX:lineUnit.start.x Y:y];
        }
    }
    else
        return;
}

//-(void)dealloc
//{
//    [lineUnit release];
//    [super dealloc];
//}

@end
