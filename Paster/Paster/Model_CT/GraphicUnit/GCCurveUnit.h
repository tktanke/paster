//
//  GCCurveUnit.h
//  GCDrawing
//
//  Created by 老逸 on 13-6-2.
//  Copyright (c) 2013年 QFire. All rights reserved.
//

#import "GCGraphicUnit.h"
#import "GCPoint.h"
#import "Threshold.h"

@interface GCCurveUnit : GCGraphicUnit
{
    float aFactor,bFactor,cFactor,dFactor,eFactor,fFactor;
    //为二次曲线的标准最简式：a*x^2 + b*xy + c*y^2 + d*x + e*y + f = 0 的系数
    
    GCPoint* center;                //中心坐标
    GCPoint* move;                  //移动向量坐标
    GCPoint* f1;                    //焦点
    GCPoint* f2;
    
    float alpha;
    float majorAxis,minorAxis;      //长轴，短轴；major_axis是x方向上的轴长，minor_axis是y方向上的轴长
    
    float originalAlpha;
    float originalMajor,originalMinor;
    
    float startAngle,endAngle;      //画弧线时的起始角和终止角（并非是起始点，终点和原点的连线与坐标轴的夹角）在画二次曲线时有作用
    
    bool isAntiClockCurve;          //表示这段曲线为逆时针曲线
    bool isEllipse;                 //椭圆为yes,圆形为no
    bool isHalfCurve;               //如果是半个以上的二次弧线则为yes，默认值为no
    bool isCompleteCurve;           //是圆满的圆形和椭圆形为yes
    bool hasSecondJudge;
    int curveType;                  //曲线的类型
    
    //判断哪个轴递增或者递减
    bool isXIncrease;
    bool isXDecrease;
    bool isYIncrease;
    bool isYDecrease;
    
    GCPoint* testS;
    GCPoint* testE;
    
    NSMutableArray* curveTrack;             //曲线原始轨迹
    NSMutableArray* nowDrawPointList;       //用于绘画的曲线轨迹
    NSMutableArray* nowSpecialPointList;
    
    //圆弧混合拟合
    NSMutableArray* arcIndexArray;
    NSMutableArray* arcUnitArray;
    NSMutableArray* arcBoolArray;
    bool isArcGroup;
    bool isSplineGroup;
}

@property (readwrite) float aFactor;
@property (readwrite) float bFactor;
@property (readwrite) float cFactor;
@property (readwrite) float dFactor;
@property (readwrite) float eFactor;
@property (readwrite) float fFactor;
@property (readwrite) float alpha;
@property (readwrite) float majorAxis;
@property (readwrite) float minorAxis;
@property (readwrite) float originalAlpha;
@property (readwrite) float originalMajor;
@property (readwrite) float originalMinor;
@property (readwrite) float startAngle;
@property (readwrite) float endAngle;
@property (readwrite) bool  isAntiClockCurve;
@property (readwrite) bool  isEllipse;
@property (readwrite) bool  isHalfCurve;
@property (readwrite) bool  isCompleteCurve;
@property (readwrite) bool  isArcGroup;
@property (readwrite) bool  isSplineGroup;
@property (readwrite) bool  hasSecondJudge;
@property (readwrite) bool  isXIncrease;
@property (readwrite) bool  isXDecrease;
@property (readwrite) bool  isYIncrease;
@property (readwrite) bool  isYDecrease;
@property (readwrite) int   curveType;

@property (retain) GCPoint* center;
@property (retain) GCPoint* move;
@property (retain) GCPoint* f1;
@property (retain) GCPoint* f2;
@property (retain) GCPoint* testS;
@property (retain) GCPoint* testE;
@property (retain) NSMutableArray* curveTrack;
@property (retain) NSMutableArray* nowDrawPointList;
@property (retain) NSMutableArray* nowSpecialPointList;
@property (retain) NSMutableArray* arcIndexArray;
@property (retain) NSMutableArray* arcUnitArray;
@property (retain) NSMutableArray* artBoolArray;

//构造函数
-(id)initWithSPoint:(GCPoint*)startPoint EPoint:(GCPoint*)endPoint;
-(id)initWithAFactor:(float)a BFactor:(float)b CFactor:(float)c DFactor:(float)d EFactor:(float)e FFactor:(float)f;
-(id)initWithPointArray:(NSMutableArray*)pointList ID:(int)idNum;       //有整个曲线识别流程操作，h可以为任意的整形值
-(id)initWithPointArray:(NSMutableArray *)pointList;                    //只有identity的操作，并未判断是否为二次曲线和标准化

