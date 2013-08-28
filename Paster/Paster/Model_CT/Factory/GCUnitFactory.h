//
//  GCUnitFactory.h
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
#import "PenInfo.h"
#import "Stroke.h"

@interface GCUnitFactory : GCAbstractFactory
{
    NSMutableArray * newPointList;
    Stroke * stroke;
}

-(GCGraphicUnit *)createWithPoint:(NSMutableArray *)pList
                  Unit:(NSMutableArray *)unitList
                 Graph:(NSMutableArray *)graphList
            PointGraph:(NSMutableArray *)pointGraphList
              NewGraph:(NSMutableArray *)newGraphList;
-(GCGraphicUnit *)firstUnitRecognize:(NSMutableArray *)pList;
-(Stroke *)getStroke;

@end
