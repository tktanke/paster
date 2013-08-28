//
//  PWPasterEditViewController.h
//  Paster
//
//  Created by tzzzoz on 13-3-22.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"
#import "PWPaster.h"
#import "ScreenShoter.h"
#import "UIDrawAnimationView.h"
#import "UIFireWork.h"
#import <AVFoundation/AVFoundation.h>

//@class PKGeometryImageView;
@interface PWPasterEditViewController : UIViewController
{
    //视图对象
    UIScrollView *geoModelScrollView;//贴纸形状模板选择类别scrollview
    UIScrollView *colorGeoScrollView;//贴纸颜色模板选择类别scrollview
    UIImageView *pasterView;//跳转后传过来的贴纸
    NSMutableArray *geoModelButtonArray;//贴纸形状按钮数组
    NSMutableArray *colorGeoButtonArray;//贴纸颜色按钮数组
    //几何贴纸有了变化
    BOOL modify;

    UIImageView* selectedGeoImageView;//被选后新创建的的基本图形,可以自由操作
    NSInteger selectedIndex;//颜色几何贴纸序号默认为-1
    NSInteger selectedGeoIndex;//几何贴纸默认-1
    UIView * viewGestureR;//添加手势操作对象  操纵区
    UIImageView * activeGeoImageView;//当前操作的视图
    UIDrawAnimationView* drawAniamtionView;
//    DKDrawCanvas *drawCanvas;
    
    //模型对象
    PWPaster *selectedPaster;//当前的贴纸对象
    PWTheme *themeOnwer;
    NSMutableArray *specificShapeArray;
    CGPoint  touchBegPoint;
    CGPoint  touchEndPoint;
    //临时数组保存颜色几何贴纸修改后的xinxi
    NSMutableArray * tempTriangle;//三角形
    NSMutableArray * tempRectangle;//矩形
    NSMutableArray * tempEllipse;//椭圆
    
    //放大旋转参数倍数
    float _scal;//放大倍数
    float _rotation;//旋转角度
    float _rotation2;
    float _rotationTemp;
    BOOL isFirstTimeYesorNot;
    
    int time1;
    int time2;

    
    
    
//    AVAudioPlayer * geoPlayer[7];
    AVAudioPlayer * colorPlayer[18];
    
}

@property BOOL modify;//add
@property (nonatomic, strong) UIScrollView *geoModelScrollView;
@property (nonatomic, strong) UIScrollView *colorGeoScrollView;
@property (nonatomic, strong) UIImageView *pasterView;
@property (nonatomic, strong) NSMutableArray *geoModelButtonArray;
@property (nonatomic, strong) NSMutableArray *colorGeoButtonArray;

@property(nonatomic,strong)UIView * viewGestureR;
@property(nonatomic,strong)    UIImageView * activeGeoImageView;
@property (nonatomic, strong) PWPaster *selectedPaster;
@property (nonatomic, strong) PWTheme *themeOnwer;
@property (nonatomic, strong) NSMutableArray *specificShapeArray;
@property(nonatomic,strong)UIImageView* selectedGeoImageView;
@property (retain, nonatomic) UIDrawAnimationView* drawAniamtionView;
@property (retain, nonatomic) UIFireWork*   fireWorkForGeo;
@property(nonatomic,retain)NSMutableArray * tempTriangle;
@property(nonatomic,retain)NSMutableArray * tempTrapezium;
@property(nonatomic,retain)NSMutableArray * tempEllipse;
@property(nonatomic,retain)NSMutableArray * tempCircle;
@property(nonatomic,retain)NSMutableArray * tempSquare;
@property(nonatomic,retain)NSMutableArray * tempRectangle;
@property(nonatomic,retain)NSMutableArray * tempPentacle;

+(void)playGeoPlayer:(int)player;

-(IBAction)returnBack:(id)sender;
-(void)tapGeoModelButton:(UIButton *)button;
-(void)tapColorGeoButton:(UIButton *)button;//贴纸颜色编辑
-(IBAction)deleteBtn:(id)sender;
-(void)handleLongpressGesture:(UIGestureRecognizer*)sender;
-(void)firePlay:(UIButton*)btn;
-(void)updateColorButtonPosition:(UIButton *)btn;
-(void)panEnd:(CGPoint)center;//调整坐标
-(void)returnBackToModelScrollView:(id)sender;

@end
