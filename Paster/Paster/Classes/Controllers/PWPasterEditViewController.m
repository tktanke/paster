//
//  PWPasterEditViewController.m
//  Paster
//
//  Created by tzzzoz on 13-3-22.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "PWPasterEditViewController.h"
//#import "PKGeometryImageView.h"
#import "UIDragGeoPasterRecognizer.h"

@implementation PWPasterEditViewController

@synthesize geoModelScrollView, colorGeoScrollView, pasterView, geoModelButtonArray, colorGeoButtonArray;
@synthesize tempTrapezium,tempTriangle ,tempEllipse,tempCircle,tempSquare,tempRectangle,tempPentacle;
@synthesize selectedPaster, themeOnwer, specificShapeArray;
@synthesize viewGestureR;
@synthesize selectedGeoImageView;
@synthesize activeGeoImageView;
@synthesize drawAniamtionView;
@synthesize fireWorkForGeo;
@synthesize  modify;
static AVAudioPlayer * geoPlayer[8];
static int indexPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.pasterView = [[UIImageView alloc] initWithFrame:CGRectMake(105, 35, 500, 500)];
        [self.pasterView setCenter:CGPointMake(530, 370)];
        self.geoModelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(105, 667, 890, 91)];
        self.geoModelScrollView.contentSize=CGSizeMake(1024,91);
        self.geoModelScrollView.alwaysBounceVertical=NO;
        self.geoModelScrollView.alwaysBounceHorizontal =NO;
        self.geoModelScrollView.scrollEnabled=YES;
        self.colorGeoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(105, 667, 890, 91)];;//设置可视化界面大小//890
        self.colorGeoScrollView.contentSize=CGSizeMake(2048,91);//真实大小
        self.colorGeoScrollView.alwaysBounceVertical=NO;
        self.colorGeoScrollView.alwaysBounceHorizontal =YES;
        self.colorGeoScrollView.scrollEnabled=YES;
        self.colorGeoScrollView.bounces=YES;
        self.colorGeoScrollView.pagingEnabled=YES;
        self.colorGeoScrollView.hidden=NO;

        self.geoModelButtonArray = [[[NSMutableArray alloc] init] autorelease];
        self.colorGeoButtonArray=[[NSMutableArray alloc] init] ;
        
        selectedGeoIndex=-1;//几何贴纸
        selectedIndex=-1;//几何颜色贴纸
        modify=NO;
        tempTriangle=nil;
        tempRectangle=nil;
        tempEllipse=nil;
        
        _scal = 1;
        _rotation = 0;
        _rotation2 = 0;
        _rotationTemp = 0;
        isFirstTimeYesorNot = YES;
        time1 = 0;
        time2 = 0;
    }
    return self;
}

-(IBAction)returnBack:(id)sender//返回下一场景
{
//    [self.selectedGeoImageView removeFromSuperview];//未初始化
    if (colorGeoButtonArray.count != 0) {
        [self returnBackToModelScrollView:nil];
    }
//    for (UIImageView * temp in self.viewGestureR.subviews) {
//         [temp removeFromSuperview];
// 
//    }
    

    [[RootViewController sharedRootViewController] popViewController];
    
}

-(IBAction)deleteBtn:(id)sender
{
    if (activeGeoImageView) {
        [activeGeoImageView removeFromSuperview];
        [activeGeoImageView release];
        activeGeoImageView=nil;
    }

}

