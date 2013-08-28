//
//  UIParticle.h
//  AnimationEffect
//
//  Created by kwan terry on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIParticle : UIImageView

@property (assign,nonatomic) BOOL       isMove;
@property (assign,nonatomic) float      rotateDirection;
@property (assign,nonatomic) int        drawCount;

-(void)changeColorWithColor:(UIColor*)colorUI;

@end
