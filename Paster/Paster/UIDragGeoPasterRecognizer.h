//
//  UIDragGeoPasterRecognizer.h
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "PKGeometryImageView.h"
#import "PWGeoPaster.h"
#import <QuartzCore/QuartzCore.h>

@interface UIDragGeoPasterRecognizer : UIGestureRecognizer {
    UIImageView *selectedGeoImageView;
    CGPoint startPoint;
    PWGeoPaster *pasterView;
     NSInteger indexBt;
    CABasicAnimation* scaleAnimation;
    NSInteger swipe;//用于判断手势方向
    BOOL end;

}

@end