-(void)returnBackToModelScrollView:(id)sender
{////selectedGeoIndex是几何贴纸的序号0三角形 1 矩形 2 椭圆
    NSLog(@"selectedGeoIndex=%d",selectedGeoIndex);
    NSMutableArray * tempArr;
    switch (selectedGeoIndex) {
        case 0:{
            if (tempTriangle==nil)  tempTriangle =[[NSMutableArray alloc] init] ;
             tempArr=tempTriangle;
            break;
        }
        case 1:{
            if (tempTrapezium==nil)  tempTrapezium =[[NSMutableArray alloc] init];
             tempArr=tempTrapezium;
            break;
        }
        case 2:{
            if (tempEllipse==nil)  tempEllipse =[[NSMutableArray alloc] init] ;
             tempArr=tempEllipse;
            break;
        }
        case 3:{
            if (tempCircle == nil) tempCircle = [[NSMutableArray alloc]init];
            tempArr = tempCircle;
            break;
        }
        case 4:{
            if (tempSquare == nil) tempSquare = [[NSMutableArray alloc]init];
            tempArr = tempSquare;
            break;
        }
        case 5:{
            if (tempRectangle == nil) tempRectangle = [[NSMutableArray alloc]init];
            tempArr = tempRectangle;
            break;
        }
        case 6:{
            if (tempPentacle == nil) tempPentacle = [[NSMutableArray alloc]init];
            tempArr = tempPentacle;
            break;
        }
        default:
            tempArr=nil;
            break;
    }
    if (tempArr!=nil) {
        [tempArr removeAllObjects];//清空上次记录
        [tempArr addObjectsFromArray:colorGeoButtonArray];//保存记录
       
     }
    
    for (UIView *view in [self.colorGeoScrollView subviews]) {
         [view removeFromSuperview];
     }
    NSLog(@"%d",tempArr.count);
    [self.colorGeoScrollView removeFromSuperview];
    [self.colorGeoButtonArray removeAllObjects];
    [self.view addSubview:geoModelScrollView];
     
}


-(void)tapGeoModelButton:(UIButton *)button//贴纸模板按钮被点击
{
    modify=YES;
    selectedGeoIndex = [geoModelButtonArray indexOfObject:button];
    indexPlayer = selectedGeoIndex;
    specificShapeArray = [[themeOnwer geoPasterContainer] objectAtIndex:selectedGeoIndex];//多颜色贴纸数组//themeOnwer相当于一个二维数组//存放了三个颜色数组首地址
    NSMutableArray * tempArr;
    switch (selectedGeoIndex) {
        case 0:
            tempArr=tempTriangle;
            break;
        case 1:
            tempArr=tempTrapezium;
            break;
        case 2:
            tempArr=tempEllipse;
            break;
        case 3:
            tempArr = tempCircle;
            break;
        case 4:
            tempArr = tempSquare;
            break;
        case 5:
            tempArr = tempRectangle;
            break;
        case 6:
            tempArr = tempPentacle;
            break;
        default:
            tempArr=nil;
            break;
    }
    NSLog(@"tempArr.cout=%d",tempArr.count);
    if (tempArr==nil)//首次,没有记录
    {
        NSInteger count = [specificShapeArray count];
        for (int i = 1; i < count; i++) {
            PWGeoPaster *geoPaster = [specificShapeArray objectAtIndex:i];
            UIButton *colorGeoButton=[UIButton buttonWithType:UIButtonTypeCustom];
            [colorGeoButton setFrame:geoPaster.frame];
 
            UIImage *image = [ImageConverter dataToImage:[geoPaster imageData]];
            [colorGeoButton setImage:image forState:UIControlStateNormal];
            [colorGeoButton setTag:i];//用于保存button 的下标
            
            if (geoPaster.isCreated) {
                [colorGeoButton setSelected:YES];
            }
            else{
                [colorGeoButton setSelected:NO];
            }
            [colorGeoButton addTarget:self action:@selector(tapColorGeoButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //添加拖拽手势
            UIDragGeoPasterRecognizer *drag = [[UIDragGeoPasterRecognizer alloc] init];
            [colorGeoButton addGestureRecognizer:drag];
            [drag release];
//            //添加长按手势
//            UILongPressGestureRecognizer* longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
//            //长按时间为1秒
//            longPressGesture.minimumPressDuration=1;
//            //允许15秒中 运动
//            longPressGesture.allowableMovement=15;
//            //所需触摸1次
//            longPressGesture.numberOfTouchesRequired=1;
//            [colorGeoButton addGestureRecognizer:longPressGesture];
//            [longPressGesture release];
            
            [self.colorGeoButtonArray addObject:colorGeoButton];
            [self.colorGeoScrollView addSubview:colorGeoButton];
            
        }
    }
    else//非首次，按钮从tempTriangle里面生成
    {
        for (int i =0 ; i <tempArr.count; i++) {
            NSLog(@"%d",self.colorGeoButtonArray.count);
            UIButton * colorGeoButton=[tempArr objectAtIndex:i];
//             [colorGeoButton addTarget:self action:@selector(tapColorGeoButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.colorGeoButtonArray addObject:colorGeoButton];
            [self.colorGeoScrollView addSubview:colorGeoButton];
        }
    
    
    }
    
    
    //添加返回几何贴纸model的按钮
    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 85, 85)];
    [returnButton setImage:[UIImage imageNamed:@"returnBack.png"] forState:UIControlStateNormal];
    [returnButton addTarget:self action:@selector(returnBackToModelScrollView:) forControlEvents:UIControlEventTouchUpInside];
    [self.colorGeoScrollView addSubview:returnButton];
    [returnButton release];
    
    [self.geoModelScrollView removeFromSuperview];
    [self.view addSubview:colorGeoScrollView];//添加scrollview
    
    [PWPasterEditViewController playGeoPlayer:selectedGeoIndex];//播放语音
    
}

