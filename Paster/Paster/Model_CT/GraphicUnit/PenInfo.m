//
//  PenInfo.m
//  Dudel
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "PenInfo.h"
@implementation PenInfo
@synthesize points;

- (id)initWithPoints:(NSMutableArray *)temp{
    self.points = temp;
    return self;
}

- (NSMutableArray *)oldPenInfo{
    return points;
}

- (NSMutableArray *)newPenInfo{
    GCPoint *point;
    GCPoint *nextPoint;
    GCPoint *prePoint;
    
    // 高 斯 卷 积 进 行 平 滑 处 理
    for(int i=0;i<4;i++){
        for (int j=0;j<[points count]-1;j++){
            point = [points objectAtIndex:j];
            nextPoint = [points objectAtIndex:j+1];
            point.x = point.x*0.7 + nextPoint.x*0.3;
            point.y = point.y*0.7 + nextPoint.y*0.3;
        }
        for (int j=[points count]-1;j>0;j--){
            point = [points objectAtIndex:j];
            prePoint = [points objectAtIndex:j-1];
            point.x = point.x*0.7 + prePoint.x*0.3;
            point.y = point.y*0.7 + prePoint.y*0.3;
        }
    }
    
    
    // 去 除 3 % 的 首 点 和 尾 点
    if([points count]>20){
        int sourSize=[points count];
        int delSize=[points count]*0.03;
        GCPoint *it_S = [points objectAtIndex:0];
        int i=0;
        while(![it_S isEqual:[points lastObject]]){
            if(delSize>i||(sourSize-delSize)<=i)
            {
                [points removeObject:it_S];
            }
            i++;
            it_S = [points objectAtIndex:i];
        }
    }
     
    return self.points;
}
//
//-(void)dealloc
//{
//    [super dealloc];
//    [points release];
//}

@end
