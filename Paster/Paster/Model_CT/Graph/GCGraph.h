//
//  GCGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGraphicUnit.h"
//#import "Constraint.h"
//#import "ConstraintGraph.h"

@interface GCGraph : NSObject
{
    int local_graph_id;
    
    //用于存储时标识出图形的类型
    //0 PointGraph 1 LineGraph 2 CurveGraph 3 TriangleGraph 4 RectangleGraph 5 OtherGraph
    GraphType graphType;
    
    NSMutableArray* constraintList;
    
    float strokeSize;
    CGColorRef graphColor;
    
    bool isSelected;
    bool isDraw;
}

@property (retain)    NSMutableArray*   constraintList;
@property (readwrite) int               local_graph_id;
@property (readwrite) GraphType         graphType;
@property (readwrite) bool              isDraw;
@property (readwrite) bool              isSelected;
@property (assign,nonatomic) CGColorRef graphColor;
@property (assign,nonatomic) float      strokeSize;

-(id)initWithId:(int)temp_local_graph_id;
-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1;

-(void)setGraphColorWithColorRef:(CGColorRef)colorRef;
//虚函数，不可被注释
-(void)drawWithContext:(CGContextRef)context;

-(void)constructConstraintGraph1:(GCGraph*)graph1 Type1:(ConstraintType)type1 Graph2:(GCGraph*)graph2 Type2:(ConstraintType)type2;
-(Boolean)recognizeConstraintWithGraph:(GCGraph*)graphTemp PointList:(NSMutableArray*)pointList;
-(void)clearConstraint;

@end
