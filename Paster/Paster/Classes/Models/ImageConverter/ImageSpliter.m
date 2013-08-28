//
//  ImageSpliter.m
//  Paster
//
//  Created by tzzzoz on 13-5-9.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "ImageSpliter.h"

@implementation ImageSpliter

//切割图片
//返回一个UIImage 的数组
//参数：image    分割的行数x    分割的列数y
+(NSMutableArray *)separateImage:(UIImage *)image ByX:(int)x andY:(int)y
{
    float  x_NewImg=image.size.width*1.0/x;
    float  y_NewImg=image.size.height*1.0/y;
    
    NSLog(@"width=%f",image.size.width);
    NSLog(@"height=%f",image.size.height);
    
    NSLog(@"切割大小之宽=%f",x_NewImg);
    NSLog(@"切割大小之高=%f",y_NewImg);
    
    //保存分割后的图片
    NSMutableArray *multableImgArray=[[NSMutableArray alloc] initWithCapacity:1];
    
    for (int  j=0;j<y;j++)
    {
        for (int i=0;i<x; i++)
        {
            NSLog(@"当前的切割的其实坐标==%f,%f",x_NewImg*i,y_NewImg*j);
            
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage], CGRectMake(x_NewImg*i, y_NewImg*j, x_NewImg, y_NewImg));
            UIImage *eleImg=[UIImage imageWithCGImage:imageRef];
            //分割后Image的名字
            [multableImgArray addObject:eleImg];
        }
    }
    return multableImgArray;
}

@end
