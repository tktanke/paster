//
//  GCLineUnit.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCLineUnit.h"

@implementation GCLineUnit

@synthesize k,b,isCutLine,cutPoint;

- (id)init
{
    self = [super init];
    if (self)
    {
        type=1;//直线类型
        cutPoint = [[GCPoint alloc]initWithX:0 andY:0];
        isCutLine = NO;
        self.isSelected = NO;
        [self setOriginal];
    }
    
    return self;
}

-(id)initWithPoints:(NSMutableArray *)points
{
    self = [self init];
    isCutLine = NO;
    self.isSelected = NO;
    GCPoint *s;
    GCPoint *e;
    s = [points objectAtIndex:0];
    e = [points lastObject];
    
    type=1;
    start.x=s.x;
    start.y=s.y;
    end.x=e.x;
    end.y=e.y;
    isCutLine = NO;
    self.isSelected = NO;
    [self setOriginal];
    [self calculateK_B];
    return self;
}

-(id)initWithStartPoint:(GCPoint *)s endPoint:(GCPoint *)e
{
    self = [super init];
    type=1;
    start.x = s.x;
    start.y = s.y;
    end.x = e.x;
    end.y = e.y;
    isCutLine = NO;
    self.isSelected = NO;
    [self calculateK_B];
    [self setOriginal];
    return self;
}

-(void) setOriginal
{
    [start setOriginal];
    [end setOriginal];
    if(isCutLine)
    {
        [cutPoint setOriginal];
    }
}

-(BOOL)judge:(NSMutableArray *)pList
{
    GCPoint* startPoint;
    GCPoint* endPoint;
    startPoint = [pList objectAtIndex:0];
    endPoint   = [pList lastObject];
    int length = [Threshold Distance:startPoint :endPoint];
    
    GCPoint* point;
    GCPoint* prePoint;
    int totalLength = 0;
    for (int i=1;i<[pList count]-1;i++)
    {
        point = [pList objectAtIndex:i];
        prePoint = [pList objectAtIndex:i-1];
        totalLength += [Threshold Distance:prePoint :point];
    }
    
    if (totalLength != 0 && length/totalLength>=0.95)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)setstart:(GCPoint *)newstart {
    start.x=newstart.x;
    start.y=newstart.y;
    [self calculateK_B];
}

-(void)setstartX:(float)newstart_x Y:(float)newstart_y {
    start.x=newstart_x;
    start.y=newstart_y;
    [self calculateK_B];
}

-(void)setend:(GCPoint *)newend {
    end.x=newend.x;
    end.y=newend.y;
    [self calculateK_B];
}

-(void)setendX:(float)newend_x Y:(float)newend_y {
    end.x=newend_x;
    end.y=newend_y;
    [self calculateK_B];
}

-(void)calculateK_B {
    if (start.x==end.x)
    {
        k=MAX_K;
        b=-(double)start.x;
    }
    else
    {
        k=(end.y-start.y)/(end.x-start.x+0.0000000001);
        b=(double)start.y-k*(double)start.x;
    }
}

-(double)OriginalB {
    return (double)start.originalY- [self OriginalK]*(double)start.originalX;
}

-(double)OriginalK {
    return (end.originalY-start.originalY)/(end.originalX-start.originalX+0.00000000001);
}

-(void)drawWithContext:(CGContextRef)context
{
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextStrokePath(context);
}

//-(void)dealloc
//{
//    [super dealloc];
//    [cutPoint release];
//}

@end
