//
//  PWPasterFactory.m
//  Paster
//
//  Created by tzzzoz on 13-3-19.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "PWPasterFactory.h"
#import "ImageConverter.h"

@implementation PWPasterFactory


-(PWPaster *)createPasterWithRect:(CGRect)rect
                        image:(UIImage*)image
                  imageFolderPath:(NSString *)path
{
    
    NSData *data = [ImageConverter imageToData:nil orImage:image];
    
    PWPaster *paster = [[PWPaster alloc] initWithFrame:rect imageData:data];
    return paster;
}

-(PWGeoPaster *)createGeoPasterWithRect:(CGRect)rect
                                   type:(GeometryType)type
                                  color:(ColorType)color
                              imageFile:(NSString *)fileName
                        imageFolderPath:(NSString *)path
{
    NSData *data = [ImageConverter imageToData:[path stringByAppendingFormat:@"/CreatedGeometries/%@", fileName] orImage:nil];
    PWGeoPaster *geoPaster = [[PWGeoPaster alloc] initWithFrame:rect imageData:data type:type color:color];
    geoPaster.frame = rect;
    geoPaster.isCreated = YES;
    return geoPaster;
}

-(PWGeoPaster *)createGeoPasterEmptyWithRect:(CGRect)rect
                                        type:(GeometryType)type
                                       color:(ColorType)color
                                   imageFile:(NSString *)fileName
                             imageFolderPath:(NSString *)path
{
    NSData *data = [ImageConverter imageToData:[path stringByAppendingFormat:@"/EmptyGeomatries/%@", fileName] orImage:nil];
    PWGeoPaster *geoPaster = [[PWGeoPaster alloc] initWithFrame:rect imageData:data type:type color:color];
    geoPaster.frame = rect;
    geoPaster.isCreated = NO;
    return geoPaster;
}

-(PWGeoPaster *)createGeoPasterModelWithRect:(CGRect)rect
                                       type:(GeometryType)type
                                      color:(ColorType)color
                                  imageFile:(NSString *)fileName
                            imageFolderPath:(NSString *)path
{
    NSData *data = [ImageConverter imageToData:[path stringByAppendingFormat:@"/GeometryModels/%@", fileName] orImage:nil];
    PWGeoPaster *geoPasterModel = [[PWGeoPaster alloc] initWithFrame:rect imageData:data type:type color:color];
    geoPasterModel.frame = rect;
    return geoPasterModel;
}

@end
