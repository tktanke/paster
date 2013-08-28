//
//  Constraint.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCGraph.h"
#import "GCPointUnit.h"
#import "GCPointGraph.h"
#import "GCLineGraph.h"

@class GCGraph;
@class GCPointGraph;
@class GCLineGraph;

@interface Constraint : NSObject
{
    int related_graph_id;
    int lastGraphSize;
    int lastSelectedGraphSize;
    
    ConstraintType constraintType;
    GCGraph*       relatedGraph;
    
    NSMutableArray* point_list;
    NSMutableArray* graph_list;
    NSMutableArray* selected_list;
    NSMutableArray* delete_graph;
}

@property (readwrite) ConstraintType   constraintType;
@property (readwrite) int              related_graph_id;
@property (readwrite,assign,nonatomic) int    lastGraphSize;
@property (assign,nonatomic) int lastSelectedGraphSize;

@property (retain,nonatomic) GCGraph*        relatedGraph;
@property (retain,nonatomic) NSMutableArray* point_list;
@property (retain,nonatomic) NSMutableArray* graph_list;
@property (retain,nonatomic) NSMutableArray* selected_list;
@property (retain,nonatomic) NSMutableArray* delete_graph;

//constraint初始化
//-(id)initWith:(NSMutableArray* (GCPointGraph*)) pointList;
-(id)initWithPointList:(NSMutableArray*)pointList GraphList:(NSMutableArray*)graphList SeletedList:(NSMutableArray*)selectedList;

//识别约束关系
-(void)recognizeConstraint;

//上个图形的大小
-(void)setLastGraphSizeByN:(int)n;
//得到线的一个端点
-(void)getLineVertexWithGraph:(GCGraph*)graph StartPoint:(GCPointGraph **)start  EndPoint:(GCPointGraph **)end;
//得到线的另一个端点
-(void)getAnotherVertexWithGraph:(GCGraph*)graph Point:(GCPointGraph*) point ConnectLine:(NSMutableArray**)connectLine ConnectLinePoint:(NSMutableArray**)connectLinePoint;
//得到第三个端点
-(bool)findTheThirdPointWithThirdPoint:(GCPointGraph**) thirdPoint SecondLine:(GCLineGraph**) secondLine ThirdLine:(GCLineGraph**) thirdLine StartConnectLinePoint:(NSMutableArray*) startConnectLinePoint EndConnectLinePoint:(NSMutableArray*) endConnectLinePoint StartConnectLine:(NSMutableArray*)startConnectLine EndConnectLine:(NSMutableArray*)endConnectLine;
//是否可以构成一个三角形
-(bool)canBeRectangleWithThirdPoint:(GCPointGraph**)thirdPoint FourthPoint:(GCPointGraph**)fourthPoint SecondLine:(GCLineGraph**)secondLine ThirdLine:(GCLineGraph**)thirdLine FourthLine:(GCLineGraph**)fourthLine StartConnectLinePoint:(NSMutableArray*)startConnectLinePoint EndConnectLinePoint:(NSMutableArray*)endConnectLinePoint StartConnectLine:(NSMutableArray*)startConnectLine EndConnectLine:(NSMutableArray*)endConnectLine;
//重新创建三角形，四边形
-(BOOL)rebuildTriangleRectangleWithGraph:(GCGraph*)graph;
//建立三角形
-(void)buildTriangleWithFirstLine:(GCLineGraph*)firstLine SecondLine:(GCLineGraph*)secondLine ThirdLine:(GCLineGraph*)thirdLine Start:(GCPointGraph*)start End:(GCPointGraph*)end ThirdPoint:(GCPointGraph*)thirdPoint;
//建立四边形
-(void)buildRectangleWithPoint0:(GCPointGraph*)v0 Point1:(GCPointGraph*)v1 Point2:(GCPointGraph*)v2 Point3:(GCPointGraph*)v3 FirstLine:(GCLineGraph*)firstLine SecondLine:(GCLineGraph*)secondLine ThirdLine:(GCLineGraph*)thirdLine FourthLine:(GCLineGraph*)fourthLine;
//建立三角四边形
-(void)bindToTriangleRectangleWithPoint:(GCPointGraph*) point Graph:(GCGraph*) graph i:(int) i;
//把线弄成三角四边形的线
-(void)transformLineToTriangleRectangleWithLine:(GCLineGraph*) lineGraph Graph:(GCGraph*)graph;
//清除图形
-(void)eraseGraphFromGraphListWithGraph:(GCGraph*)graph GraphList:(NSMutableArray**)graphList;
//清楚约束
-(void)eraseConstraintWithLocal:(GCGraph*)local RelatedGraph:(GCGraph*)relatedGraph;

@end
