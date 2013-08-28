//
//  PWNavigationViewController.m
//  Paster
//
//  Created by mac on 13-6-25.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "PWNavigationViewController.h"
#import "RootViewController.h"

@interface PWNavigationViewController ()

@end

@implementation PWNavigationViewController

@synthesize audioPlayer;
@synthesize jumpPlayer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)pressAboutBtn:(id)sender
{
    RootViewController * rootViewC=[RootViewController sharedRootViewController];
    
    [rootViewC pushViewController:[rootViewC helpViewController]];

}

-(IBAction)pressThemeBtn:(id)sender
{
    RootViewController * rootViewC=[RootViewController sharedRootViewController];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [rootViewC pushViewController:[rootViewC mainViewController]];

    [UIView commitAnimations];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
