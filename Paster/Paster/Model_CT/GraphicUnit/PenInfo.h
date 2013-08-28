//
//  PenInfo.h
//  Dudel
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCPoint.h"
@interface PenInfo : NSObject
{
    NSMutableArray *points;
}
@property (retain) NSMutableArray *points;

- (id) initWithPoints:(NSMutableArray*) temp;
- (NSMutableArray*) oldPenInfo;
- (NSMutableArray*) newPenInfo;

@end
