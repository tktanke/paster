//
//  GCUnitFactory.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCUnitFactory.h"

@implementation GCUnitFactory

-(id)init
{
    self = [super init];
    if(self)
    {
        newPointList = nil;
        stroke = nil;
    }
    return self;
}

-(GCGraphicUnit *)createWithPoint:(NSMutableArray *)pList Unit:(NSMutableArray *)unitList Graph:(NSMutableArray *)graphList PointGraph:(NSMutableArray *)pointGraphList NewGraph:(NSMutableArray *)newGraphList
{
    PenInfo * penInfo = [[PenInfo alloc] initWithPoints:pList];
    newPointList = [penInfo newPenInfo];
    
    GCGraphicUnit * unit = [self firstUnitRecognize:newPointList];
    return unit;
}

-(GCGraphicUnit *)firstUnitRecognize:(NSMutableArray *)pList
{
    GCGraphicUnit* unit = NULL;
    int pointNum = [pList count];
    GCPoint *s;
    GCPoint *e;
    s = [pList objectAtIndex:0];
    e = [pList lastObject];
    //既当输入点少于10个，且收尾的距离小于12时为点图元
    if(0 < pointNum && pointNum <= point_pix_number
       &&  [Threshold Distance:s :e]<12)
    {
        unit=[[GCPointUnit alloc] initWithPoints:pList];
        return unit;
    }
    else
    {
        GCLineUnit* line = [[GCLineUnit alloc] initWithPoints:pList];
        if([line judge:pList])
        {
            unit=line;
            return unit;
        }
        else
        {
            return nil;
            /*GCCurveUnit* curve = [[GCCurveUnit alloc] initWithPointArray:pList];
            if([curve isSecondDegreeCurveWithPointArray:pList])
            {
                NSMutableArray* tempPointList = pList;
                stroke = [[Stroke alloc]initWithPoints:tempPointList];
                [stroke findSpecialPoints];
                BOOL isTriangle = [stroke rebuild_triangle];
                BOOL isRectangle = [stroke rebuild_rectangle];
                if(!isTriangle && !isRectangle)
                {
                    [curve judgeCurveWithPointArray:pList];
                    return curve;
                }
                else
                {
                    unit = NULL;
                    return unit;
                }
            }
            else
            {
                unit = NULL;
                return unit;
            }*/
        }
    }
}

-(Stroke *)getStroke
{
    if(stroke == nil)
    {
        stroke = [[Stroke alloc]initWithPoints:newPointList];
        [stroke findSpecialPoints];
    }
    return stroke;
}



@end
