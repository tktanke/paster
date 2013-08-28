//
//  UIFireWork.h
//  AnimationEffect
//
//  Created by kwan terry on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "UIParticle.h"
#import "EnumClass.h"

@interface UIFireWork : NSObject

@property (retain,nonatomic) NSMutableArray* particleArray;
@property (assign,nonatomic) AnimationType   animtionType;
@property (retain,nonatomic) UIView*         superView;
@property (retain,nonatomic) NSTimer*        fireWorkTimer;

@property (assign,nonatomic) int             countOfParticle;
@property (assign,nonatomic) int             countOfAnimation;

@property (assign,nonatomic) CGPoint         touchPoint;
@property (assign,nonatomic) int             currentIndex;
@property (assign,nonatomic) BOOL            isTouch;
@property (assign,nonatomic) BOOL            isDraw;

-(id)initFireWorkWith:(UIView*)superViewTmp; 
-(void)bringToFront;
-(void)draw;
-(void)startAnimation;
-(void)stopAnimation;


@end
