//
//  GCRectangleGraph.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCRectangleGraph.h"

@implementation GCRectangleGraph

@synthesize rec_lines,rec_vertexes;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        rec_lines = [[NSMutableArray alloc]init];
        rec_vertexes = [[NSMutableArray alloc]init];
        self.graphType = Rectangle_Graph;
    }
    
    return self;
}

-(id)initWithLine0:(GCLineUnit*)line0 Line1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Line3:(GCLineUnit*)line3 Id:(int)temp_local_id
{
    self = [self init];
    
    //    [super initWithId:temp_local_id];
    
    rectangleType = OrdinaryRectangleForGraph;
    self.graphType = Rectangle_Graph;
    
    //    [rec_vertexes addObject:line0.start];
    //    [rec_vertexes addObject:line1.start];
    //    [rec_vertexes addObject:line2.start];
    //    [rec_vertexes addObject:line3.start];
    //
    //    GCLineUnit* l1 = [[GCLineUnit alloc]initWithStartPoint:line0.start endPoint:line1.start];
    //    GCLineUnit* l2 = [[GCLineUnit alloc]initWithStartPoint:line1.start endPoint:line2.start];
    //    GCLineUnit* l3 = [[GCLineUnit alloc]initWithStartPoint:line2.start endPoint:line3.start];
    //    GCLineUnit* l4 = [[GCLineUnit alloc]initWithStartPoint:line3.start endPoint:line0.start];
    
    //    [rec_lines addObject:l1];
    //    [rec_lines addObject:l2];
    //    [rec_lines addObject:l3];
    //    [rec_lines addObject:l4];
    
    [self setLinePointsLine0:line0 Line1:line1 Line2:line2 Line3:line3];
    
    return self;
    
}

-(Boolean)is_not_connect:(GCLineUnit*)line1 :(GCLineUnit*)line2
{
    if(![Threshold isEqualPoint1:line1.start Point2:line2.start] &&
       ![Threshold isEqualPoint1:line1.start Point2:line2.end] &&
       ![Threshold isEqualPoint1:line1.end Point2:line2.start] &&
       ![Threshold isEqualPoint1:line1.end Point2:line2.end])
        return YES;
    return NO;
}

-(Boolean)is_anticloclkwise:(GCPoint*)v0 :(GCPoint*)v1 :(GCPoint*)v2
{
    GCPoint* vec1 = [[GCPoint alloc]initWithX:(v0.x-v1.x) andY:(v0.y-v1.y)];
    GCPoint* vec2 = [[GCPoint alloc]initWithX:(v2.x-v1.x) andY:(v2.y-v1.y)];
    
    if((vec2.x*vec1.y - vec2.y*vec1.x)>=0)
        return YES;
    return NO;
}

