//
//  ImageSpliter.h
//  Paster
//
//  Created by tzzzoz on 13-5-9.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageSpliter : NSObject

+(NSMutableArray *)separateImage:(UIImage *)image ByX:(int)x andY:(int)y;
@end