- (void)loadSounds
{
    NSString * geo[7]={@"%@/sound_triangle.wav",@"%@/sound_trapezium.wav",@"%@/sound_ellipse.wav",@"%@/sound_circle.wav",@"%@/sound_square.wav",@"%@/sound_rectangle.wav",@"%@/sound_pentacle.wav"};
    NSString *color[18]={@"%@/sound_black.wav",@"%@/sound_red.wav",@"%@/sound_yellow.wav",@"%@/sound_light_blue.wav",@"%@/sound_green.wav",@"%@/sound_purple.wav",@"%@/sound_brown.wav",@"%@/sound_orange.wav",@"%@/sound_purple_red.wav",@"%@/sound_peach_red.wav",@"%@/sound_yellow_blue.wav",@"%@/sound_deep_purple.wav",@"%@/sound_silver.wav",@"%@/sound_deep_green.wav",@"%@/sound_blue.wav",@"%@/sound_deep_blue.wav",@"%@/sound_blue_green.wav",@"%@/sound_pink.wav"};
    NSURL * url;
    NSError *error;
    for(int i=0;i<7;i++){
        url = [NSURL fileURLWithPath:[NSString
                                      stringWithFormat:geo[i],  [[NSBundle mainBundle]  resourcePath]]];
        geoPlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        geoPlayer[i].numberOfLoops  = 0;
        if  (geoPlayer[i] == nil)      //文件不存在
            printf("音频加载失败G%d",i);
    }
    for(int i=0;i<18;i++){
        url = [NSURL fileURLWithPath:[NSString
                                      stringWithFormat:color[i],  [[NSBundle mainBundle]  resourcePath]]];
        colorPlayer[i]  = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];   //加载tap音效
        colorPlayer[i].numberOfLoops  = 0;
        if  (colorPlayer[i] == nil)      //文件不存在
            printf("音频加载失败C%d",i);
    }
}

