//
//  GCGraphFactory.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCAbstractFactory.h"
#import "GCGraphicUnit.h"
#import "GCPointUnit.h"
#import "GCLineUnit.h"
#import "GCCurveUnit.h"
#import "GCGraph.h"
#import "GCPointGraph.h"
#import "GCLineGraph.h"
#import "GCCurveGraph.h"
#import "GCRectangleGraph.h"
#import "GCTriangleGraph.h"
#import "Constraint.h"
#import "ConstraintGraph.h"
#import "Stroke.h"

@interface GCGraphFactory : GCAbstractFactory
{
    NSMutableArray * pList;
}

-(id)initWithParameter:(NSMutableArray *)pList;

-(GCGraph*)createWithSimpleUnit:(GCGraphicUnit *)unit
                       UnitList:(NSMutableArray *)unitList;
-(NSMutableArray*)createComplexGraph:(Stroke *)stroke
                     UnitList:(NSMutableArray *)unitList;

-(BOOL)rebuild_line:(Stroke *)stroke;
-(BOOL)rebuild_triangle:(Stroke *)stroke;
-(BOOL)rebuild_rectangle:(Stroke *)stroke;
-(BOOL)rebuild_hybridunit:(Stroke *)stroke;

-(GCGraph *) create_Line_Graph:(Stroke *) stroke
                              :(NSMutableArray *)unitList
                              :(NSMutableArray*)pointGraphList;
-(GCGraph *) create_Triangle_Graph:(Stroke *)stroke
                                  :(NSMutableArray *)unitList
                                  :(NSMutableArray *)pointGraphList;
-(GCGraph*) create_Rectangle_Graph:(Stroke*)stroke
                                  :(NSMutableArray*)unitList
                                  :(NSMutableArray*)pointList;


@end
