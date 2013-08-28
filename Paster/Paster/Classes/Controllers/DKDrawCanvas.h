//
//  DKDrawCanvas.h
//  Sketch Integration
//
//  Created by  on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GCBoardView.h"
#import "EnumClass.h"

@interface DKDrawCanvas : NSObject
{
    GCBoardView *drawCanvasView;
    NSMutableArray* juedgeGeoArray;
    GeometryType geometryForJudge;
}

//@property (retain, nonatomic) GCBoardView *drawCanvasView;
@property (retain, nonatomic) NSMutableArray* juedgeGeoArray;
@property (assign, nonatomic) GeometryType geometryForJudge;

-(void)initWithPlist;

//-(CGRect)judegeRec:(CGPoint)point;
//-(int)judgeGeometryForDraw;
//-(int)judgeTriangle:(SCTriangleGraph*)triangleGraph;
//-(int)judgeRectangle:(SCRectangleGraph*)rectangleGraph SpecialType:(GeometryType)geometryType;
//-(int)judgeCurveGraph:(SCCurveGraph*)curveGraph SpecialType:(GeometryType)geometryType;
//-(int)judgeFiveStar;

-(void)undo;
-(void)redo;
-(void)deleteCanvas;

@end