//进行三次样条插值的计算
-(NSMutableArray*)calculateCubicNewDrawPointList:(NSMutableArray*)newPointList;
-(void)calculateCubicSplineWithPointList:(NSMutableArray*)pointList;
-(NSMutableArray*)findSpecialPointWithPointList:(NSMutableArray*)pointListTemp;

//重新计算椭圆的轨迹
//-(void)recalculateSecCurveTrackWithPointList:(NSMutableArray*)pointList;
//-(void)recalculateDrawSecCurveTrack:(NSMutableArray*)pointList;
//-(GCPoint*)recalculateNewPointWithTempPoint:(GCPoint*)tempPoint LastPoint:(GCPoint*)lastPoint;
//-(NSMutableArray*)findCalculatePoints:(NSMutableArray*)pointList;

//计算画新椭圆曲线的轨迹
-(void)calculateNewDrawSecCurveTrack;

//采用高斯消元法，识别曲线
-(void)identifyWithPointArray:(NSMutableArray*)pointList XArray:(float[6])xArray;

//如果是二次曲线返回yes，如果非二次曲线返回no
-(Boolean)isSecondDegreeCurveWithPointArray:(NSMutableArray*)pointList;

//将二次曲线化为标准的最简式
-(void)convertToStandardCurve;

//高斯消元法函数
-(void)gaussianEliminationWithRow:(int)row Column:(int)col Matrix:(float[5][6])matrix Answer:(float[5])answer;

//判断是何种二次曲线
-(void)judgeCurveWithPointArray:(NSMutableArray*)pointList;

//计算出两点间的距离
-(float)calculateDistanceWithPoint1:(GCPoint*)point1 Point2:(GCPoint*)point2;

//使得从开始点到终止点为逆时针
-(void)setStartTOEndAntiClockWithPointArray:(NSMutableArray*)pointList;

//计算出起始角和终止角
-(void)calculateStartAndEndAngle;
-(void)calculateStartAndEndAngleWithStartAngle:(float)startAngle EndAngle:(float)endAngle;
-(void)calculateStartAndEndAngleWithStartPoint:(GCPoint*)startPoint EndPoint:(GCPoint*)endPoint StartAngle:(float)startAngleLocal EndAngle:(float)endAngleLocal;
-(float)calculateAngleWithPoint1:(GCPoint*)point1 Point2:(GCPoint*)point2 Center:(GCPoint*)centerPoint PosOrNeg:(float*)isPosOrNeg;

-(void)secondJudgeIsCompleteCurveWithPointArray:(NSMutableArray*)pointList;

//绘画
-(void)drawWithContext:(CGContextRef)context;
-(void)drawEllipseWithLastCurve:(GCCurveUnit*)lastCurve Context:(CGContextRef)context;
-(void)drawEllipseArcWithContext:(CGContextRef)context;
-(void)drawCircleArcWithContext:(CGContextRef)context;
-(void)drawHyperbolicWithContext:(CGContextRef)context;
-(void)drawPathWithContext:(CGContextRef)context;
-(void)drawCubicSplineWithPointList:(NSMutableArray*)pointList Context:(CGContextRef)context;

-(void)setCenterWithX:(float)x Y:(float)y;
-(void)setRadiusWithR:(float)r;
-(void)setOriginalAlpha;
-(void)setOriginalMajorAndOriginalMinor;
-(void)setCompletCurve;

//计算曲线的起点和终点
-(void)calculateStartPointAndEndPoint;

//旋转平移操作
-(void)translateAndRotationWithX:(float*)x Y:(float*)y Theta:(float)theta Point:(GCPoint*)vector;
-(GCPoint*)translateAndRotationWithPoint:(GCPoint*)tempPoint Theta:(float)theta Point:(GCPoint*)vector;
-(GCPoint*)rotationWithPoint:(GCPoint*)tempPoint Theta:(float)theta;
-(GCPoint*)translateWithPoint:(GCPoint*)tempPoint Vector:(GCPoint*)vector;
-(void)antiTranslateWithX:(float*)x WithY:(float*)y Theta:(float)theta Point:(GCPoint*)vector;
-(GCPoint*)antiTranslateWith:(GCPoint*)tempPoint Theta:(float)theta Point:(GCPoint*)vector;

-(void)rotationWithPoint:(GCPoint*)tempPoint Theta:(float)theta BasePoint:(GCPoint*)basePoint;
-(GCPoint*)scaleWithPoint:(GCPoint*)tempPoint ScaleFactor:(GCPoint*)scaleFactor BasePoint:(GCPoint*)basePoint;

@end
