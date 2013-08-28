//
//  GCPoint.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCPoint : NSObject
{
    float x,y;
    float originalX;
    float originalY;
    float s,d,c;
    int total;
}

-(id) initWithX:(float) xx andY:(float)yy;
-(float) x;
-(float) y;
-(void) setX:(float) xx;
-(void) setY:(float) yy;
-(void) setTotal:(int)i;

-(void) setOriginalWithGCPoint:(GCPoint *)point;
-(GCPoint *)plus:(GCPoint *)addPoint;
-(void) translationFromPoint:(GCPoint *)vec;
-(void) setOriginal;

@property (readwrite) float x;
@property (readwrite) float y;
@property (readwrite) float originalX;
@property (readwrite) float originalY;
@property (readwrite) float s;
@property (readwrite) float d;
@property (readwrite) float c;
@property (readwrite) int   total;

@end
