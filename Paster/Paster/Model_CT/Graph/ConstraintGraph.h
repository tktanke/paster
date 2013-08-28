//
//  ConstraintGraph.h
//  SmartGeometry
//
//  Created by kwan terry on 11-12-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GCGraph.h"
#import "GCGraphicUnit.h"

@class GCGraph;
@interface ConstraintGraph : NSObject
{
    GCGraph* graph1;
    GCGraph* graph2;
    ConstraintType constraintType;
}

@property (readwrite)           ConstraintType   constraintType;
@property (retain,nonatomic)    GCGraph*         graph1;
@property (retain,nonatomic)    GCGraph*         graph2;

@end
