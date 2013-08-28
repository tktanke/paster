//
//  GCBoardView.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPoint.h"
#import "GCGraph.h"
#import "GCController.h"
#import "EnumClass.h"
#import <AVFoundation/AVFoundation.h>


@interface GCBoardView : UIView
{
   
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGPoint currentPoint;
    BOOL isDrawing;
    int indexTemplePaste;//add表示贴纸模板的序号
    BOOL goodOrNot;//好坏记录
    
    AVAudioPlayer * tonePlayer[13];

}
@property (nonatomic) BOOL goodOrNot;
@property (nonatomic)  int indexTemplePaste;
@property (retain)      NSMutableArray* arrayStrokes;
@property (retain)      NSMutableArray* arrayAbandonedStrokes;

@property (retain)      UIColor*        currentColor;//画笔颜色
@property (readwrite)   float           currentSize;

@property (retain)      UIImage*        currentImage;
@property (retain)      UIImage*        lastImage;

@property (retain)      NSMutableArray*     unitList;
@property (retain)      NSMutableArray*     graphList;
@property (retain)      NSMutableArray*     nowGraphList;
@property (retain)      NSMutableArray*     pointGraphList;
@property (retain)      NSMutableArray*     saveGraphList;
@property (retain)      NSMutableArray*     savePointList;

@property (readwrite)   CGContextRef        context;
@property (assign)      id                  owner;
@property (readwrite)   Boolean             hasDrawed;
@property (retain)      UIImageView*        graphImageView;

-(void) viewJustLoaded;
-(void) clearView;
-(int) imageCount;
-(GeometryType) imageType;
-(UIColor *)initWithColorType:(ColorType)ct;

@end
