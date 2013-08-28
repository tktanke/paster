//
//  UIFireWork.m
//  AnimationEffect
//
//  Created by kwan terry on 12-6-1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIFireWork.h"

@implementation UIFireWork

@synthesize particleArray,superView,fireWorkTimer;
@synthesize countOfParticle,countOfAnimation;
@synthesize touchPoint,currentIndex,isTouch,isDraw;
@synthesize animtionType;

static int stopCount = 0;
static float colors[12][3]=             //烟花颜色数组
{
    {0.0f,0.5f,0.5f},{0.0f,0.25f,0.5f},{0.0f,0.0f,0.5f},{0.25f,0.0f,0.5f},
    {0.5f,0.0f,0.5f},{0.5f,0.0f,0.25f},{0.5f,0.0f,0.5f},{0.5f,0.25f,0.0f},
    {0.5f,0.5f,0.0f},{0.25f,0.5f,0.0f},{0.0f,0.5f,0.0f},{0.0f,0.5f,0.25f}
};

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(id)initFireWorkWith:(UIView *)superViewTmp
{
    self = [super init];
    
    if(self)
    {
        countOfAnimation = 1;
        countOfParticle  = 30;
        
        currentIndex = 0;
        isTouch = NO;
        isDraw  = NO;
        
        superView = superViewTmp;
        
        animtionType = NoneAnimation;
        
        //初始化粒子数组
        self.particleArray = [[[NSMutableArray alloc]init]autorelease];
        for(int i=0; i<countOfParticle; i++)
        {
            UIImage* tempImage          = [UIImage imageNamed:@"fireWorkImage.png"];
            UIParticle* tempParticle    = [[UIParticle alloc]initWithImage:tempImage];
            tempParticle.layer.opacity  = 0.0f;
            tempParticle.transform      = CGAffineTransformMakeScale(0.5, 0.5);
            tempParticle.isMove         = NO;
            tempParticle.drawCount      = countOfAnimation;
            tempParticle.center         = CGPointMake(0.0, 0.0);
            //颜色初始化
            UIColor* colorUI = [[UIColor alloc]initWithRed:colors[i%12][0] green:colors[i%12][1] blue:colors[i%12][2] alpha:1.0];
            [tempParticle changeColorWithColor:colorUI];
            [colorUI release];
            [particleArray addObject:tempParticle];
            [superViewTmp addSubview:tempParticle];
            [tempParticle release];
        }
        
        //启动监测
        self.fireWorkTimer = [[NSTimer scheduledTimerWithTimeInterval:0.015f target:self selector:@selector(draw) userInfo:nil repeats:YES]autorelease];
    }
    
    return self;
}

-(void)bringToFront
{
    for(int i=0; i<countOfParticle; i++)
    {
        UIParticle* tempParticle = [particleArray objectAtIndex:i];
        [superView bringSubviewToFront:tempParticle];
    }
}

-(void)startAnimation
{
    isDraw = YES;
    currentIndex = 0;
    for(int i=0; i<countOfParticle; i++)
    {
        UIParticle* tempParticle = [particleArray objectAtIndex:i];
        tempParticle.drawCount = countOfAnimation;
        tempParticle.center = touchPoint;
        if(animtionType == LinePathAnimation)
        {
            tempParticle.isMove = YES;
            tempParticle.rotateDirection = i;
            tempParticle.layer.opacity = 1.0f;
        }
        else if(animtionType == CurvePathAnimation)
        {
            tempParticle.isMove = NO;
            tempParticle.layer.opacity = 0.0f;   
        }
    }
}

-(void)stopAnimation
{
    isDraw = NO;
    currentIndex = 0;
    for(int i=0; i<countOfParticle; i++)
    {
        UIParticle* tempParticle = [particleArray objectAtIndex:i];
        tempParticle.drawCount = countOfAnimation;
        tempParticle.center = touchPoint;
        tempParticle.isMove = NO;
        tempParticle.layer.opacity = 0.0f;
    }
}

-(void)draw
{
    if(isDraw)
    {
        if(animtionType == CurvePathAnimation)
        {
            if(currentIndex == countOfParticle)
            {
                currentIndex = 0;
            }
            
            //当前粒子的数据
            UIParticle* particleCurrent = [particleArray objectAtIndex:currentIndex];
            if(!particleCurrent.isMove && particleCurrent.drawCount > 0)
            {
                particleCurrent.center = touchPoint;
                particleCurrent.isMove = YES;
                particleCurrent.rotateDirection = currentIndex;
                particleCurrent.layer.opacity = 1.0f;
            }
            else if(particleCurrent.drawCount <= 0)
            {
                stopCount++;
            }
            
            //监测是否停止
            if(stopCount >= countOfParticle)
            {
                isDraw = NO;
                stopCount = 0;
                return;
            }
            
            currentIndex++;
            
            //所有粒子的运动
            for(int i=0; i<countOfParticle; i++)
            {
                UIParticle* tempParticle = [particleArray objectAtIndex:i];
                if(tempParticle.isMove)
                {
                    float x = tempParticle.center.x;
                    float y = tempParticle.center.y;
                    x += cosf(tempParticle.rotateDirection)*3.2;
                    y += sinf(tempParticle.rotateDirection)*3.2;
                    tempParticle.center = CGPointMake(x, y);
                    tempParticle.layer.opacity -= 0.03f;
                    if(tempParticle.layer.opacity <= 0.0f)
                    {
                        tempParticle.isMove = NO;
                        tempParticle.drawCount--;
                    }
                }
            }
        }
        else if(animtionType == LinePathAnimation)
        {
            //直线运动动画所有粒子都是同时运动
            for(int i=0; i<countOfParticle; i++)
            {
                UIParticle* tempParticle = [particleArray objectAtIndex:i];
                if(tempParticle.isMove)
                {
                    float x = tempParticle.center.x;
                    float y = tempParticle.center.y;
                    x += cosf(tempParticle.rotateDirection)*3.2;
                    y += sinf(tempParticle.rotateDirection)*3.2;
                    tempParticle.center = CGPointMake(x, y);
                    tempParticle.layer.opacity -= 0.03f;
                    if(tempParticle.layer.opacity <= 0.0f)
                    {
                        tempParticle.isMove = NO;
                        tempParticle.drawCount--;
                    }
                }
            }
        }
 
    }
}

-(void)dealloc
{
    [super dealloc];
    
    [particleArray release];
    [superView release];
    [fireWorkTimer release];
}

@end
