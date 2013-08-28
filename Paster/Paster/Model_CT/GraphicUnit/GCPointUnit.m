//
//  GCPointUnit.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCPointUnit.h"

@implementation GCPointUnit

- (id)init
{
    self = [super init];
    if (self)
    {
        type=0;
    }
    
    return self;
}

-(id)initWithPoint:(GCPoint *)a
{
    self = [self init];
    
    type=0;
    self.end.originalX = self.start.originalX = self.end.x = self.start.x = a.x;
    self.end.originalY = self.start.originalY = self.end.y = self.start.y = a.y;
    
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points
{
    self = [self init];
    
    GCPoint *middle;
    middle = [points objectAtIndex:[points count]/2];
    NSLog(@"%f,%f",middle.x,middle.y);
    
    type=0;
    self.end.originalX = self.start.originalX = self.end.x = self.start.x = middle.x;
    self.end.originalY = self.start.originalY = self.end.y = self.start.y = middle.y;
    
    return self;
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextFillEllipseInRect(context, CGRectMake(start.x, start.y, 10, 10));
}

-(void)setOriginal {
    start.originalX=start.x;
    start.originalY=start.y;
}
//
//-(void)dealloc
//{
//    [super dealloc];
//}

@end
