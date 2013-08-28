//
//  GCCurveGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCPointGraph.h"
#import "GCLineGraph.h"
#import "GCTriangleGraph.h"
#import "GCCurveUnit.h"
#import "GCLineUnit.h"

@class GCLineUnit;
@class GCCurveUnit;
@class GCLineGraph;
@class GCTriangleGraph;
@class GCPointGraph;

@interface GCCurveGraph : GCGraph
{
    GCCurveUnit* curveUnit;
    
    Boolean hasStart;
    Boolean hasEnd;
    
    NSMutableArray* twoPointOnCurveLineList;
    NSMutableArray* onePointOnCurveLineList;
}
@property (retain)  GCCurveUnit* curveUnit;

@property (readwrite) Boolean hasStart;
@property (readwrite) Boolean hasEnd;

@property (retain)  NSMutableArray* twoPointOnCurveLineList;
@property (retain)  NSMutableArray* onePointOnCurveLineList;

-(id)initWithCurveUnit:(GCCurveUnit*)curveUnitLocal ID:(int)tempLocalGraphID;

-(void)drawWithContext:(CGContextRef)context;

-(void)getCurveUnitByUnit:(GCCurveUnit*)tempCurveUnit;
-(void)setOrigalMajorMinorAxis;
-(void)recognizeConstraintWithPointList:(NSMutableArray*)pointList;


@end
