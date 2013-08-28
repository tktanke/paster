//
//  PWGeoPasterEditViewController.h
//  Paster
//
//  Created by tzzzoz on 13-3-25.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "UIDrawAnimationView.h"
#import "GCBoardView.h"
#import "UIFireWork.h"
#import "DKDrawCanvas.h"//add
#import <AVFoundation/AVFoundation.h>

@class PKGeometryImageView;
@interface PWGeoPasterEditViewController : UIViewController
{
    //视图对象
    GCBoardView * boardView ;//add
    IBOutlet UIButton *zoomOutButton;
    NSMutableArray *penArray;//画笔数组
    UIView * penView;//笔的view
//    UIColor * penColor;//画笔颜色
    NSInteger selectedPenIndex;//被选择画笔的下标
    UIDrawAnimationView* drawAniamtionView;
    
    //模型对象
    PWGeoPaster *selectedGeoPaster;
    PWGeoPaster *selectedColorGeoPaster;
//    IBOutlet UIImageView * geoPaserImage;//用于显示演示几何图形
     NSMutableArray *specificShapeA;//保存上一个场景的specificShapeArray;作为参数
     DKDrawCanvas *drawCanvas;//add
    
    AVAudioPlayer * colorPlayer[18];
}

@property (retain, nonatomic) DKDrawCanvas *drawCanvas;//add
@property (nonatomic, strong) IBOutlet UIButton *zoomOutButton;
//@property (nonatomic, strong) IBOutlet UIImageView * geoPaserImage;
@property (nonatomic, strong) IBOutlet NSMutableArray *penArray;//画笔
@property (nonatomic, strong) IBOutlet   UIView * penView;
//@property (nonatomic ,strong) UIColor * penColor;
@property (nonatomic, strong) PWGeoPaster *selectedGeoPaster;
@property (nonatomic, strong) PWGeoPaster *selectedColorGeoPaster;
@property (nonatomic, strong)  UIDrawAnimationView* drawAniamtionView;
@property (nonatomic) NSInteger selectedPenIndex;
@property (readwrite) int graphListSize;//add
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCollection;//add
@property (retain, nonatomic) UIFireWork*   fireWorkForGeo;
@property(retain,nonatomic)UIImageView* geoTemplateForDraw;
@property(retain)NSMutableArray * specificShapeA;//add
-(IBAction)returnBack:(id)sender;
- (void)typeChoose;//add
-(int)translateToIndex:(NSString *)text;//类型识别

-(void)initPenArray:(NSMutableArray *)temp;
-(void)updateSelectedPen;//更新第一个被选中的画笔位置
-(void)playDrawTemplateAnimation;
- (IBAction)clearWindow:(UIButton *)sender;//add
//////////////////////判断是否画完的回调函数//////////////
-(void)judgeWhetherDrawed:(NSTimer *)timer;

@end
