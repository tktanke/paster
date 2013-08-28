//
//  DataStorer.m
//  Paster
//
//  Created by tzzzoz on 13-3-12.
//  Copyright (c) 2013年 Wuxiang. All rights reserved.
//

#import "DataStorer.h"

@implementation DataStorer


+(BOOL)saveObject:(id)object fileName:(NSString *)fileName
{
    NSString *path = [[self documentDirectory] stringByAppendingPathComponent:fileName];
    return [NSKeyedArchiver archiveRootObject:object toFile:path];
}

+(NSString *)documentDirectory
{
    NSArray *dirArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [dirArray objectAtIndex:0];
    NSLog(@"目录数组%@",dirArray);
    return documentDirectory;
}
@end