+(void)playGeoPlayer:(int)player
{
//    player = selectedGeoIndex;
    [geoPlayer[indexPlayer] play];
}

 -(void)tapColorGeoButton:(UIButton *)button//贴纸颜色编辑
{
    
    NSLog(@"click");
//    NSLog(@"%@",button);
//     [colorGeoButton setImage:image forState:UIControlStateNormal];
    NSLog(@"state=%u",[button state]);
    selectedIndex=[button tag];
     NSLog(@"selectedindex=%d",selectedIndex);
    NSLog(@"%d",self.colorGeoButtonArray.count);
    PWGeoPaster *selectedColorGeoPaster = [specificShapeArray objectAtIndex:selectedIndex];
//    if (!(selectedColorGeoPaster.isCreated)) {//未创建可以跳转
       if (![button isSelected]) {//未创建可以跳转
        
        NSLog(@" 未创建no");
        PWGeoPasterEditViewController *geoPasterEditViewController = [[PWGeoPasterEditViewController alloc] initWithNibName:@"PWGeoPasterEditView" bundle:nil];//加载几何图形的编辑场景
           
        [geoPasterEditViewController setSelectedColorGeoPaster:selectedColorGeoPaster];
        [geoPasterEditViewController initPenArray:specificShapeArray];
        geoPasterEditViewController.selectedPenIndex=selectedIndex;
        [geoPasterEditViewController updateSelectedPen ];//让所选画笔直接突出
        [geoPasterEditViewController.drawAniamtionView setModify:self.modify];
        self.modify=NO;

        [geoPasterEditViewController typeChoose];//加载动态视图内容
        [geoPasterEditViewController setSpecificShapeA:self.specificShapeArray];
//        [self returnBackToModelScrollView:nil];
        [[RootViewController sharedRootViewController] pushViewController:geoPasterEditViewController];
        
       
    }
    else
    {
         NSLog(@"已创建，不能编辑");

    }
    
    [PWPasterEditViewController playGeoPlayer:selectedGeoIndex];//播放语音
//    [colorPlayer[selectedIndex] play];
//    [geoPlayer[selectedGeoIndex] play];
//    NSLog(@"%d",self.colorGeoButtonArray.count);


}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"CG touch began");
    
    touchBegPoint=[[touches anyObject] locationInView:self.view];
    NSLog(@"%f,%f",touchBegPoint.x,touchBegPoint.y);
    touchBegPoint.x=touchBegPoint.x-103;
    touchBegPoint.y=touchBegPoint.y-40;
    for (UIImageView * imageView  in self.viewGestureR.subviews){//循环判断点位于哪个view上
        if(![imageView isKindOfClass:[UIImageView class]])
            continue;
        else
        {
            if (CGRectContainsPoint(imageView.frame, touchBegPoint)) {
                activeGeoImageView=imageView;
             NSLog(@"with=%f,height=%f",activeGeoImageView.frame.size.width,activeGeoImageView.frame.size.height);
                NSLog(@"retaincout=%d",activeGeoImageView.retainCount);
                [self.viewGestureR bringSubviewToFront:activeGeoImageView];
                break;
            }
        }
    }


}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self panEnd:activeGeoImageView.center];

}
-(void)panEnd:(CGPoint)center//调整坐标
{
    NSLog(@"pan end ");
//    NSLog(@"x=%f,y=%f",center.x,center.y);
//    NSLog(@"%@",self.view);
    center=activeGeoImageView.center;
//    [UIView beginAnimations:nil context:nil];
    [UIView animateWithDuration:2 animations:^(void)
     {
     
     }];
    if (activeGeoImageView) {
        float  left=activeGeoImageView.frame.size.width/2;
        float top=activeGeoImageView.frame.size.height/2;
        float right=viewGestureR.frame.size.width-left;
        float bottom=viewGestureR.frame.size.height-top+15;
//        NSLog(@"bottom=%f",bottom);//-activeGeoImageView.frame.size.height/2;

        CGPoint newCenter;
//        [UIView setAnimationsEnabled:YES];
        if (center.x<left) {
            newCenter=CGPointMake(left,activeGeoImageView.center.y );
            activeGeoImageView.center=newCenter;
        }
        if (center.x>right) {
            newCenter=CGPointMake(right,activeGeoImageView.center.y);
            activeGeoImageView.center=newCenter;
        }
        if (center.y<top) {
            newCenter=CGPointMake(activeGeoImageView.center.x,top);
            activeGeoImageView.center=newCenter;
        }
        if (center.y>bottom) {
            newCenter=CGPointMake(activeGeoImageView.center.x, bottom);
            activeGeoImageView.center=newCenter;
        }
        [self.view setNeedsDisplay];
//        [UIView commitAnimations];
//        [UIView setAnimationsEnabled:NO];
    }//if


}
-(void)panDetected:(UIPanGestureRecognizer*)panGR//平移
{
    NSLog(@"panch移动");
    if (activeGeoImageView) {
        CGPoint center=activeGeoImageView.center;
        CGPoint  trans=[panGR translationInView:self.viewGestureR];
        [activeGeoImageView setCenter: CGPointMake(center.x+trans.x, center.y+trans.y)];
        [panGR setTranslation:CGPointZero inView:activeGeoImageView];
        [self panEnd:activeGeoImageView.center];
    }
    
}
-(void)panchDetected:(UIPinchGestureRecognizer *)panchGR//捏合
{
    NSLog(@"panch捏合了");
    if (activeGeoImageView) {
        CGPoint center=activeGeoImageView.center;
        float scal =[panchGR scale];
        NSLog(@"scal=%f",scal);
        
        if (scal != 1) {
            _scal = _scal * scal;
        }
        
        if (_scal >= 5) {
            _scal = 5;
        }else if (_scal <= 0.2){
            _scal = 0.2;
        }
        
        NSLog(@"_scal = %f",_scal);
        activeGeoImageView.transform=CGAffineTransformIdentity;
        activeGeoImageView.transform=CGAffineTransformRotate(activeGeoImageView.transform, 5);//恢复以前旋转角度
        CGAffineTransform transform = CGAffineTransformScale(activeGeoImageView.transform, _scal, _scal);
        activeGeoImageView.transform = transform;
        activeGeoImageView.center=center;
        [activeGeoImageView setNeedsDisplay];
         panchGR.scale=1;
        

    }//if
 
}

