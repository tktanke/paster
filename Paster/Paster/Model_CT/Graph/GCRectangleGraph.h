//
//  GCRectangleGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCCurveGraph.h"
#import "GCLineGraph.h"
#import "GCPointGraph.h"
#import "GCLineUnit.h"
#import "GCGraphicUnit.h"

@class GCLineUnit;
@class SCCurveGraph;
@class GCLineGraph;
@class GCPointGraph;

typedef enum
{
    OrdinaryRectangleForGraph = 0,
    SquareForGraph = 1,
    RectangleForGraph = 2,
    PrismaticForGraph = 3,
    ParallelForGraph  = 4,
    TrapezoidForGraph = 5,
    IscoTrapezoidForGraph = 6,
    RightTrapezoidForGraph = 7
}RectangleType;

@interface GCRectangleGraph : GCGraph
{
    NSMutableArray* rec_vertexes;
    NSMutableArray* rec_lines;
    
    NSMutableArray* vertical_index;    //记录哪些角是直角
    NSMutableArray* node_index;        //通过标识顶点来标识不同内心的四边形
    
    //代表四边形的类型
    //0代表一般四边形，1代表正方形，2代表矩形，3代表菱形，4代表平行四边形，5代表一般梯形，6代表等腰梯形，7代表直角梯形
    RectangleType rectangleType;
}

@property (retain) NSMutableArray* rec_vertexes;
@property (retain) NSMutableArray* rec_lines;

-(id)initWithLine0:(GCLineUnit*)line0 Line1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Line3:(GCLineUnit*)line3 Id:(int)temp_local_id;

//将四边形整成逆时针
-(void)setLinePointsLine0:(GCLineUnit*)line1 Line1:(GCLineUnit*)line2 Line2:(GCLineUnit*)line3 Line3:(GCLineUnit*)line4;
-(void)changeRectangleLines;
-(Boolean)is_not_connect:(GCLineUnit*)line1 :(GCLineUnit*)line2;
-(Boolean)is_anticloclkwise:(GCPoint*)v0 :(GCPoint*)v1 :(GCPoint*)v2;


-(void)drawWithContext:(CGContextRef)context;

@end
