//
//  PWGeoPasterEditViewController.m
//  Paster
//
//  Created by tzzzoz on 13-3-25.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "PWGeoPasterEditViewController.h"
#import "PWGeoPaster.h"
#import "FillImage.h"
#import "UIDragGeoPasterRecognizer.h" 
@implementation PWGeoPasterEditViewController
@synthesize drawCanvas;//add
@synthesize zoomOutButton;
//@synthesize  geoPaserImage;
@synthesize penView;
@synthesize selectedGeoPaster, selectedColorGeoPaster;
@synthesize penArray;
 @synthesize selectedPenIndex;
@synthesize fireWorkForGeo;
@synthesize drawAniamtionView;
@synthesize geoTemplateForDraw;
@synthesize specificShapeA;

//static UIImageView* geoTemplateForDraw = nil;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setUserInteractionEnabled:YES];
         drawCanvas = [[DKDrawCanvas alloc]init];
        ////////////////////////初始化drawAnimationView//////////////////////
        
        drawAniamtionView = [[UIDrawAnimationView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 512.0f, 512.0f)];
         
        drawAniamtionView.center=CGPointMake(512, 384);
         

        
    }
    return self;
}

-(void)initPenArray:(NSMutableArray *)temp
{
    for (int i=1;i<18;i++) {
        
        [penArray addObject:[temp objectAtIndex:i]];
    }
}

- (IBAction)clearWindow:(UIButton *)sender
{
    if(boardView)
    {
        [boardView clearView];
        [boardView setNeedsDisplay];
    }

}

- (void)typeChoose {//类型选择
 
   int index=selectedColorGeoPaster.type;
    NSLog(@"index %d", index);
    [self drawGraph:index];
    
}


-(void)drawGraph:(int)index//模板图片加载
{
    if(geoTemplateForDraw == nil)
    {
//        CGRect myImageRect = CGRectMake(280.0f, 100.0f, 512.0f, 512.0f);//300 ,100
        
        CGRect myImageRect = CGRectMake(0, 0, 512.0f, 512.0f);//300 ,100
        geoTemplateForDraw = [[UIImageView alloc] initWithFrame:myImageRect];//模板
        geoTemplateForDraw.center=CGPointMake(512, 384);
        [self.view addSubview:geoTemplateForDraw];
    }
    if(boardView == nil)
    {
          boardView = [[GCBoardView alloc] initWithFrame:CGRectMake(103,40, 512, 512)];//150.0, 60.0, 800.0, 600.0
        [boardView setCenter:CGPointMake(512, 384)];
//        boardView.backgroundColor = [UIColor blueColor];
 
        ColorType  ct=selectedPenIndex;
    
        [boardView initWithColorType:ct];
        boardView.indexTemplePaste=index;
        [self.view addSubview:boardView];
        [self.view bringSubviewToFront:boardView];
     }
    else
    {
        [self clearWindow:nil];
    }
    [geoTemplateForDraw setImage:[UIImage imageNamed:[NSString stringWithFormat:@"templateImageViewForDraw%d.png", index ]]];
    geoTemplateForDraw.opaque = YES; //opaque是否透明
    
    //开始drawAnimation动画
    if (drawAniamtionView.modify) {
     [drawAniamtionView changeDrawAnimationWithGeoType:selectedColorGeoPaster.type DataList:drawCanvas.juedgeGeoArray];
        [self.view addSubview:drawAniamtionView];
        [drawAniamtionView startAnimation];
        
    }
}

-(void)tapColorImageView:(UIButton*)send//画笔事件
{
    if (send==nil) {//首次加载被选画笔
        for(UIButton * btn in penView.subviews)
        {
            if ([btn tag]==selectedPenIndex) {
                btn.transform=CGAffineTransformMakeTranslation(0, -15);
                ColorType colTemp=selectedPenIndex;
                [boardView initWithColorType:colTemp];
                [btn setSelected:YES];
                send=btn;
            }
            
        }
    }
    else
    {
        if (![send isSelected]) {//颜色有改变
            if (selectedPenIndex>=0) {
                for (UIButton * tm in penView.subviews) {//查找旧的画笔
                    if ([tm tag]==selectedPenIndex) {
                        tm.transform=CGAffineTransformIdentity;
                        [tm setSelected:NO];
                    }
                }
            }
            
            send.transform=CGAffineTransformMakeTranslation(0, -15);
            selectedPenIndex=[send tag];//更新当前画笔序号
             ColorType  colTemp=selectedPenIndex;
            [boardView initWithColorType:colTemp];
            [send setSelected:YES];
            
        }
    
    }
   
    [colorPlayer[selectedPenIndex] play];//播放音乐
    
    //清空boardview
    if(boardView)
    {
        [boardView clearView];
        [boardView setNeedsDisplay];
    }
    
    //加入烟花效果
    [fireWorkForGeo bringToFront];
    CGPoint newCenter;
    newCenter.x=self.penView.frame.origin.x+send.center.x ;
    newCenter.y=self.penView.frame.origin.y+send.center.y;
    fireWorkForGeo.touchPoint = newCenter;
    [fireWorkForGeo stopAnimation];
    [fireWorkForGeo startAnimation];
    [self.view setNeedsDisplay ];

}

