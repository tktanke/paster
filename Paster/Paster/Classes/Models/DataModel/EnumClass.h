//
//  EnumClass.h
//  Paster
//
//  Created by tzzzoz on 13-3-8.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#ifndef Paster_EnumClass_h
#define Paster_EnumClass_h

typedef enum
{
    Triangle    = 0,
    Trapezium   = 1,
    Ellipse     = 2,
    Pentacle    = 3,
    CirCle      = 4,
    Square      = 5,
    Rectangle   = 6
}GeometryType;

typedef enum
{
    black           = 0,
    red             = 1,
    yellow          = 2,
    lightBlue       = 3,
    grassGreen      = 4,
    purple          = 5,
    brown           = 6,
    lightOrange     = 7,
    lightPurple     = 8,
    roseRed         = 9,
    lightGreen      = 10,
    darkPurple      = 11,
    grey            = 12,
    green           = 13,
    blue            = 14,
    darkBlue        = 15,
    darkGreen       = 16,
    pink            = 17
}ColorType;

typedef enum
{
    EaseIn = 0,
    EaseOut = 1
}SkipAnimationType;//动画


typedef enum
{
    Translation = 0,
    Scale       = 1,
    Rotation    = 2,
    Nothing     = 3
}OperationType;

typedef enum
{
    LinePathAnimation = 0,
    CurvePathAnimation = 1,
    NoneAnimation = 3
}AnimationType;
typedef struct ColorRGBAStruct{
    float red;
    float green;
    float blue;
    float alpha;
}ColorRGBA;


static const int sizeOfGeoPasterTemplate = 85;

#endif
