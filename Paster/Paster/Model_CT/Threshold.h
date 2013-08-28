//
//  Threshold.h
//  SmartGeometry
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPoint.h"
#import "GCPointGraph.h"
#import "GCLineGraph.h"
#import "GCPointUnit.h"
#import "GCLineUnit.h"


extern const float PI;

//用于判断是否能成为三角形或四边形的阀值
extern const float is_closed;

//用于判定点是否在其他图形上,TY4.29
extern const float is_point_connection;
extern const float is_point_on_lines;
extern const float IS_POINT_ON_CIRCLE;
extern const float MAX_K;
extern const float can_be_adjust;

extern const float IS_SELECT_POINT;
extern const float IS_SELECT_LINE;

extern const int    point_pix_number;
extern const float  judge_line_value;   //用于直线判定时的阀值
extern const float  circle_jude;        //椭圆长短周半径值之比判断为圆的阀值
extern const float  equal_to_zero;
extern const float  stander_deviation;  //判断是否为二次曲线的标准差
extern const int    draw_circle_increment;
extern const int    cut_line_distance;
extern const int    joined_distance;
extern const float  k_equal_minimal;
extern const float  k_equal_max;                                                                    

#pragma once
extern int graphID;

@class GCPoint;
@class GCLineUnit;
@class GCPointGraph;
@class GCLineGraph;
@interface Threshold : NSObject
{

}
//函数
//两点之间距离
+(float) Distance:(const GCPoint*)p1 :(const GCPoint*)p2;
//线段的中点
+(GCPoint*)middlePointOfPoint1:(GCPoint*)point1 Point2:(GCPoint*)point2;
//计算切线方向
+(GCPoint*)tangentOfPoint1:(GCPoint*)point1 Point2:(GCPoint*)point2;
//点到直线的距离
+(float) pointToLine:(GCPointGraph*)pointGraph :(GCLineGraph*)lineGraph;
+(float) pointToLIne:(GCPoint*)point :(GCLineUnit*)lineUnit;
//两个向量的夹角
+(float) angle_of_vectors:(GCPoint*)a :(GCPoint*)b;
//生成一个点图形，graphid增加
+(GCPointGraph*)createNewPoint:(GCPoint*)point;
//求两条直线的交点
+(void)intersectOfLine1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Point:(GCPoint*)point;
+(Boolean)intersectOfSegmentsWithLine1:(GCLineUnit*)line1 Line2:(GCLineUnit*)line2 Point:(GCPoint*)point;
//两点是否相等
+(BOOL)isEqualPoint1:(GCPoint*)point1 Point2:(GCPoint*)point2;
@end
