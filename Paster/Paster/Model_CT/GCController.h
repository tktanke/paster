//
//  GCController.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-7.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCUnitFactory.h"
#import "GCGraphFactory.h"
#import "Constraint.h"

@interface GCController : NSObject
{
    NSMutableArray * keyPoint;

}
@property (retain)NSMutableArray * keyPoint;
-(void)createGraph:(NSMutableArray *)arrayPointsInStroke
      nowGraphList:(NSMutableArray *)nowGraphList
          unitList:(NSMutableArray *)unitList
         graphList:(NSMutableArray *)graphList
    pointGraphList:(NSMutableArray *)pointGraphList
     savePointList:(NSMutableArray *)savePointList
     saveGraphList:(NSMutableArray *)saveGraphList
penColor:(UIColor *)color;

@end