-(void)rotateDetected:(UIRotationGestureRecognizer *)rotateGR//旋转
{
    NSLog(@"rotate");
    if (activeGeoImageView) {
        NSLog(@"%f",rotateGR.rotation);
        float rotation = rotateGR.rotation;
        if (_rotationTemp != rotation) {
            _rotationTemp = rotation;
            _rotation = _rotation2;
        }else {
            _rotation2 = _rotation + _rotationTemp;
        }
        
        NSLog(@"_rotation = %f",_rotation);
        NSLog(@"_rotation2 = %f",_rotation2);
        CGPoint center=activeGeoImageView.center;
        activeGeoImageView.transform=CGAffineTransformIdentity;
        CGAffineTransform transform = CGAffineTransformScale(activeGeoImageView.transform, _scal, _scal);//先放大倍数
        activeGeoImageView.transform = transform;
//        activeGeoImageView.transform=CGAffineTransformRotate(activeGeoImageView.transform, _rotation);//恢复以前旋转角度
        activeGeoImageView.transform=CGAffineTransformRotate(activeGeoImageView.transform, rotateGR.rotation);
        activeGeoImageView.center=center;
        
        [self touchesEnded:nil withEvent:nil];
     }
}

-(void)updateColorButtonPosition:(UIButton *)btn//更新颜色按钮位置，创建的在前
{
    int index=[self.colorGeoScrollView.subviews indexOfObject:btn]-1;//btn前一位置下标
    UIButton * temp=[self.colorGeoScrollView.subviews objectAtIndex:index];//待交换button
    NSLog(@"位置更新");
     
    if (![btn isSelected]) {//btn 未创建 否则是放烟花
        [btn setSelected:YES];
        UIButton* temp2=[[UIButton alloc] init];
        UIButton * old=[[UIButton alloc] init];
        [old setCenter:btn.center];//新位置
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0];
        [UIView animateWithDuration:2.0 animations:^(void)
         {
         }
                         completion:^(BOOL finished)
         {
             
             [UIView animateWithDuration:1.0f delay:1.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void)
              {
                  btn.transform=CGAffineTransformMakeScale(1.3, 1.3);
                  
              }completion:^(BOOL finished)
              {
                  [self firePlay:btn];
                  btn.transform=CGAffineTransformIdentity;
                  
              }];
         }];
        
        while (index>0) {
//            NSLog(@"%@",temp);
            if (temp.isSelected==NO) {
                [temp2 setCenter:temp.center];//保存当前
                [temp setCenter:old.center];//赋新值
                [old setCenter:temp2.center];
            }
            index--;
            temp=[self.colorGeoScrollView.subviews objectAtIndex:index];
            int a=index-1;
            while (temp.isSelected&&a>0) {
                temp=[self.colorGeoScrollView.subviews objectAtIndex:a];
                if (temp.isSelected==NO) {
                    index=a;
                    break;
                }
                a--;
            }
            
            
        }//index-1的位置是最终的空位置
        [btn setCenter:old.center];
        
        [UIView commitAnimations];
         
        [temp2 release];
        [old release];

    }
    else  [self firePlay:btn];
    //重新计算geoPasterScrollerView滚动内容的长度
    NSUInteger gap = 26;
    NSUInteger sideBar = 7;
    NSUInteger widthOfGeoPaster = 85;
    NSUInteger countOfGeoPasters =18;
    NSUInteger scrollerViewLength = 2 * sideBar + countOfGeoPasters * widthOfGeoPaster + (countOfGeoPasters - 1) * gap;
    colorGeoScrollView.contentSize = CGSizeMake(scrollerViewLength, 91);
    [colorGeoScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.colorGeoScrollView setNeedsDisplay];
    
  NSLog(@"位置更新结束");
    
}

