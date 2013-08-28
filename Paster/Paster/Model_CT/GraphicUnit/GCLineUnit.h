//
//  GCLineUnit.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraphicUnit.h"
#import "GCPointUnit.h"
#import "GCPoint.h"
#import "Threshold.h"

@interface GCLineUnit : GCGraphicUnit
{
    double k;// 斜 率
    double b;// 偏 移
    
    bool isCutLine;
    GCPoint* cutPoint;
}

@property (readwrite) double k;
@property (readwrite) double b;
@property (readwrite) bool   isCutLine;
@property (retain)    GCPoint* cutPoint;

-(BOOL) judge:(NSMutableArray *) pList;// 计 算 出 直 线 的 相 关 系 数   通 过 相 关 系 数 进 行 判 断 是 否 为 直 线
-(void) setstart:(GCPoint *) newstart;
-(id)initWithPoints:(NSMutableArray *)points ;
-(void) setend:(GCPoint*) newend;
-(void) setstartX:(float) newstart_x  Y:(float) newstart_y;
-(void) setendX:(float) newend_x  Y:(float) newend_y;
-(void) calculateK_B;
-(void) setOriginal;
-(double) OriginalK;
-(double) OriginalB;

-(void)drawWithContext:(CGContextRef)context;


@end
