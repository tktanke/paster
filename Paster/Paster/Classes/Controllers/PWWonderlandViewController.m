//
//  PWWonderlandViewController.m
//  Paster
//
//  Created by tzzzoz on 13-3-20.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "PWWonderlandViewController.h"

@interface PWWonderlandViewController ()

@end

@implementation PWWonderlandViewController

@synthesize bgImageView, pasterButtonArray;
@synthesize selectedTheme;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pasterButtonArray = [[NSMutableArray alloc] init];
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    }
    return self;
}


-(IBAction)returnBack:(id)sender
{
    [[RootViewController sharedRootViewController] popViewController];
}

-(void)tapPasterButton:(UIButton *)button//图形被选中，图形都是用按钮表示，图形参数为button
{
    //告诉下一个控制器，哪一个pasterButton被点击了
    NSInteger selectedIndex = [pasterButtonArray indexOfObject:button];
    PWPaster *selectedPaster = [[selectedTheme pasters] objectAtIndex:selectedIndex];
    //开始跳转加载贴纸编辑场景
 
//   PWPasterEditViewController* pasterEditViewController=[[PWPasterEditViewController alloc] initWithNibName:@"PWPasterEditView" bundle:nil];//贴纸编辑场景
    
    PWPasterEditViewController *pasterEditViewController = [[RootViewController sharedRootViewController] pasterEditViewController];
    [pasterEditViewController setSelectedPaster:selectedPaster];
    [pasterEditViewController setThemeOnwer:[self selectedTheme]];
    [pasterEditViewController setTitle:@"is pasterEditViewController"];
     [pasterEditViewController.pasterView setImage:[ImageConverter  dataToImage:[selectedPaster imageData]]];//显示传过来的贴纸
    [pasterEditViewController.view setNeedsDisplayInRect:selectedPaster.frame];
    [[RootViewController sharedRootViewController] pushViewController:pasterEditViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //显示背景
    [self.bgImageView setImage:[selectedTheme backgroundImage]];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
    
    //根据模型层theme中的pasters的数据，在视图上显示pasterButton
    for (PWPaster *paster in [selectedTheme pasters]) {
        UIButton *pasterButton = [[UIButton alloc] initWithFrame:paster.frame];
        UIImage *image = [ImageConverter dataToImage:paster.imageData];
        [pasterButton setImage:image forState:UIControlStateNormal];
        
        [pasterButtonArray addObject:pasterButton];
        [pasterButton addTarget:self action:@selector(tapPasterButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pasterButton];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