-(void)firePlay:(UIButton*)btn//几何贴纸制作成后跳转，新按钮的烟花
{
    NSLog(@"yanhua");
     //加入烟花效果
     [fireWorkForGeo bringToFront];
    CGPoint newCenter;
    newCenter.x=self.colorGeoScrollView.frame.origin.x+btn.center.x ;
    newCenter.y=self.colorGeoScrollView.frame.origin.y+btn.center.y;
    fireWorkForGeo.touchPoint = newCenter;
    [fireWorkForGeo stopAnimation];
    [fireWorkForGeo startAnimation];
    [self.view setNeedsDisplay ];
     
    
    


}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //显示选中贴纸的view//跳转后传入的贴纸
//    [self.pasterView setImage:[ImageConverter dataToImage:[selectedPaster imageData]]];
    [self.view addSubview:pasterView];

    //根据模型层[themeOwner geoPasters]中几何贴纸的数据，初始化并显示几何贴纸model的view
    for (PWGeoPaster *geoPasterModel in [themeOnwer geoPasterModels]) {
        
        UIButton *geoModelButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [geoModelButton setFrame:[geoPasterModel frame]];
        UIImage *image = [ImageConverter dataToImage:geoPasterModel.imageData];
        [geoModelButton setImage:image forState:UIControlStateNormal];
        [geoModelButton addTarget:self action:@selector(tapGeoModelButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.geoModelButtonArray addObject:geoModelButton];
        [self.geoModelScrollView addSubview:geoModelButton];
    }
    
    
    [self.view addSubview:geoModelScrollView];//添加贴纸模板滚动view
    viewGestureR=[[UIView alloc] initWithFrame:CGRectMake(103,40, 870, 600)];//x=100,y=70
//    [viewGestureR setBackgroundColor:[UIColor redColor]];
//    viewGestureR.alpha=.3;
    viewGestureR.multipleTouchEnabled=YES;
     //添加手势对象移动，点击，旋转，放缩
     
    UIPanGestureRecognizer *panGR=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];//平移手势
    [self.viewGestureR addGestureRecognizer:panGR];
    [panGR release];
        UIRotationGestureRecognizer * rotateGR=[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateDetected:)];
    [self.viewGestureR addGestureRecognizer:rotateGR];//旋转
    [rotateGR release];
    
    UIPinchGestureRecognizer * panchGR=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(panchDetected:)];//捏合
    [self.viewGestureR addGestureRecognizer:panchGR];
    [panchGR release];

    [self.view addSubview:viewGestureR];//将手势视图加入场景
    [viewGestureR release];
    //烟花效果初始化
    self.fireWorkForGeo = [[[UIFireWork alloc]initFireWorkWith:self.view]autorelease];
    self.fireWorkForGeo.animtionType = LinePathAnimation;
    
    [self loadSounds];//加载声音
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"qingchu" message:@"qingc" delegate:self cancelButtonTitle:@"close" otherButtonTitles:nil];
    [alert show];
    NSLog(@"编辑视图dealloc");
    [tempTriangle release];
    [tempRectangle release];
    [tempEllipse release];
    [activeGeoImageView release];
    [super dealloc];

}
@end
