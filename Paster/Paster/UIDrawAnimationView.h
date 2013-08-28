//
//  UIDrawAnimationView.h
//  Sketch Integration
//
//  Created by kwan terry on 12-6-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EnumClass.h"

@interface UIDrawAnimationView : UIView

@property (nonatomic,retain) CALayer* animationLayer;
@property (nonatomic,retain) CAShapeLayer* pathLayer;
@property (nonatomic,retain) CALayer* penLayer;
@property (nonatomic,assign) GeometryType geoType;
@property (nonatomic,retain) NSMutableArray* dataList;
@property (nonatomic,retain) UIBezierPath* path;
@property (nonatomic)BOOL modify;//add

-(void)changeDrawAnimationWithGeoType:(GeometryType)type DataList:(NSMutableArray*)plist;
-(void)setupDrawingLayer;
-(void)startAnimation;
-(void)stopAnimation;

@end
