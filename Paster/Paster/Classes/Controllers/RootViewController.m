//
//  RootViewController.m
//  Paster
//
//  Created by tzzzoz on 13-3-19.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "RootViewController.h"
 
@implementation RootViewController

@synthesize audioPlayer;
@synthesize jumpPlayer;

static  RootViewController *_sharedRootViewController = nil;

int imgIndex=0;//当前动画图片序号


@synthesize viewControllersStack, currentViewController, nextViewController;
@synthesize navigationViewController;
@synthesize  helpViewController;
@synthesize  mainViewController;
@synthesize pasterEditViewController;
+ (RootViewController *) sharedRootViewController
{
    if (!_sharedRootViewController) {
        _sharedRootViewController = [[self alloc] init];
    }
    return _sharedRootViewController;
}

+(id)alloc
{
    NSAssert(_sharedRootViewController == nil, @"Attempted to allocate a second instance of a singleton.");
    return [super alloc];
}

-(id)init {
    self = [super init];
    if (self) {
        viewControllersStack = [[NSMutableArray alloc] init];
        currentViewController = nil;
        nextViewController=nil;
         navigationViewController=[[PWNavigationViewController alloc] initWithNibName:@"PWNavigationViewController" bundle:nil];//导航场景
        helpViewController=[[PWHelpViewController  alloc] initWithNibName:@"PWHelpViewController" bundle:nil];//关于场景
        mainViewController=[[PWMainViewController alloc] initWithNibName:@"PWMainView" bundle:nil];//主题选择场景
        pasterEditViewController=[[PWPasterEditViewController alloc] initWithNibName:@"PWPasterEditView" bundle:nil];//贴纸编辑场景
        NSURL  *url = [NSURL fileURLWithPath:[NSString
                                              stringWithFormat:@"%@/sound_navigationView.mp3",  [[NSBundle mainBundle]  resourcePath]]];
        NSError  *error;
        audioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];    //加载背景音乐
        audioPlayer.numberOfLoops  = -1;
        audioPlayer.volume=0.3;   //音量设置
        if  (audioPlayer == nil)      //文件不存在
            printf("音频加载失败");
//        else                          //文件存在
        url = [NSURL fileURLWithPath:[NSString
                                      stringWithFormat:@"%@/sound_pageJump.wav",  [[NSBundle mainBundle]  resourcePath]]];
        
        jumpPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        jumpPlayer.numberOfLoops  = 0;
        if  (jumpPlayer == nil)      //文件不存在
            printf("音频加载失败");

//
        
    }
    return self;
}


-(void)pushViewController:(UIViewController*) viewController {
    NSAssert(viewController != nil, @"Argument must be not nil");
    
    [viewControllersStack addObject:viewController];
    nextViewController = viewController;
    [self display];
}

-(void)popViewController {
    NSInteger count = [viewControllersStack count];
    if (count == 1) {
        [NSException raise:@"Remove Failed" format:@"Reason: Can't remove the last viewController"];
    } else {
        UIViewController * temp=[viewControllersStack lastObject];//add
        [temp.view removeFromSuperview ];//add
        [viewControllersStack removeLastObject];
        nextViewController = [viewControllersStack lastObject];
        [self display];
    }
}

-(void)display {
    NSAssert(nextViewController != nil, @"nextViewController can't be nil");
//    nextViewController.view.layer.opacity = 1.0f;
    [nextViewController viewWillAppear:YES];
    [nextViewController.view setNeedsDisplay];
    [self.view addSubview:nextViewController.view];
    
    currentViewController = nextViewController;
    nextViewController = nil;
    [self jumpWithAnimation];
}
-(void)loadView
{
    [super loadView];
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    view = [[UIView alloc] init];//动画的背景
    [view setFrame:CGRectMake(0.0, 0.0, appFrame.size.height, appFrame.size.width)];
    [view setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:view];
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    loadingImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"animita001.png"]];
    [view addSubview:loadingImageView];
    [NSTimer scheduledTimerWithTimeInterval:0.0416 target:self selector:@selector(startAnimation:) userInfo:nil repeats:YES];
//添加新视图
    navigationViewController.view.alpha=0.0;
//    [self pushViewController:navigationViewController];
    [self.view addSubview:navigationViewController.view];
}

-(void)startAnimation:(NSTimer *)timer//启动动画
{
    NSString * imageName=[NSString stringWithFormat:@"animita00%d.png",imgIndex];
    UIImage * tempImage=[UIImage imageNamed:imageName];
    loadingImageView.image=tempImage;
    imgIndex++;
    //    NSLog(@"ss%d",loadingImageView.retainCount);
    if (imgIndex==93) {//93
        imgIndex=0;
        [timer invalidate];
        
        CATransition  * transition =[CATransition  animation];
        transition.type=@"rippleEffect";
        transition.subtype=kCATruncationMiddle;
        transition.duration=6.0f;
        transition.removedOnCompletion=NO;
        transition.timingFunction=UIViewAnimationCurveEaseInOut;
        transition.delegate=self;
        //        [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:2];
        [[self.view layer] addAnimation:transition forKey:nil];
        navigationViewController.view.alpha=1.0;
        [loadingImageView removeFromSuperview];
        [view removeFromSuperview];//动画背景去除
        
        [audioPlayer  play];           //播放背景音乐
        
    
//        [view release];//bug
 
        
    }
    
}
-(void)jumpWithAnimation//转场效果
{
    ///*
    //移入效果
    CATransition  * transition =[CATransition  animation];
//    transition.type=kCAValueFunctionScale;
    transition.type=kCATransitionFade;
    transition.subtype=kCATransitionFromTop;
    transition.duration=1.0f;
    transition.removedOnCompletion=NO;
    transition.timingFunction=UIViewAnimationCurveEaseInOut;
    [[self.view layer] addAnimation:transition forKey:nil];
    
    [jumpPlayer  play];           //播放背景音乐

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
    [super dealloc];

}

@end
