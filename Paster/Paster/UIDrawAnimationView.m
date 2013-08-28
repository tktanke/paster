//
//  UIDrawAnimationView.m
//  Sketch Integration
//
//  Created by kwan terry on 12-6-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIDrawAnimationView.h"

@implementation UIDrawAnimationView

@synthesize animationLayer,pathLayer,penLayer;
@synthesize geoType;
@synthesize dataList;
@synthesize path;
@synthesize  modify;
-(void)dealloc
{
    [super dealloc];
    [animationLayer release];
    [pathLayer release];
    [penLayer release];
    [dataList release];
    [path release];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
        self.animationLayer = [CALayer layer];
        self.animationLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
//        modify=YES;
        [self.layer addSublayer:self.animationLayer];
        
    }
    return self;
}

-(void)changeDrawAnimationWithGeoType:(GeometryType)type DataList:(NSMutableArray*)plist
{
    if(dataList == nil)
    {
        self.dataList = plist;   
    }
    NSLog(@"%d",self.geoType);
    NSLog(@"%d",type);
     self.geoType  = type;
    [self setupDrawingLayer];
}

-(void)setupDrawingLayer
{
    if(self.pathLayer != nil)
    {
        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
        self.penLayer  = nil;
    }

    NSMutableArray* drawDataList = [dataList objectAtIndex:geoType];
    //确定路径
    switch(geoType)
    {
        case 0://三角形
        case 1://梯形
        case 5://四边形
        case 6://矩形
        case 3://五角星形
        {
            self.path = [UIBezierPath bezierPath];
            NSLog(@"item0=%@",[drawDataList objectAtIndex:0]);
            CGPoint firstPoint = [[drawDataList objectAtIndex:0]CGPointValue];
            NSLog(@"x=%f y=%f",firstPoint.x,firstPoint.y);
            
            firstPoint = CGPointMake(firstPoint.x, self.frame.size.height-firstPoint.y);
            
            NSLog(@"x=%f y=%f",firstPoint.x,firstPoint.y);
            [path moveToPoint:firstPoint];
            for(int i=(drawDataList.count-1); i>=0; i--)
            {
                CGPoint tempPoint = [[drawDataList objectAtIndex:i]CGPointValue];
                tempPoint = CGPointMake(tempPoint.x, self.frame.size.height-tempPoint.y);
                [path addLineToPoint:tempPoint];
            }
            break;
        }
        case 2://椭圆
            self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(135,35, 249, 430)];//(260, 14, 297, 511)
            break;
        case 4://圆形
            self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(45, 45, 420, 420)];
            break;
        default:
            break;
    }
    
    self.pathLayer  = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.geometryFlipped = YES;
    pathLayer.path  = path.CGPath;
    pathLayer.strokeColor = [[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:255/255.0f]CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 8.0f;//10.0
    pathLayer.lineJoin  = kCALineJoinRound;
    [animationLayer addSublayer:pathLayer];
    
    UIImage* penImage = [UIImage imageNamed:@"penImage.png"];
    self.penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(path.currentPoint.x, path.currentPoint.y, penImage.size.width, penImage.size.height);        
    [pathLayer addSublayer:penLayer];
    
}

-(void)startAnimation
{
    [self.pathLayer removeAllAnimations];
    [self.penLayer removeAllAnimations];
    
    self.layer.opacity = 1.0f;
    self.penLayer.hidden  = NO;
    self.pathLayer.hidden = NO;
    
    [self.superview setUserInteractionEnabled:NO];
    
    CABasicAnimation* pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 4.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CAKeyframeAnimation* penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = 4.0;
    penAnimation.path = self.pathLayer.path;
    penAnimation.calculationMode = kCAAnimationCubicPaced;
    penAnimation.delegate = self;
    
    [self.penLayer addAnimation:penAnimation forKey:@"position"];
}

-(void)stopAnimation
{
    [pathLayer removeAllAnimations];
    [penLayer  removeAllAnimations];
    pathLayer.hidden = YES;
    penLayer.hidden  = YES;
    
    [self.superview setUserInteractionEnabled:YES];
    [self removeFromSuperview];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.layer.opacity = 0.0f;
    } completion:^(BOOL finished) {
        [self stopAnimation];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
