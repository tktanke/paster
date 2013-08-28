//
//  GCGraphFactory.m
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraphFactory.h"

@implementation GCGraphFactory

int graph_id = 0;

-(id)initWithParameter:(NSMutableArray *)pListt
{
    self = [super init];
    
    pList = pListt;
    
    return self;
}

//same function as bind_unit_to_graphs in previous factory
-(GCGraph *)createWithSimpleUnit:(GCGraphicUnit *)unit
                        UnitList:(NSMutableArray *)unitList
{
    if(unit==NULL)
        return NULL;
    [unitList addObject:unit];
    GCGraph* graph=NULL;
    switch(unit.type)
    {
        case 0:
            graph = [[GCPointGraph alloc]initWithUnit:(GCPointUnit*)unit andId:graph_id];
            break;
        case 1:
            graph = [[GCLineGraph alloc]initWithLine:(GCLineUnit*)unit andId:graph_id];
            break;
        case 2:
            //绑定二次曲线图形
            graph = [[GCCurveGraph alloc]initWithCurveUnit:(GCCurveUnit*)unit ID:graph_id];
            break;
        case 3:
            //绑定非二次曲线图形
            graph = [[GCCurveGraph alloc]initWithCurveUnit:(GCCurveUnit*)unit ID:graph_id];
            break;
            
    }
    if(NULL!=graph)
        graph_id++;
    return graph;
}

-(NSMutableArray *)createComplexGraph:(Stroke *)stroke
                      UnitList:(NSMutableArray *)unitList
{
    GCGraph * graph = nil;
    NSMutableArray * graphArray = [[NSMutableArray alloc]init];
    if([stroke.specialList count] > 2)
    {
        BOOL is_triangle = [self rebuild_triangle:stroke];
        if(is_triangle)//先进行三角形识别
        {
            graph = [self create_Triangle_Graph:stroke :unitList :unitList];
            [graphArray addObject:graph];
        }
        else
        {
            BOOL is_retangle = [self rebuild_rectangle:stroke];  //判断能否生成四边形
            if(is_retangle)
            {
                graph = [self create_Rectangle_Graph:stroke :unitList :unitList]; //生成四边形
                [graphArray addObject:graph];
            }
            else
            {
                NSLog(@"Not triangle nor retangle!");
                //第二次识别中，非四边形或三角形，切割成小的图元生成图形
                BOOL is_hybridunit = [self rebuild_hybridunit:stroke];
                
                if(is_hybridunit)
                {
                    for(int i=0; i<stroke.gList.count; i++)
                    {
                        GCGraphicUnit* tempUnitFromList = [stroke.gList objectAtIndex:i];
                        GCGraph* tempGraph = [self createWithSimpleUnit:tempUnitFromList UnitList:unitList];
                        [graphArray addObject:tempGraph];
                    }
                }
                else
                {
                    GCCurveUnit* tempCurveUnit = [[GCCurveUnit alloc]initWithPointArray:pList ID:1];
                    GCGraph* tempCurveGraph = [self createWithSimpleUnit:tempCurveUnit UnitList:unitList];
                    //[tempCurveUnit release];
                    [graphArray addObject:tempCurveGraph];
                }
            }
        }
    }
    else
    {
        GCCurveUnit* tempCurveUnit = [[GCCurveUnit alloc]initWithPointArray:pList ID:1];
        GCGraph* tempCurveGraph = [self createWithSimpleUnit:tempCurveUnit UnitList:unitList];
        //[tempCurveUnit release];
        [graphArray addObject:tempCurveGraph];
    }
    return graphArray;
}


