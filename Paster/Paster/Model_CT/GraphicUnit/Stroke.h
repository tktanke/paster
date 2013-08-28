//
//  Stroke.h
//  Dudel
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPoint.h"
#import "Threshold.h"
#import "GCGraphicUnit.h"
#import "GCPointUnit.h"
#import "GCLineUnit.h"
#import "GCCurveUnit.h"

@interface Stroke : NSObject 
{
    NSMutableArray *pList;
    NSMutableArray *gList;
    NSMutableArray *specialList;
    float as,ad,ac;
}
@property (retain,nonatomic) NSMutableArray *pList;
@property (retain,nonatomic) NSMutableArray *gList;
@property (retain,nonatomic) NSMutableArray *specialList;
-(id) initWithPoints:(NSMutableArray *) x;
-(void) findSpecialPoints;
-(GCGraphicUnit*) recognize:(NSMutableArray *)tempPoints;
//-(BOOL) rebuild_line;
//-(BOOL) rebuild_triangle;
//-(BOOL) rebuild_rectangle;
//-(BOOL) rebuild_hybridunit;

-(void) speed;// 速 度 过 滤 方 法 ： 低 于 平 均 值 的 一 定 百 分 比 算 是 特 征 点
-(void) curvity;// 曲 率 过 滤
-(void) direction;// 方 向 过 滤
-(void) space;// 进 一 步 处 理

@end
