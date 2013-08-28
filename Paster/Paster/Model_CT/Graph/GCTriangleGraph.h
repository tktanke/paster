//
//  GCTriangleGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCRectangleGraph.h"
#import "GCCurveGraph.h"
#import "GCLineUnit.h"
#import "GCGraphicUnit.h"
#import "Constraint.h"

@class GCLineUnit;
@class GCCurveGraph;
@class GCRectangleGraph;

typedef enum
{
    OridinaryTriangle = 0,
    RightTriangle = 1,
    IsoscelesTriangle = 2,
    RightIsoTriagnle = 3,
    RegularTriangle = 4
}TriangleType;

@interface GCTriangleGraph : GCGraph
{
    //三角形的顶点和它的对边的下标保持着对应关系
    NSMutableArray* triangleLines;
    NSMutableArray* triangleVertexes;
    NSMutableArray* triangleAngles;
    NSMutableArray* triangleLineDistance;
    
    //标识三角形的类型
    //0代表普通三角形
    //1代表直角三角形
    //2代表等腰三角形
    //3代表等腰直角三角形
    //4代表正三角形
    TriangleType triangleType;
    int typeVertexIndex;
}

@property (retain) NSMutableArray* triangleLines;
@property (retain) NSMutableArray* triangleVertexes;
@property (retain) NSMutableArray* triangleAngles;
@property (retain) NSMutableArray* triangleLineDistance;
@property (readwrite) TriangleType triangleType;
@property (readwrite) int          typeVertexIndex;

-(void)initValuesWithLine0:(GCLineUnit *)line0 Line1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2;
-(id)initWithLine0:(GCLineUnit*)line0 Line1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Id:(int)temp_local_id;
-(id)initWithLine0:(GCLineUnit*)line0 Line1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Id:(int)temp_local_graph_id Vertex0:(GCPoint*)vertex0 Vertex1:(GCPoint*)vertex1 Vertex2:(GCPoint*)vertex2;
//-(int[])returnVertexTagWithIndex:(int)vertexIndex;
-(void)drawWithContext:(CGContextRef)context;

//约束部分的相关函数
//使得三角形的边和顶点为严格的逆时针
-(void)setVertex;

@end