-(BOOL)rebuild_line:(Stroke *)stroke
{
    [stroke.gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    for (int i=0;i<[stroke.specialList count]-1;i++)
    {
        NSMutableArray *temp  = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [stroke.specialList objectAtIndex:i];
        nextSpecialPointId = [stroke.specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        [stroke.gList addObject:[stroke recognize:temp]];
        //[temp release];
    }
    
    if ([stroke.gList count]==1) {
        GCGraphicUnit *unit;
        unit = [stroke.gList objectAtIndex:0];
        if (unit.type==1) {
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_triangle:(Stroke *)stroke
{
    [stroke.gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    //    NSMutableArray* sl = specialList;
    //    NSMutableArray* pl = [[NSMutableArray alloc]init];
    //    for(int i=0; i< [sl count]; i++)
    //    {
    //        NSNumber* num = [sl objectAtIndex:i];
    //        [pl addObject:[pList objectAtIndex:[num intValue]]];
    //    }
    
    for (int i=0;i<[stroke.specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [stroke.specialList objectAtIndex:i];
        nextSpecialPointId = [stroke.specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        GCGraphicUnit* unitTempAfterRecognize = [stroke recognize:temp];
        
        if(unitTempAfterRecognize != NULL)
        {
            [stroke.gList addObject:unitTempAfterRecognize];
        }
        else
        {
            //[temp release];
            return NO;
        }
        //[temp release];
    }
    
    NSMutableArray* array = stroke.gList;
    if([array count]==3)
    {
        int tag=0;
        GCPointUnit *unit;
        for(int i=0;i<3;i++)
        {
            unit = [stroke.gList objectAtIndex:i];
            if(unit.type == 1)
            {
                tag++;
            }
        }
        
        GCPoint *startSpecialPoint;
        GCPoint *endSpecialPoint;
        NSNumber *startSpecialPointId;
        NSNumber *endSpecialPointId;
        startSpecialPointId = [stroke.specialList objectAtIndex:0];
        endSpecialPointId = [stroke.specialList objectAtIndex:3];
        startSpecialPoint = [pList objectAtIndex:[startSpecialPointId intValue]];
        endSpecialPoint = [pList objectAtIndex:[endSpecialPointId intValue]];
        
        if ((tag==3) && [Threshold Distance:startSpecialPoint :endSpecialPoint] < is_closed)// 判 定 为 三 角 形 的 条 件 ， 阀 值 可 调 ，is_closed 标 志 两 个 特 征 点 在 可 误 差 范 围 内 重 合
        {
            //            GCLineUnit* temp1=[gList objectAtIndex:0];
            //            GCLineUnit* temp2=[gList objectAtIndex:1];
            //            GCLineUnit* temp3=[gList objectAtIndex:2];
            //
            //            [temp2 setstart:temp1.end];
            //            [temp3 setstart:temp2.end];
            //            [temp3 setend:temp1.start];
            
            
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_rectangle:(Stroke*)stroke
{
    [stroke.gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    
    
    for (int i=0;i<[stroke.specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [stroke.specialList objectAtIndex:i];
        nextSpecialPointId = [stroke.specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        GCGraphicUnit* unitTempAfterRecognize = [stroke recognize:temp];
        if(unitTempAfterRecognize != NULL)
        {
            [stroke.gList addObject:unitTempAfterRecognize];
        }
        else
        {
            //[temp release];
            return NO;
        }
        //[temp release];
    }
    if([stroke.gList count]==4)
    {
        int tag=0;
        GCGraphicUnit *unit;
        for(int i=0;i<4;i++)
        {
            unit = [stroke.gList objectAtIndex:i];
            if(unit.type==1)
            {
                tag++;
            }
        }
        
        GCPoint *startSpecialPoint;
        GCPoint *endSpecialPoint;
        NSNumber *startSpecialPointId;
        NSNumber *endSpecialPointId;
        startSpecialPointId = [stroke.specialList objectAtIndex:0];
        endSpecialPointId = [stroke.specialList objectAtIndex:4];
        startSpecialPoint = [pList objectAtIndex:[startSpecialPointId intValue]];
        endSpecialPoint = [pList objectAtIndex:[endSpecialPointId intValue]];
        if ((tag==4) && [Threshold Distance:startSpecialPoint :endSpecialPoint] < is_closed) {
            return true;
        }
        else return false;
    }
    else return false;
}

-(BOOL)rebuild_hybridunit:(Stroke *)stroke
{
    [stroke.gList removeAllObjects];
    NSNumber *specialPointId;
    NSNumber *nextSpecialPointId;
    bool isHybirdUnit = YES;
    
    for (int i=0;i<[stroke.specialList count]-1;i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc]init];//temp 为 临 时 存 放 某 个 图 元 的 所 有 点 的 数 组
        specialPointId = [stroke.specialList objectAtIndex:i];
        nextSpecialPointId = [stroke.specialList objectAtIndex:i+1];
        for(int j=[specialPointId intValue];j<[nextSpecialPointId intValue];j++)
        {
            [temp addObject:[pList objectAtIndex:j]];
        }
        GCGraphicUnit* unitTempAfterRecognize = [stroke recognize:temp];
        if(unitTempAfterRecognize != NULL || unitTempAfterRecognize.type == 2 || unitTempAfterRecognize.type == 3)
        {
            [stroke.gList addObject:unitTempAfterRecognize];
        }
        else
        {
            //[temp release];
            isHybirdUnit = NO;
            break;
        }
        //[temp release];
    }
    
    if(isHybirdUnit)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

-(GCGraph *) create_Line_Graph:(Stroke *)stroke
                              :(NSMutableArray *)unitList
                              :(NSMutableArray*) pointGraphList
{
    GCLineUnit *tempunit;
    tempunit = [unitList objectAtIndex:0];
    GCGraph* graph=[[GCLineGraph alloc] initWithLine:tempunit andId:graph_id];
    graph_id++;
    return graph;
}
-(GCGraph *) create_Triangle_Graph:(Stroke *)stroke
                                  :(NSMutableArray *)unitList
                                  :(NSMutableArray *)pointGraphList
{
    GCGraphicUnit *tempunit;
    for(int i=0;i<[stroke.specialList count]-1;i++)
    {
        tempunit = [stroke.gList objectAtIndex:i];
        [unitList addObject:tempunit];
    }
    GCLineUnit *lineUnit0;
    GCLineUnit *lineUnit1;
    GCLineUnit *lineUnit2;
    lineUnit0 = [stroke.gList objectAtIndex:0];
    lineUnit1 = [stroke.gList objectAtIndex:1];
    lineUnit2 = [stroke.gList objectAtIndex:2];
    
    GCPoint* vertex0 =  lineUnit0.start;
    GCPoint* vertex1 =  lineUnit1.start;
    GCPoint* vertex2 =  lineUnit2.start;
    
    GCGraph *graph = [[GCTriangleGraph alloc] initWithLine0:lineUnit0 Line1:lineUnit1 Line2:lineUnit2 Id:graph_id Vertex0:vertex0 Vertex1:vertex1 Vertex2:vertex2];
    graph_id++;
    
    for(int i=0; i<3; i++)
    {
        GCTriangleGraph* tempTriangle = (GCTriangleGraph*)graph;
        GCPointGraph* tempPoint = [Threshold createNewPoint:[tempTriangle.triangleVertexes objectAtIndex:i]];
        [pointGraphList addObject:tempPoint];
        tempPoint.belong_to_triangle = YES;
        
        if(i == 0)
            [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex0_Of_Triangle Graph2:graph Type2:Vertex0_Of_Triangle];
        else if(i == 1)
            [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex1_Of_Triangle Graph2:graph Type2:Vertex1_Of_Triangle];
        else if(i == 2)
            [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex2_Of_Triangle Graph2:graph Type2:Vertex2_Of_Triangle];
    }
    
    return graph;
}
-(GCGraph*) create_Rectangle_Graph:(Stroke*)stroke
                                  :(NSMutableArray*)unitList
                                  :(NSMutableArray*)pointList
{
    GCGraph* graph;
    
    GCLineUnit* lineUnit0;
    GCLineUnit* lineUnit1;
    GCLineUnit* lineUnit2;
    GCLineUnit* lineUnit3;
    lineUnit0 = [stroke.gList objectAtIndex:0];
    lineUnit1 = [stroke.gList objectAtIndex:1];
    lineUnit2 = [stroke.gList objectAtIndex:2];
    lineUnit3 = [stroke.gList objectAtIndex:3];
    
    graph = [[GCRectangleGraph alloc]initWithLine0:lineUnit0 Line1:lineUnit1 Line2:lineUnit2 Line3:lineUnit3 Id:graph_id];
    graph_id++;
    
    for(int i=0; i<4; i++)
    {
        GCRectangleGraph* tempRect = (GCRectangleGraph*)graph;
        GCPointGraph* tempPoint = [Threshold createNewPoint:[tempRect.rec_vertexes objectAtIndex:i]];
        [pointList addObject:tempPoint];
        tempPoint.belong_to_rectangle = YES;
        
        switch(i)
        {
            case 1:
                [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex0_Of_Rectangle Graph2:graph Type2:Vertex0_Of_Rectangle];
                break;
            case 2:
                [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex1_Of_Rectangle Graph2:graph Type2:Vertex1_Of_Rectangle];
                break;
            case 3:
                [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex2_Of_Rectangle Graph2:graph Type2:Vertex2_Of_Rectangle];
                break;
            case 4:
                [tempPoint constructConstraintGraph1:(GCGraph*)tempPoint Type1:Vertex3_Of_Rectangle Graph2:graph Type2:Vertex3_Of_Rectangle];
                break;
        }
    }
    
    return graph;
}

@end
