//
//  GCTriangleGraph.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCTriangleGraph.h"

@implementation GCTriangleGraph

@synthesize triangleLines,triangleAngles,triangleVertexes,triangleLineDistance;
@synthesize triangleType,typeVertexIndex;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        triangleAngles       = [[NSMutableArray alloc]init];
        triangleLines        = [[NSMutableArray alloc]init];
        triangleVertexes     = [[NSMutableArray alloc]init];
        triangleLineDistance = [[NSMutableArray alloc]init];
        self.graphType = Triangle_Graph;
    }
    
    return self;
}

-(id)initWithLine0:(GCLineUnit *)line0 Line1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Id:(int)temp_local_id
{
    self = [self init];
    //    self = [super initWithId:temp_local_id];
    [self initValuesWithLine0:line0 Line1:line1 Line2:line2];
    return self;
}

-(id)initWithLine0:(GCLineUnit *)line0 Line1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Id:(int)temp_local_graph_id Vertex0:(GCPoint *)vertex0 Vertex1:(GCPoint *)vertex1 Vertex2:(GCPoint *)vertex2
{
    self = [self init];
    
    //    [super initWithId:temp_local_graph_id];
    //    [self initValuesWithLine0:line0 Line1:line1 Line2:line2];
    
    [self.triangleVertexes addObject:vertex0];
    [self.triangleVertexes addObject:vertex1];
    [self.triangleVertexes addObject:vertex2];
    
    GCLineUnit* l1 = [[GCLineUnit alloc]initWithStartPoint:vertex0 endPoint:vertex1];
    GCLineUnit* l2 = [[GCLineUnit alloc]initWithStartPoint:vertex1 endPoint:vertex2];
    GCLineUnit* l3 = [[GCLineUnit alloc]initWithStartPoint:vertex2 endPoint:vertex0];
    
    [self initValuesWithLine0:l1 Line1:l2 Line2:l3];
    
//    [l1 release];
//    [l2 release];
//    [l3 release];
    
    return self;
}

-(void)initValuesWithLine0:(GCLineUnit *)line0 Line1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2
{
    [triangleLines addObject:line0];
    [triangleLines addObject:line1];
    [triangleLines addObject:line2];
    
    //[self setVertex];
}

-(void)setVertex
{
    GCPoint* v0 = [[GCPoint alloc]initWithX:0.0f andY:0.0f];
    GCPoint* v1 = [[GCPoint alloc]initWithX:0.0f andY:0.0f];
    GCPoint* v2 = [[GCPoint alloc]initWithX:0.0f andY:0.0f];
    
    [triangleVertexes removeAllObjects];
    [triangleVertexes addObject:v0];
    [triangleVertexes addObject:v1];
    [triangleVertexes addObject:v2];
    
//    [v0 release];
//    [v1 release];
//    [v2 release];
    
    GCLineUnit* tl0 = [triangleLines objectAtIndex:0];
    GCLineUnit* tl1 = [triangleLines objectAtIndex:1];
    GCLineUnit* tl2 = [triangleLines objectAtIndex:2];
    
    v0 = [triangleVertexes objectAtIndex:0];
    v1 = [triangleVertexes objectAtIndex:1];
    v2 = [triangleVertexes objectAtIndex:2];
    
    if((tl1.start.x==tl2.start.x&&tl1.start.y==tl2.start.y)
       ||(tl1.start.x==tl2.end.x&&tl1.start.y==tl2.end.y))
    {
        v0.x=tl1.start.x;
        v0.y=tl1.start.y;
    }
    if((tl1.end.x==tl2.start.x&&tl1.end.y==tl2.start.y)
       ||(tl1.end.x==tl2.end.x&&tl1.end.y==tl2.end.y))
    {
        v0.x=tl1.end.x;
        v0.y=tl1.end.y;
    }
    if((tl0.start.x==tl2.start.x&&tl0.start.y==tl2.start.y)
       ||(tl0.start.x==tl2.end.x&&tl0.start.y==tl2.end.y))
    {
        v1.x=tl0.start.x;
        v1.y=tl0.start.y;
    }
    if((tl0.end.x==tl2.start.x&&tl0.end.y==tl2.start.y)
       ||(tl0.end.x==tl2.end.x&&tl0.end.y==tl2.end.y))
    {
        v1.x=tl0.end.x;
        v1.y=tl0.end.y;
    }
    if((tl0.start.x==tl1.start.x&&tl0.start.y==tl1.start.y)
       ||(tl0.start.x==tl1.end.x&&tl0.start.y==tl1.end.y))
    {
        v2.x=tl0.start.x;
        v2.y=tl0.start.y;
    }
    if((tl0.end.x==tl1.start.x&&tl0.end.y==tl1.start.y)
       ||(tl0.end.x==tl1.end.x&&tl0.end.y==tl1.end.y))
    {
        v2.x=tl0.end.x;
        v2.y=tl0.end.y;
    }
    
    [tl0 setstart:v1];
    [tl0 setend:v2];
    [tl1 setstart:v2];
    [tl1 setend:v0];
    [tl2 setstart:v0];
    [tl2 setend:v1];
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, self.strokeSize);
    CGContextSetStrokeColorWithColor(context, self.graphColor);
    
    //画三条边
    for(int i=0; i<3; i++)
    {
        GCLineUnit* line = [triangleLines objectAtIndex:i];
        [line drawWithContext:context];
    }
}

//-(void)dealloc
//{
//    [triangleLines release];
//    [triangleVertexes release];
//    [triangleAngles release];
//    [triangleLineDistance release];
//    
//    [super dealloc];
//}

@end
