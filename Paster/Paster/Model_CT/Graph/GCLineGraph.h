//
//  GCLineGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCTriangleGraph.h"
#import "GCRectangleGraph.h"
#import "GCPointGraph.h"
#import "GCLineUnit.h"
#import "Constraint.h"
#import "ConstraintGraph.h"

@class GCLineUnit;
//@class GCGraph;
//@class GCPoint;
//@class GCPointGraph;
//@class GCLineGraph;
//@class GCTriangleGraph;
//@class GCRectangleGraph;
//@class Constraint;
//@class ConstraintGraph;

@interface GCLineGraph : GCGraph
{
    GCLineUnit* lineUnit;
    
    //用于识别约束时表示直线的端点有没有跟点列表的点图形连到一起
    bool hasStart;
    bool hasEnd;
    
    //用于标识直线是否为三角形的三角形的特殊线
    bool isSpecial;
    //用于标识直线是否为切线
    bool isTangent;
}

@property (retain) GCLineUnit* lineUnit;
@property (readwrite) bool      hasStart;
@property (readwrite) bool      hasEnd;
@property (readwrite) bool      isSpecial;
@property (readwrite) bool      isTangent;

-(id)initWithLine:(GCLineUnit*)lineUnit1 andId:(int)temp_local_graph_id;

-(void)drawWithContext:(CGContextRef)context;

//识别约束部分
//用以约束识别开始阶段时的直线和存在的点之间的约束识别
-(void)recognizeConstraint:(NSMutableArray*)plist;
//用于固定一端后来根据一个直线上新的点来调整另一端的位置,0为start，1为end
-(void)adjustVertex:(GCPoint*)point :(int)num;
-(Boolean)recognizeConstraintWithGraph:(GCGraph*)graph PointList:(NSMutableArray*)plist;
-(Boolean)recognizeConstraintWithLineGraph:(GCLineGraph*)lineGraph PointList:(NSMutableArray*)plist;
-(int)judgeLegalIntersectionWithLine1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Point:(GCPoint*)p2;

@end
