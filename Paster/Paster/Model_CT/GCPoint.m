//
//  GCPoint.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCPoint.h"

@implementation GCPoint

@synthesize s,d,c,x,y,originalX,originalY,total;

-(id)init
{
    self = [super init];
    if (self)
    {
        x = 0;
        y = 0;
        total = 0;
        s = 0;
        d = 0;
        c = 0;
    }
    return self;
}

-(id)initWithX:(float)xx andY:(float)yy
{
    self = [self init];
    x = xx;
    y = yy;
    originalX = x;
    originalY = y;
    
    total = 0;
    
    return self;
}
//setter
-(void) setOriginalX:(float)xx{
    originalX = xx;
}
-(void) setOriginalY:(float)yy{
    originalY = yy;
}
-(void) setX:(float) xx{
    x = xx;
}
-(void) setY:(float) yy{
    y = yy;
}
-(void)setOriginal {
    originalX = 0;
    originalY = 0;
}

//getter
-(float) originalX{
    return originalX;
}
-(float) originalY{
    return originalY;
}
-(float) x {
    return x;
}
-(float) y {
    return y;
}


-(void) setOriginalWithGCPoint:(GCPoint *)point{
    originalX = point.originalX;
    originalX = point.originalY;
}

-(void) translationFromPoint:(GCPoint *)vec{
    x += vec.x;
    y += vec.y;
    originalX += vec.x;
    originalY += vec.y;
}

-(BOOL)isEqual:(GCPoint *)comparePoint{
    if(x == comparePoint.x && y == comparePoint.y)
        return true;
    return false;
}

-(GCPoint *)plus:(GCPoint *)addPoint
{
    GCPoint *result = [[GCPoint alloc]init];
    result.x = x + addPoint.x;
    result.y = y + addPoint.y;
    return result;
}

@end
