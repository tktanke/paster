//
//  GCPointGraph.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "GCPoint.h"
#import "GCPointUnit.h"
#import "GCLineUnit.h"
#import "Threshold.h"

@class GCLineUnit;
@class GCCurveUnit;

@interface GCPointGraph : GCGraph
{
    GCPointUnit* pointUnit;
    
    int freedomType;
    int curve_start_end;//1为起点，2为终点
    
    bool is_vertex;
    bool is_on_line;
    bool is_on_circle;
    bool belong_to_triangle;
    bool belong_to_rectangle;
    bool in_graph_list;
    bool cut_point_of_circles; //标识是否为两个圆的切点
    
    bool vertexOfCurveCenter; //只为半径标识
    bool vertexOfSpecialLine; //标识它是否为三角形特殊线的落在三角形边上的断点，在KEEP的时候有用
    
}

@property (retain)      GCPointUnit*      pointUnit;
@property (readwrite)   int             freedomType;
@property (readwrite)   int             curve_start_end;
@property (readwrite)   bool            is_vertex;
@property (readwrite)   bool            is_on_line;
@property (readwrite)   bool            is_on_circle;
@property (readwrite)   bool            belong_to_triangle;
@property (readwrite)   bool            belong_to_rectangle;
@property (readwrite)   bool            in_graph_list;
@property (readwrite)   bool            cut_point_of_circles;
@property (readwrite)   bool            vertexOfCurveCenter;
@property (readwrite)   bool            vertexOfSpecialLine;

-(id)initWithUnit:(GCPointUnit*)pointUnitTemp andId:(int)temp_local_graph_id;

-(void)setPoint:(GCPoint*)point;
-(Boolean)isUndo;
-(Boolean)isRedo;
-(void)resetAttribute;

-(void)drawWithContext:(CGContextRef)context;
-(void)draw_extension_line:(CGContextRef)context;
-(void)draw_dot_lineFromStart:(GCPoint*)startPoint ToEnd:(GCPoint*)endPoint WithContext:(CGContextRef)context;
-(void)draw_line_dot_extension_line:(GCLineUnit*)lineUnit WithContext:(CGContextRef)context;

@end
