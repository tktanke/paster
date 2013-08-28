//
//  Threshold.m
//  SmartGeometry
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "Threshold.h"
#import <math.h>
//#import "Point_Graph"
//#import "Line_Graph"
//#import "Curve_Graph"

@implementation Threshold

const float PI = 3.14159;

//用于判断是否能成为三角形或四边形的阀值
const float is_closed = 100.0;

//用于判定点是否在其他图形上,TY4.29
const float is_point_connection = 20.0;
const float is_point_on_lines = 15.0;
const float IS_POINT_ON_CIRCLE = 15.0;
const float MAX_K = 2147483647;
const float can_be_adjust = 15.0;

const float IS_SELECT_POINT=35.0;
const float IS_SELECT_LINE=20.0;

const int   point_pix_number=10;
const float judge_line_value=0.8;   //用于直线判定时的阀值
const float circle_jude=2.0;        //椭圆长短周半径值之比判断为圆的阀值
const float equal_to_zero = 0.01;
const float stander_deviation=0.2;  //判断是否为二次曲线的标准差
const int   draw_circle_increment=500;
const int   cut_line_distance=30;
const int   joined_distance=20;
const float k_equal_minimal=0.98;
const float k_equal_max=1.02;

int graphID = 0;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(float) Distance:(const GCPoint*)p1 :(const GCPoint*)p2
{
    return sqrt((float)((p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y)));
}

+(GCPoint*)middlePointOfPoint1:(GCPoint *)point1 Point2:(GCPoint *)point2
{
    return [[GCPoint alloc]initWithX:(point1.x+point2.x)/2 andY:(point1.y+point2.y)/2] ;
}

+(GCPoint*)tangentOfPoint1:(GCPoint *)point1 Point2:(GCPoint *)point2
{
    return [[GCPoint alloc]initWithX:(point1.x-point2.x)/2 andY:(point1.y-point2.y)/2];
}

+(float) pointToLine:(GCPointGraph *)pointGraph :(GCLineGraph *)lineGraph
{
    GCPoint* point = pointGraph.pointUnit.start;
    GCLineUnit* lineUnit = lineGraph.lineUnit;
    float distance = 100.0f;
    if(abs(lineUnit.k) > 20000.0)
    {
        distance = (float)abs(point.x - lineUnit.start.x);
    }
    else
    {
        float temp1 = sqrtf(pow(lineUnit.k,2)+1);
        float temp2 = abs(lineUnit.k*point.x - point.y + lineUnit.b);
        distance = temp2/temp1;
    }
    lineUnit = NULL;
    
    return distance;
}

+(float)pointToLIne:(GCPoint *)point :(GCLineUnit *)lineUnit
{
    float distance = 100.0;
    if(abs(lineUnit.k)>20000.0)
    {
        distance = (float)abs(point.x-lineUnit.start.x);
    }
    else
    {
        float temp1 = sqrtf(powf(lineUnit.k, 2)+1);
        float temp2 = abs(lineUnit.k*point.x - point.y + lineUnit.b);
        
        distance = temp2/temp1;
    }
    return distance;
}

+(float) angle_of_vectors:(GCPoint *)a :(GCPoint *)b
{
    float length1 = a.x*a.x + a.y*a.y;
    float length2 = b.x*b.x + b.y*b.y;
    
    float con_theta = (a.x*b.x+a.y*b.y)/sqrtf(length1*length2);
    
    return acosf(con_theta)*180.0f/PI;
}

+(GCPointGraph*)createNewPoint:(GCPoint *)point
{
    GCPointUnit* tempPoint = [[GCPointUnit alloc]initWithPoint:point];
    GCPointGraph* newPointGraph = [[GCPointGraph alloc]initWithUnit:tempPoint andId:graphID];
    //[tempPoint release];
    graphID++;
    return newPointGraph;
}

+(void)intersectOfLine1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Point:(GCPoint *)point
{
    if(line1.k != MAX_K && line2.k != MAX_K)
    {
        float temp_x = (line2.b - line1.b)/(line1.k - line2.k);
        float temp_y = line2.k*temp_x + line2.b;
        point.x = temp_x;
        point.y = temp_y;
        return;
    }
    else if(line1.k == MAX_K && line2.k != MAX_K)
    {
        float temp_y = line2.k*line1.start.x + line2.b;
        point.x = line1.start.x;
        point.y = temp_y;
        return;
    }
    else if(line2.k == MAX_K && line1.k != MAX_K)
    {
        float temp_y = line1.k*line2.start.x + line1.b;
        point.x = line2.start.x;
        point.y = temp_y;
        return;
    }
    else
        return;
}

+(Boolean)intersectOfSegmentsWithLine1:(GCLineUnit *)line1 Line2:(GCLineUnit *)line2 Point:(GCPoint *)point
{
    if(line1.k != MAX_K && line2.k != MAX_K)
    {
        float temp_x = (line2.b - line1.b)/(line1.k - line2.k);
        float temp_y = line2.k*temp_x + line2.b;
        point.x = temp_x;
        point.y = temp_y;
    }
    else if(line1.k == MAX_K && line2.k != MAX_K)
    {
        float temp_y = line2.k*line1.start.x + line2.b;
        point.x = line1.start.x;
        point.y = temp_y;
    }
    else if(line2.k == MAX_K && line1.k != MAX_K)
    {
        float temp_y = line1.k*line2.start.x + line1.b;
        point.x = line2.start.x;
        point.y = temp_y;
    }
    
    if( (point.x-line1.start.x)*(point.x-line1.end.x)<=0 && (point.x-line2.start.x)*(point.x-line2.end.x)<=0
        && (point.y-line1.start.y)*(point.y-line1.end.y)<=0 && (point.y-line2.start.y)*(point.y-line2.end.y)<=0 
        && [Threshold Distance:point :line1.start]>=is_point_connection && [Threshold Distance:point :line1.end]>=is_point_connection
        && [Threshold Distance:point :line2.start]>=is_point_connection && [Threshold Distance:point :line2.end]>=is_point_connection            
       )
    {
        //确保这个交点都在线段上,并且跟两个线段的首尾都不会很接近
        return YES;
    }
    else return NO;
}

+(BOOL)isEqualPoint1:(GCPoint *)point1 Point2:(GCPoint *)point2
{
    if(point1.x == point2.x && point1.y == point2.y)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
