//
//  UIDragGeoPasterRecognizer.m
//  Sketch Integration
//
//  Created by 付 乙荷 on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDragGeoPasterRecognizer.h"
#import "RootViewController.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "PWGeoPasterEditViewController.h"

@implementation UIDragGeoPasterRecognizer

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"drag  touch began");
    [self.view.superview touchesBegan:touches withEvent:event];
    swipe=-1;
    indexBt=-1;
    indexBt=[self.view tag];
    UITouch  *touch=[touches anyObject];
    startPoint = [touch locationInView:self.view.superview.superview];//相对场景的坐标
     NSLog(@"%f,%f",startPoint.x,startPoint.y);

    UIButton * btn=(UIButton *)self.view;
  if (!btn.isSelected) {//选中
      indexBt=-1;
      swipe=1;
      NSLog(@" 未创建了");
  }
    [PWPasterEditViewController playGeoPlayer:Nil];
 }

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"drag  touch move");
//    [super touchesMoved:touches withEvent:event];
    //计算位移=当前位置-起始位置
    CGPoint currPoint = [[touches anyObject]locationInView:self.view.superview.superview];//当前场景
    CGPoint prePoint=[[touches anyObject]previousLocationInView:self.view.superview.superview ];//在scorllView里面
    float dx=currPoint.x-prePoint.x;
    float dy=currPoint.y-prePoint.y;
    NSLog(@"%d",swipe);
    if (swipe==-1) {//首次对方向进行判断
        if (abs(dx)>abs(dy)) {
            swipe=1;//表示为左右滑动
             indexBt=-1;
            NSLog(@"swipe");
        }
        else{
            swipe=0;
            selectedGeoImageView=[[UIImageView alloc]initWithFrame:self.view.frame];
            [selectedGeoImageView initWithImage:[(UIButton*)self.view imageForState:UIControlStateNormal]];
            scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.toValue  = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
            scaleAnimation.duration = 0.1f;
            scaleAnimation.fillMode = kCAFillModeForwards;
            [selectedGeoImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
            [self.view.superview.superview addSubview:selectedGeoImageView];
            selectedGeoImageView.frame = CGRectMake(0,0, selectedGeoImageView.frame.size.width*1.5, selectedGeoImageView.frame.size.height*1.5);
            selectedGeoImageView.center=startPoint;
            
            [selectedGeoImageView release];//release
            [[[[RootViewController sharedRootViewController] pasterEditViewController] colorGeoScrollView] setScrollEnabled:NO];
            NSLog(@"no  swipe");
        }
    }
    if (swipe==0) {//上下拖拽
        NSLog(@"yundong");
        CGPoint newcenter=CGPointMake(selectedGeoImageView.center.x+ dx, selectedGeoImageView.center.y+dy);
        selectedGeoImageView.center=newcenter;
 
     }
 
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"drag  touch end");
    NSLog(@"index=%d",indexBt);
    if (indexBt>=0) {
        CGPoint currPoint = [[touches anyObject]locationInView:self.view.superview.superview];//当前场景里面
        float  dy=startPoint.y-currPoint.y;
        NSLog(@"dy=%f",dy);
        NSLog(@"rentcout=%d",selectedGeoImageView.retainCount);
        
        if (abs(dy)<100&&(selectedGeoImageView!=nil)) {//没有拖出scrollview
            selectedGeoImageView.frame=CGRectMake(startPoint.x, startPoint.y, selectedGeoImageView.frame.size.width/1.5, selectedGeoImageView.frame.size.height/1.5);
            [selectedGeoImageView removeFromSuperview];
             
        }
        else//新创建一个uiimage 加入手势识别的父视图viewGestureR中
        {
            UIImageView * imageTemp=[[UIImageView alloc] initWithFrame:CGRectMake(selectedGeoImageView.frame.origin.x-103, selectedGeoImageView.frame.origin.y-40, selectedGeoImageView.frame.size.width, selectedGeoImageView.frame.size.height)] ;//100 ,70
            [imageTemp setImage:[selectedGeoImageView image]];
            [[[RootViewController sharedRootViewController] pasterEditViewController].viewGestureR addSubview:imageTemp];
            [[[RootViewController sharedRootViewController] pasterEditViewController] setActiveGeoImageView:imageTemp];
            [[[RootViewController sharedRootViewController] pasterEditViewController] panEnd:imageTemp.center];
            [imageTemp retain];
            [imageTemp release];
            
            [selectedGeoImageView removeFromSuperview];
            [selectedGeoImageView release];
            selectedGeoImageView=nil;
        }
    }//if
//    [];
    NSLog(@"end%@",self.view);
    [self.view setNeedsDisplay];
    [[[[RootViewController sharedRootViewController] pasterEditViewController] colorGeoScrollView] setScrollEnabled:YES];
 }

@end
