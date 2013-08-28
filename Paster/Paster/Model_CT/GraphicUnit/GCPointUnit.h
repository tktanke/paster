//
//  GCPointUnit.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraphicUnit.h"

@interface GCPointUnit : GCGraphicUnit

-(id) initWithPoint:(GCPoint*)a;
-(id) initWithPoints:(NSMutableArray*)points;
-(void) drawWithContext:(CGContextRef)context;
-(void) setOriginal;

@end