- (void)loadSounds
{
    NSString *color[18]={@"%@/sound_black.wav",@"%@/sound_red.wav",@"%@/sound_yellow.wav",@"%@/sound_light_blue.wav",@"%@/sound_green.wav",@"%@/sound_purple.wav",@"%@/sound_brown.wav",@"%@/sound_orange.wav",@"%@/sound_purple_red.wav",@"%@/sound_peach_red.wav",@"%@/sound_yellow_blue.wav",@"%@/sound_deep_purple.wav",@"%@/sound_silver.wav",@"%@/sound_deep_green.wav",@"%@/sound_blue.wav",@"%@/sound_deep_blue.wav",@"%@/sound_blue_green.wav",@"%@/sound_pink.wav"};
    NSURL * url;
    NSError *error;
    for(int i=0;i<18;i++){
        url = [NSURL fileURLWithPath:[NSString
                                      stringWithFormat:color[i],  [[NSBundle mainBundle]  resourcePath]]];
        colorPlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        colorPlayer[i].numberOfLoops  = 0;
        if  (colorPlayer[i] == nil)      //文件不存在
            printf("音频加载失败C%d",i);
    }
}


-(void)updateSelectedPen//更新首次加载进的画笔颜色
{
//    UIButton * btn=[self.penView.subviews objectAtIndex:selectedPenIndex];
//    NSLog(@"btn====%@",btn);
//     NSLog(@"penIndex=%d",selectedPenIndex);
    [self tapColorImageView:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    penColor=[penArray objectAtIndex:selectedPenIndex-1];
    selectedPenIndex=-1;
    penArray =[[NSMutableArray alloc] initWithCapacity:18];
      
    for (int i=1; i<=18; i++) {
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];//画笔按钮
        [btn setFrame:CGRectMake(30*i, 0, 50,120 )];//63-195
        [btn setSelected:NO];
        [btn setTag:i];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"bigColorButton%d",i+1]] forState:UIControlStateNormal];
         
         [btn addTarget:self action:@selector(tapColorImageView:) forControlEvents:UIControlEventTouchUpInside];
        [self.penView addSubview:btn];
        [btn release];
    }
    [penView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:penView];
    
    //设置判断的图形类型，开启回调监测函数0.05
    [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(judgeWhetherDrawed:) userInfo:nil repeats:YES];
    //烟花效果初始化
    self.fireWorkForGeo = [[[UIFireWork alloc]initFireWorkWith:self.view]autorelease];
    self.fireWorkForGeo.animtionType = LinePathAnimation;
    
    [self loadSounds];
    
}

-(IBAction)returnBack:(id)sender
{
    RootViewController * rootC=[RootViewController sharedRootViewController];
    [rootC.pasterEditViewController returnBackToModelScrollView:nil];
    [rootC popViewController];

}

-(void)judgeWhetherDrawed:(NSTimer *)tm
{
//    if(0){//test
    if (boardView.goodOrNot) {//画的好就跳转
            //保存信息当前画笔的颜色招到对应colorScrollView的对应颜色按钮更新其状态//更新specificArray信息，以及button按钮数组  利用selectedPenIndex
        [tm invalidate];
        NSLog(@"good -----");
        RootViewController *rootC=[RootViewController sharedRootViewController];
        PWGeoPaster *geoPaster = [self.specificShapeA objectAtIndex:selectedPenIndex];
               
        selectedColorGeoPaster=geoPaster;//更新对象
        selectedColorGeoPaster.isCreated=YES;//更新specificshapeA 对应贴纸被创建
        NSLog(@"%d",selectedPenIndex);
        NSLog(@"%d",rootC.pasterEditViewController.colorGeoButtonArray.count);
 
        UIButton *btn=[rootC.pasterEditViewController.colorGeoButtonArray objectAtIndex:selectedPenIndex-1];//奖被修改的button
        NSLog(@"%@",btn);
//        [btn setSelected:YES];//在最后 移动位置后再修改
        
        UIColor* currentColor = boardView.currentColor;
         CGColorRef color = [currentColor  CGColor];
        int numComponents = CGColorGetNumberOfComponents(color);
        NSLog(@"number of numComponents:%d",numComponents);
        ColorRGBA tc;
        if (numComponents >= 3)
        {
            CGFloat *tmComponents = (CGFloat *)CGColorGetComponents(color);
            tc.red =(int) (tmComponents[0]*255);
            tc.green =(int) (tmComponents[1]*255);
            tc.blue =(int) (tmComponents[2]*255);
            tc.alpha =(int) (tmComponents[3]*255);
        }
        else
        {
            tc.red = 0;
            tc.green = 0;
            tc.blue = 0;
            tc.alpha = 255;
        }
        //ColorRGBA tc={255,255,255,255};
//        NSLog(@"the color is %f,%f,%f,%f",tc.red,tc.green,tc.blue,tc.alpha);
        
        //更新视图
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[btn imageForState:UIControlStateNormal]];
        [tempImageView setFrame:btn.frame];

        //根据颜色填充几何贴纸
        NSLog(@"color is %@", currentColor.CGColor);
        FillImage *changeColor=[[FillImage alloc]initWithImage:tempImageView.image];
        int x=(int)tempImageView.image.size.width/2;
        int y=(int)tempImageView.image.size.height/2;
         NSLog(@"x=%d",x);
        [changeColor changeColor:x andY:y withTC:tc];
        tempImageView.image=[changeColor getImage];//test
 
        [btn setImage:[changeColor getImage] forState:UIControlStateNormal];//更新视图
//        [btn addTarget:self action:@selector(<#selector#>) forControlEvents:UIControlEventTouchUpInside];
        [btn setNeedsDisplay];
        [changeColor release];
                  
        [rootC.pasterEditViewController updateColorButtonPosition:btn];//更新位置，创建的在前，空白的在后
 //        [rootC.pasterEditViewController.view addSubview:tempImageView];//test
        NSLog(@"开始跳转");
        [tempImageView release];
        [rootC popViewController];//跳转
        
    }


}
 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
//    [fireWorkForGeo release];
     [drawCanvas release];
    [penArray release];
    [super dealloc];

}

@end
