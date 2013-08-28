//
//  GCCurveGraph.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCCurveGraph.h"

@implementation GCCurveGraph

@synthesize curveUnit;
@synthesize hasEnd,hasStart,twoPointOnCurveLineList,onePointOnCurveLineList;

- (id)init
{
    self = [super initWithId:-1];
    if (self)
    {
        // Initialization code here.
        curveUnit = [[GCCurveUnit alloc]init];
        self.graphType = Curver_Graph;
    }
    
    return self;
}

-(id)initWithCurveUnit:(GCCurveUnit *)curveUnitLocal ID:(int)tempLocalGraphID
{
    //如果需要初始化派生类中的新增数据成员，请在此函数
    self = [self init];
    self.curveUnit = curveUnitLocal;
    graphType = Curver_Graph;
    self.hasStart = NO;
    self.hasEnd = NO;
    
    return self;
}

-(void)setOrigalMajorMinorAxis
{
    [curveUnit setOriginalMajorAndOriginalMinor];
}

-(void)getCurveUnitByUnit:(GCCurveUnit *)tempCurveUnit
{
    tempCurveUnit = curveUnit;
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, strokeSize);
    CGContextSetStrokeColorWithColor(context, graphColor);
    [curveUnit drawWithContext:context];
}


-(void)recognizeConstraintWithPointList:(NSMutableArray *)pointList
{
}
//
//-(void)dealloc
//{
//    [twoPointOnCurveLineList release];
//    [onePointOnCurveLineList release];
//    [curveUnit release];
//    
//    [super dealloc];
//}

@end
