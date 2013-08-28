//
//  ImageConverter.m
//  Paster
//
//  Created by tzzzoz on 13-3-11.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "ImageConverter.h"

@implementation ImageConverter


+(NSData *)imageToData:(NSString *)path orImage:(UIImage*) image
{
//    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[dirArray objectAtIndex:0] stringByAppendingPathComponent:fileName];
    if (image) {
        return UIImagePNGRepresentation(image);
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        return UIImagePNGRepresentation(image);
    }
}

+(UIImage *)dataToImage:(NSData *)data
{
    return [UIImage imageWithData:data];
}
@end
