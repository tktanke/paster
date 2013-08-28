//
//  DKDrawCanvas.m
//  Sketch Integration
//
//  Created by  on 12-4-24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DKDrawCanvas.h"

@implementation DKDrawCanvas
//@synthesize drawCanvasView;
@synthesize juedgeGeoArray;
@synthesize geometryForJudge;

- (id)init
{
    self = [super init];
    if (self) 
    {
         [self initWithPlist];
    }
    
    return self;
}

-(void)initWithPlist
{
    juedgeGeoArray = [[NSMutableArray alloc]init];
    
    NSString* plistPath = [[NSBundle mainBundle]pathForResource:@"GeometryData" ofType:@"plist"];
    NSDictionary* dataOfPlist = [[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSArray* dataOfGeometry = [dataOfPlist objectForKey:@"GeometryData"];
    for(int i=0; i<[dataOfGeometry count]; i++)
    {
        NSMutableArray* tempArray = [[[NSMutableArray alloc]init] autorelease];
        NSArray* geoItemArray = [dataOfGeometry objectAtIndex:i];
        for(int j=0; j<[geoItemArray count]; j++)
        {
            CGPoint tempPoint;
            NSNumber* num = [geoItemArray objectAtIndex:j];
            tempPoint.x = [num floatValue];
            NSNumber* nextNum = [geoItemArray objectAtIndex:++j];
            tempPoint.y = [nextNum floatValue];
            [tempArray addObject:[NSValue valueWithCGPoint:tempPoint]];
        }
        [juedgeGeoArray addObject:tempArray];
    }
}

//-(CGRect)judegeRec:(CGPoint)point
//{
//    return CGRectMake(point.x-30.0f, point.y-30.f, 60.0f, 60.0f);
//}
// 

-(void)dealloc
{
    [super dealloc];
    [drawCanvasView release];
}

@end
