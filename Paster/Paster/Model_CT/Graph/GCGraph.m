//
//  GCGraph.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraph.h"
#import "Constraint.h"
#import "ConstraintGraph.h"

@implementation GCGraph

@synthesize constraintList;
@synthesize local_graph_id;
@synthesize graphType;
@synthesize isDraw;
@synthesize isSelected;
@synthesize graphColor,strokeSize;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Initialization code here.
        local_graph_id = -1;
        isDraw = YES;
        isSelected = NO;
        constraintList = [[NSMutableArray alloc]init];
        strokeSize = 5.0f;
        graphColor = [[UIColor blackColor]CGColor];
    }
    
    return self;
}

-(id)initWithId:(int)temp_local_graph_id
{
    self = [super init];
    
    local_graph_id = temp_local_graph_id;
    isDraw = YES;
    isSelected = NO;
    
    strokeSize = 5.0f;
    graphColor = [[UIColor blackColor]CGColor];
    constraintList = [[NSMutableArray alloc]init];
    
    return self;
}

-(id)initWithId:(int)temp_local_graph_id andType:(GraphType)graphType1
{
    self = [super init];
    
    self.local_graph_id = temp_local_graph_id;
    self.graphType      = graphType1;
    isDraw              = YES;
    isSelected          = NO;
    constraintList      = [[NSMutableArray alloc]init];
    
    strokeSize = 5.0f;
    graphColor = [[UIColor blackColor]CGColor];
    
    return self;
}

-(void)clearConstraint
{
    [constraintList removeAllObjects];
}

-(void)constructConstraintGraph1:(GCGraph *)graph1 Type1:(ConstraintType)type1 Graph2:(GCGraph *)graph2 Type2:(ConstraintType)type2
{
    Constraint* constraint1      = [[Constraint alloc]init];
    constraint1.constraintType   = type1;
    constraint1.related_graph_id = graph2.local_graph_id;
    constraint1.relatedGraph     = graph2;
    
    Constraint* constraint2 = [[Constraint alloc]init];
    constraint2.constraintType   = type2;
    constraint2.related_graph_id = graph1.local_graph_id;
    constraint2.relatedGraph     = graph1;
    
    [graph1.constraintList addObject:constraint1];
    [graph2.constraintList addObject:constraint2];
    
}

-(Boolean)recognizeConstraintWithGraph:(GCGraph *)graphTemp PointList:(NSMutableArray *)pointList
{
    return YES;
}

-(void)setGraphColorWithColorRef:(CGColorRef)colorRef
{
    graphColor = colorRef;
}

-(void)drawWithContext:(CGContextRef)context{}
//
//-(void)dealloc
//{
//    [constraintList release];
//    [super dealloc];
//}


@end
