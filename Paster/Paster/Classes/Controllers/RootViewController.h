//
//  RootViewController.h
//  Paster
//
//  Created by tzzzoz on 13-3-19.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWMainViewController.h"
#import "PWWonderlandViewController.h"
#import "PWPasterEditViewController.h"
#import "PWGeoPasterEditViewController.h"
#import "PWNavigationViewController.h"
#import "PWHelpViewController.h"
#import "PWGeoPasterEditViewController.h"
#import "EnumClass.h"
#import <AVFoundation/AVFoundation.h>

@class PWMainViewController;
@class PWWonderlandViewController;
@class PWPasterEditViewController;
@class PWAboutViewController;
@class PWHelpViewController;
@class PWGeoPasterEditViewController;
@interface RootViewController : UIViewController
{
    NSMutableArray *viewControllersStack;//视图控制器数组
    UIViewController *currentViewController;
    UIViewController *nextViewController;
    PWNavigationViewController * navigationViewController;
    PWMainViewController * mainViewController;
    PWHelpViewController * helpViewController;
    PWPasterEditViewController *pasterEditViewController;
    
    UIView * view;//开场动画背景
    UIImageView * loadingImageView;//开场动画视图
    
    AVAudioPlayer * audioPlayer;
    AVAudioPlayer * jumpPlayer;

}


+(RootViewController *)sharedRootViewController;

@property (retain, nonatomic) NSMutableArray *viewControllersStack;
@property (retain, nonatomic) UIViewController *currentViewController;
@property (retain, nonatomic) UIViewController *nextViewController;
@property (retain,nonatomic)PWNavigationViewController * navigationViewController;
@property (retain,nonatomic)PWMainViewController * mainViewController;
@property (retain,nonatomic)PWHelpViewController * helpViewController;
@property (retain,nonatomic)PWPasterEditViewController * pasterEditViewController;
@property(retain,nonatomic)AVAudioPlayer * audioPlayer;
@property(retain,nonatomic)AVAudioPlayer * jumpPlayer;


-(void)pushViewController:(UIViewController*) viewController;
-(void)popViewController;
-(void)display;

@end
