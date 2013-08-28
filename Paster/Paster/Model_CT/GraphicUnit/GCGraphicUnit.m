//
//  GCGraphicUnit.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraphicUnit.h"

@implementation GCGraphicUnit

@synthesize start;
@synthesize end;
@synthesize type;
@synthesize isSelected;

- (id)init
{
    self = [super init];
    if (self)
    {
        //isSelected = NO;
        start = [[GCPoint alloc]init];
        end   = [[GCPoint alloc]init];
        start.x = 0;
        start.y = 0;
        end.x = 0;
        end.y = 0;
        type  = 0;
    }
    
    return self;
}

-(id)initWithStartPoint:(GCPoint *)s endPoint:(GCPoint *)e
{
    self = [self init];
    
    type  = 0;
    isSelected=false;
    start.x=s.x;
    start.y=s.y;
    end.x=e.x;
    end.y=e.y;
    
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points
{
    self = [self init];
    
    type  = 0;
    isSelected=false;
    GCPoint *s;
    GCPoint *e;
    s = [points objectAtIndex:0];
    e = [points lastObject];
    start.x = s.x;
    start.y = s.y;
    end.x = e.x;
    end.y = e.y;
    return self;
}

-(void)drawWithContext:(CGContextRef)context{}
//
//-(void)dealloc
//{
//    [start release];
//    [end release];
//    
//    [super dealloc];
//}



@end