-(void)setLinePointsLine0:(GCLineUnit*)line1 Line1:(GCLineUnit*)line2 Line2:(GCLineUnit*)line3 Line3:(GCLineUnit*)line4
{
    GCPoint* v0 = [[GCPoint alloc]initWithX:line1.start.x andY:line1.start.y];
    GCPoint* v1 = [[GCPoint alloc]initWithX:line1.end.x andY:line1.end.y];
    GCPoint* v2 = [[GCPoint alloc]initWithX:0.0f andY:0.0f];
    GCPoint* v3 = [[GCPoint alloc]initWithX:0.0f andY:0.0f];
    //    GCPoint* v0 = line1.start;
    //    GCPoint* v1 = line1.end;
    //    GCPoint* v2 = NULL;
    //    GCPoint* v3 = NULL;
    
    if([self is_not_connect:line1 :line2])
    {
        float k=(line2.start.y-v0.y)/(line2.start.x-v0.x);
        if((k/line3.k>k_equal_minimal&&k/line3.k<k_equal_max)||
           (k/line4.k>k_equal_minimal&&k/line4.k<k_equal_max))
        {
            //            v2=line2.end;
            //            v3=line3.start;
            v2.x=line2.end.x;
            v2.y=line2.end.y;
            
            v3.x=line3.start.x;
            v3.y=line3.start.y;
        }
        else
        {
            //            v2=line3.start;
            //            v3=line3.end;
            v2.x=line3.start.x;
            v2.y=line3.start.y;
            
            v3.x=line3.end.x;
            v3.y=line3.end.y;
        }
    }
    else if([self is_not_connect:line1 :line3])
    {
        float k=(line3.start.y-v0.y)/(line3.start.x-v0.x);
        if((k/line2.k>k_equal_minimal&&k/line2.k<k_equal_max)||
           (k/line4.k>k_equal_minimal&&k/line4.k<k_equal_max))
        {
            //            v2=line3.end;
            //            v3=line3.start;
            v2.x=line3.end.x;
            v2.y=line3.end.y;
            
            v3.x=line3.start.x;
            v3.y=line3.start.y;
        }
        else
        {
            //            v2=line3.start;
            //            v3=line3.end;
            v2.x=line3.start.x;
            v2.y=line3.start.y;
            
            v3.x=line3.end.x;
            v3.y=line3.end.y;
        }
    }
    else
    {
        float k=(line4.start.y-v0.y)/(line4.start.x-v0.x);
        if((k/line2.k>k_equal_minimal&&k/line2.k<k_equal_max)||
           (k/line3.k>k_equal_minimal&&k/line3.k<k_equal_max))
        {
            //            v2=line4.end;
            //            v3=line4.start;
            v2.x=line4.end.x;
            v2.y=line4.end.y;
            
            v3.x=line4.start.x;
            v3.y=line4.start.y;
        }
        else
        {
            //            v2=line4.start;
            //            v3=line4.end;
            v2.x=line4.start.x;
            v2.y=line4.start.y;
            
            v3.x=line4.end.x;
            v3.y=line4.end.y;
        }
    }
    if([self is_anticloclkwise:v0 :v1 :v2])
    {
        //        [rec_vertexes addObject:v3];
        //        [rec_vertexes addObject:v2];
        //        [rec_vertexes addObject:v1];
        //        [rec_vertexes addObject:v0];
        
        [rec_vertexes addObject:v0];
        [rec_vertexes addObject:v1];
        [rec_vertexes addObject:v2];
        [rec_vertexes addObject:v3];
    }
    else
    {
        //        [rec_vertexes addObject:v0];
        //        [rec_vertexes addObject:v1];
        //        [rec_vertexes addObject:v2];
        //        [rec_vertexes addObject:v3];
        
        [rec_vertexes addObject:v3];
        [rec_vertexes addObject:v2];
        [rec_vertexes addObject:v1];
        [rec_vertexes addObject:v0];
    }
    
    //    [line1 setstart:v0];
    //    [line1 setend:v1];
    //    [line2 setstart:v1];
    //    [line2 setend:v2];
    //    [line3 setstart:v2];
    //    [line3 setend:v3];
    //    [line4 setstart:v3];
    //    [line4 setend:v0];
    [rec_lines addObject:line1];
    [rec_lines addObject:line2];
    [rec_lines addObject:line3];
    [rec_lines addObject:line4];
    [self changeRectangleLines];
    
//    [v0 release];
//    [v1 release];
//    [v2 release];
//    [v3 release];
}

-(void)changeRectangleLines
{
    for(int i=0; i<4; i++)
    {
        GCLineUnit* line = [rec_lines objectAtIndex:i];
        GCPoint* point = [rec_vertexes objectAtIndex:i];
        GCPoint* nextPoint = [rec_vertexes objectAtIndex:(i+1)%4];
        [line setstartX:point.x Y:point.y];
        [line setendX:nextPoint.x Y:nextPoint.y];
        [line calculateK_B];
    }
}

-(void)drawWithContext:(CGContextRef)context
{
    //画四条边
    CGContextSetLineWidth(context, self.strokeSize);
    CGContextSetStrokeColorWithColor(context, self.graphColor);
    for(int i=0; i<4; i++)
    {
        GCLineUnit* line = [rec_lines objectAtIndex:i];
        [line drawWithContext:context];
    }
    
    //画四个顶点
    //    for(int j=0; j<4; j++)
    //    {
    //        GCPoint* vertex = [rec_vertexes objectAtIndex:j];
    //        CGContextFillEllipseInRect(context, CGRectMake(vertex.x-5.0f, vertex.y-5.0f, 10, 10));
    //    }    
}

//-(void)dealloc
//{
//    [rec_lines release];
//    [rec_vertexes release];
//    [vertical_index release];
//    [node_index release];
//    [super dealloc];
//}

@end
