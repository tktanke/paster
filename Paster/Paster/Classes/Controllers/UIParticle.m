//
//  UIParticle.m
//  AnimationEffect
//
//  Created by kwan terry on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIParticle.h"

@implementation UIParticle

@synthesize isMove,rotateDirection,drawCount;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)changeColorWithColor:(UIColor*)colorUI
{
    UIGraphicsBeginImageContext(self.image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [colorUI setFill];
    CGContextTranslateCTM(context, 0, self.image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
    CGContextDrawImage(context, rect, self.image.CGImage);
    
    CGContextClipToMask(context, rect, self.image.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    [self setImage:image1];
}

@end
