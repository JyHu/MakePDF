//
//  MakePdfFile.m
//  MakePdfFile
//
//  Created by JyHu on 14-5-4.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import "MakePdfFile.h"
#import <CoreText/CoreText.h>

#pragma mark - some gloable size

#define margin          44          //
#define perlength       ((612 - 44 * 4) / 43.0) // the height of every rect of trend form
#define pdfWidth        612     // the width of every pdf page , standard width
#define pdfHeight       792     // the height of every pdf page , standard height
#define maxTemp         37.5    // the max tempreture
#define maxVer          43      // vertical lines for every trend form
#define maxHor          20      // horizontal lines for every trend form
#define formSides       120     // the distance of two form in one pdf page
#define daySenconds     (24 * 60 * 60)
#define pdfFileName     @"user.pdf"

#pragma mark - gloable method

#define mRGBA(R,G,B,A)  ((UIColor *)[UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)])

#pragma mark - elements colors

#define formLineColor               mRGBA(72, 131, 30, 0.5)    // 折线图表格线条颜色
#define detailFormWeakColor         mRGBA(139, 196, 237, 0.2)  // 统计信息框淡色  // mRGBA(153, 204, 76.5, 0.1)
#define detailFormStrongColor       mRGBA(139, 196, 237, 0.5)  // 统计信息框重色
#define detailFormTextColor         mRGBA(100, 100, 100, 1)   // 统计信息文字颜色
#define trendFormTitleColor         mRGBA(128, 128, 128, 1)     // 图1、图2 ……
#define trendFormLogoColor          mRGBA(223, 125, 47, 1)      // JyHu（折线图右上角）
#define trendFormOriginColor        mRGBA(36, 120, 200, 1)      // 折线图圆点颜色
#define trendGroupBackGroundColor   mRGBA(240, 240, 240, 1)  // 折线图背景框颜色
#define userSummaryInfoColor        mRGBA(120, 120, 100, 1)     // 用户信息文字颜色
#define trendLineColor              mRGBA(0, 100, 150, 1)     // 折线颜色
#define trendWordsColrd             mRGBA(80, 80, 80, 0.7)     // 折线图文字颜色

static int      count = 0;          // which form
static float    topHeight = 450;    //
static int      pages = 1;          // pdf pages

@implementation MakePdfFile

//*************************************************************************************//
//*************************************************************************************//

#pragma mark - start drawing ,the most important method

/**
 *  begin a pdf drawing
 *
 *  @param fileName fileName description
 */

+ (void)drawPDFWithIndex:(NSInteger)index
{
    NSString *pathStr = [self getPDFFileName];
    
    count = 0;
    pages = 1;
    topHeight = 450;
    
    /**
     *  draw pdf begin here
     */
    UIGraphicsBeginPDFContextToFile(pathStr, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfWidth, pdfHeight), nil);
    
    [self drawPDFHeader:[NSDate date] and:[[NSDate date] dateByAddingTimeInterval:10000]];
    
    [self drawPDFInfo:7 and:28];
    
    NSArray *Arr = [NSArray arrayWithObjects:
                    @[@"1", @"2013.3.4-2013.4.1", @"3", @"0", @"5", @"3", @"2", @"表1"],
                    @[@"2", @"2013.3.4-2013.4.1", @"3", @"0", @"5", @"3", @"2", @"表2"],
                    @[@"3", @"2013.3.4-2013.4.1", @"3", @"0", @"5", @"3", @"2", @"表3"],
                    @[@"5", @"2013.3.4-2013.4.1", @"3", @"0", @"5", @"3", @"2", @"表5"],
                    @[@"6", @"2013.3.4-2013.4.1", @"3", @"0", @"5", @"3", @"2", @"表6"], nil];
    [self drawPDFDetail:Arr];
    
    topHeight = 230 + 35 * Arr.count;
    
    for (int i=0; i<Arr.count; i++)
    {
        [self drawPDFFormWithBeginIndex:-1];
    }
    
    UIGraphicsEndPDFContext();
    
}

+ (void)drawPDFWithDate:(NSDate *)date
{
    [MakePdfFile drawPDFFormWithBeginIndex:-1];
}

//*************************************************************************************//
//*************************************************************************************//

#pragma mark - context algorithm

/**
 *  draw pdf header
 *
 *  @param beginDate beginDate description
 *  @param endDate   endDate description
 */
+ (void)drawPDFHeader:(NSDate *)beginDate and:(NSDate *)endDate
{
    CGFloat topCap = 10;
    UIImage *img = [UIImage imageNamed:@"bizcard_logo"];
    [img drawInRect:CGRectMake(margin, topCap, (75 - topCap * 2) * img.size.width / img.size.height, (75 - topCap * 2))];
    [MakePdfFile drawLineFromPoint:CGPointMake(margin, 75) toPoint:CGPointMake(pdfWidth - margin, 75) withColor:mRGBA(0, 0, 0, 1)];
    NSString *title = [NSString stringWithFormat:@"周期起止时间 %@ to %@",[MakePdfFile cutDate:beginDate],[MakePdfFile cutDate:endDate]];
    [title drawAtPoint:CGPointMake(350, 40) withAttributes:nil];
}



/**
 *  draw user data
 *
 *  @param avgPeriodDays <#avgPeriodDays description#>
 *  @param avgCycleDays  <#avgCycleDays description#>
 */
+ (void)drawPDFInfo:(NSInteger)avgPeriodDays and:(NSInteger)avgCycleDays
{
    CGFloat height = 85;
    NSDictionary *fontDict = @{
                               NSForegroundColorAttributeName: userSummaryInfoColor
                               };
    
    [@"邮箱:"              drawAtPoint:CGPointMake(margin * 2, height) withAttributes:fontDict];
    [@"aug_88@163.com"    drawAtPoint:CGPointMake(margin * 2 + 40, height) withAttributes:fontDict];
    [@"年龄"               drawAtPoint:CGPointMake(margin * 2 , height + 30) withAttributes:fontDict];
    [@"23"                drawAtPoint:CGPointMake(margin * 2 + 40, height + 30) withAttributes:fontDict];
    
    [@"平均经期长度: "       drawAtPoint:CGPointMake(400, height) withAttributes:fontDict];
    [[NSString stringWithFormat:@"%ld",avgPeriodDays] drawAtPoint:CGPointMake(485, height) withAttributes:fontDict];
    [@"平均周期长度: "       drawAtPoint:CGPointMake(400, height + 30) withAttributes:fontDict];
    [[NSString stringWithFormat:@"%ld",avgCycleDays] drawAtPoint:CGPointMake(485, height + 30) withAttributes:fontDict];
}


/**
 *  draw pdf user detail form
 */
+ (void)drawPDFDetail:(NSArray *)allDatasArr
{
    CGFloat topheight = 140;        // the discance of form title to the pdf header
    CGFloat leftWidth = margin;
    CGFloat perHeight = 35;         //
    
    NSArray *formTitleArr = @[@"编号", @"周期", @"同房", @"失眠", @"吃药", @"生病", @"喝酒", @"表格"]; // form title
    
    float cWidth[8] = {10, 70, 15, 15, 15, 15, 15, 15}; //make the key words alignment center
    float dWidth[8] = {18, 30, 25, 25, 25, 25, 25, 20};
    float width[8] = {40,160,54,54,54,54,54,54};        // every vertical item width
    for (int i=0; i<8; i++)
    {
        
        CGRect frame = CGRectMake(leftWidth, topheight, width[i], perHeight * (allDatasArr.count + 1));
        [MakePdfFile drawRectangle:frame pathDrawingMode:kCGPathFill color:(i%2 == 1 ?
                                                                            detailFormWeakColor :
                                                                            detailFormStrongColor)];
        
        NSString *drawTitle = nil;
        CGPoint drawPoint = CGPointZero;
        
        for (int k=0; k<allDatasArr.count + 1; k++)
        {
            if (k == 0)
            {
                drawPoint = CGPointMake(leftWidth + cWidth[i], topheight + 10);
                drawTitle = formTitleArr[i];
            }
            else
            {
                drawPoint = CGPointMake(leftWidth + dWidth[i], topheight + 10 + perHeight * k);
                drawTitle = [[allDatasArr objectAtIndex:(k-1)] objectAtIndex:i];
            }
            [drawTitle drawAtPoint:drawPoint withAttributes:@{
                                                              NSForegroundColorAttributeName: detailFormTextColor
                                                              }];
        }
        
        leftWidth += width[i];
    }
    
    for (int j=0; j<allDatasArr.count + 1; j++)
    {
        // draw at broken line point
        CGRect frame = CGRectMake(margin, topheight + perHeight * j, pdfWidth - margin * 2, perHeight);
        [MakePdfFile drawRectangle:frame pathDrawingMode:kCGPathFill color:(j % 2 == 1 ?
                                                                            detailFormWeakColor :
                                                                            detailFormStrongColor)];
    }
    
    leftWidth = margin;
    for (int i=0; i<8; i++)
    {
        
        NSString *drawTitle = nil;
        CGPoint drawPoint = CGPointZero;
        
        for (int k=0; k<allDatasArr.count + 1; k++)
        {
            if (k == 0)
            {
                drawPoint = CGPointMake(leftWidth + cWidth[i], topheight + 10);
                drawTitle = formTitleArr[i];
            }
            else
            {
                drawPoint = CGPointMake(leftWidth + dWidth[i], topheight + 10 + perHeight * k);
                drawTitle = [[allDatasArr objectAtIndex:(k-1)] objectAtIndex:i];
            }
            [drawTitle drawAtPoint:drawPoint withAttributes:@{
                                                              NSForegroundColorAttributeName: detailFormTextColor
                                                              }];
        }
        
        leftWidth += width[i];
    }
}


/**
 *  draw trend form
 *
 *  @param beginIndex <#beginIndex description#>
 */
+ (void)drawPDFFormWithBeginIndex:(NSInteger)beginIndex
{
//    if ((pages == 1 && count >= 1) || (pages > 1 && count >= 2))
//    {
//        // reset count methods and start a new pdf page
//        pages ++;
//        count = 0;
//        UIGraphicsBeginPDFPage();
//        topHeight = 150;
//        [self drawPDFHeader:[NSDate date] and:[[NSDate date] dateByAddingTimeInterval:200000]];
//    }
    if (topHeight  + perlength * 20 + margin > pdfHeight) {
        UIGraphicsBeginPDFPage();
        pages ++;
        topHeight = 150;
        [self drawPDFHeader:[NSDate date] and:[[NSDate date] dateByAddingTimeInterval:200000]];
    }
    
//    CGFloat currentFormToTop = topHeight + perlength * 20 * count + formSides * count;
    
    NSDate *beginDate = [[NSDate date] dateByAddingTimeInterval:-100000];
    
    NSDictionary *fontDict = @{
                               NSFontAttributeName: [UIFont systemFontOfSize:8],
                               NSForegroundColorAttributeName: trendWordsColrd
                               };
    

    
    /**
     *  background shadow frame
     *
     *  @param margin margin description
     *
     *  @return return value description
     */
    [self drawRectangle:CGRectMake(margin,
                                   topHeight - margin,
                                   pdfWidth - margin * 2,
                                   perlength * 18 + margin * 2)
                pathDrawingMode:kCGPathFill
                color:trendGroupBackGroundColor];
    
    // coordinate system origin y
    CGFloat yOrigin = 0;

    //
    NSMutableArray *trendLinePointArr = [[NSMutableArray alloc] init];
    
    /**
     *  draw lines
     */
    for (int j=0; j<=maxHor; j++)
    {
        CGPoint fPoint = CGPointMake(margin * 2 + perlength,
                                     topHeight + perlength * j);
        
        CGPoint tPoint = CGPointMake(margin * 2 + perlength * 44,
                                     topHeight + perlength * j);
        
        [MakePdfFile drawLineFromPoint:fPoint toPoint:tPoint withColor:formLineColor];
        
        if (j == maxHor)
        {
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",[MakePdfFile month:beginDate]];
            [monthStr drawAtPoint:CGPointMake(fPoint.x - perlength * 2, tPoint.y) withAttributes:fontDict];
            
            yOrigin = fPoint.y;
            
            continue;
        }
        
        /**
         *  draw temp
         *
         *  @return <#return value description#>
         */
        [[NSString stringWithFormat:@"%.1f",maxTemp - j / 10.0]
         drawAtPoint:CGPointMake(fPoint.x - perlength * 2, fPoint.y - perlength / 2.0) withAttributes:fontDict];
    }
    CGPoint lastBrokenPoint = CGPointZero;
    for (int i = 0; i<=maxVer; i++)
    {
        CGPoint fPoint = CGPointMake(margin * 2 + perlength * (i + 1),
                                     topHeight);
        
        CGPoint tPoint = CGPointMake(margin * 2 + perlength * (i + 1),
                                     topHeight + perlength * 20);
        
        [MakePdfFile drawLineFromPoint:fPoint toPoint:tPoint withColor:formLineColor];
        
        if (i == maxVer)    continue;
        
        /**
         *  draw day index
         *
         *  @return return value description
         */
        [[NSString stringWithFormat:@"%d",i+1] drawAtPoint:CGPointMake(fPoint.x, tPoint.y - perlength)
                                            withAttributes:fontDict];
        
        
        /**
         *  draw days
         */
        NSInteger dayInt = [MakePdfFile day:[beginDate dateByAddingTimeInterval:daySenconds * i]];
        
        [[NSString stringWithFormat:@"%ld",dayInt] drawAtPoint:CGPointMake(fPoint.x, tPoint.y) withAttributes:fontDict];
        
        
        /**
         *  add broken line points
         *
         *  @return <#return value description#>
         */
        
        CGPoint pt = CGPointMake(fPoint.x + perlength / 2.0, yOrigin - (35 + arc4random()%300/100.0 - (maxTemp - maxHor / 10.0)) * perlength * 10);
        
        
        [trendLinePointArr addObject:[NSValue valueWithCGPoint:pt]];
        
        lastBrokenPoint = pt;
    }
    
    // draw broken line
    [MakePdfFile drawLines:trendLinePointArr];
    
    //
    for (NSValue *value in trendLinePointArr)
    {
        [MakePdfFile drawCircleWithCenter:value radius:2];
    }
    
    // page number
    [[NSString stringWithFormat:@"- %d -",pages] drawAtPoint:CGPointMake(pdfWidth / 2.0 - 10, pdfHeight - 40) withAttributes:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [@"JyHu" drawAtPoint:CGPointMake(margin * 2, topHeight - 35)
        withAttributes:@{
                         NSFontAttributeName: [UIFont systemFontOfSize:20],
                         NSParagraphStyleAttributeName:paragraphStyle,
                         NSForegroundColorAttributeName:trendFormLogoColor
                         }];
    [[NSString stringWithFormat:@"图 %d",count + 1]
     drawAtPoint:CGPointMake(pdfWidth / 2.0 - perlength, topHeight - perlength * 3)
     withAttributes:@{
                      NSFontAttributeName: [UIFont systemFontOfSize:12],
                      NSParagraphStyleAttributeName:paragraphStyle,
                      NSForegroundColorAttributeName:trendFormTitleColor
                      }];
    
    count ++;
    
    topHeight += perlength * 20 + formSides;
}


//*************************************************************************************//

//*************************************************************************************//

#pragma mark - context methods

+ (void)drawLines:(NSArray *)pointArray
{
    NSAssert(pointArray.count>=2,@"数组长度必须大于等于2");
    NSAssert([[pointArray[0] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
    
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    [trendLineColor set];
    
    NSValue *startPointValue = pointArray[0];
    CGPoint  startPoint      = [startPointValue CGPointValue];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    for(int i = 1;i<pointArray.count;i++)
    {
        NSAssert([[pointArray[i] class] isSubclassOfClass:[NSValue class]], @"数组成员必须是CGPoint组成的NSValue");
        NSValue *pointValue = pointArray[i];
        CGPoint  point      = [pointValue CGPointValue];
        CGContextAddLineToPoint(context, point.x,point.y);
    }
    
    CGContextStrokePath(context);
    
}

+ (void)drawCircleWithCenter:(NSValue *)value radius:(float)radius
{
    CGPoint center = [value CGPointValue];
    
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    [trendFormOriginColor set];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    CGPathAddArc(pathRef,
                 &CGAffineTransformIdentity,
                 center.x,
                 center.y,
                 radius,
                 -1 * M_PI,
                 radius * 2 * M_PI-M_PI/2,
                 NO);
    
    CGPathCloseSubpath(pathRef);
    
    CGContextAddPath(context, pathRef);
    
    CGContextDrawPath(context,kCGPathFill);
    
    CGPathRelease(pathRef);
    
}

+ (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to withColor:(UIColor *)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0);
    
    [color set];
    
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);
    
    CGContextStrokePath(context);
}

+ (void)drawRectangle:(CGRect)rect pathDrawingMode:(CGPathDrawingMode)mode color:(UIColor *)color
{
    CGContextRef    context = UIGraphicsGetCurrentContext();
    
    [color set];
    
    CGMutablePathRef pathRef = [self pathwithFrame:rect withRadius:0];
    
    CGContextAddPath(context, pathRef);
    
    CGContextDrawPath(context, mode);
    
    CGPathRelease(pathRef);
}

+ (CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius
{
    CGPoint x1,x2,x3,x4; //x为4个顶点
    CGPoint y1,y2,y3,y4,y5,y6,y7,y8; //y为4个控制点
    //从左上角顶点开始，顺时针旋转,x1->y1->y2->x2
    
    x1 = frame.origin;
    x2 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
    x3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height);
    x4 = CGPointMake(frame.origin.x                 , frame.origin.y+frame.size.height);
    
    
    y1 = CGPointMake(frame.origin.x+radius, frame.origin.y);
    y2 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y);
    y3 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+radius);
    y4 = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y+frame.size.height-radius);
    
    y5 = CGPointMake(frame.origin.x+frame.size.width-radius, frame.origin.y+frame.size.height);
    y6 = CGPointMake(frame.origin.x+radius, frame.origin.y+frame.size.height);
    y7 = CGPointMake(frame.origin.x, frame.origin.y+frame.size.height-radius);
    y8 = CGPointMake(frame.origin.x, frame.origin.y+radius);
    
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    if (radius<=0)
    {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, x1.x,x1.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x,x2.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x,x3.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x,x4.y);
    }
    else
    {
        CGPathMoveToPoint(pathRef,    &CGAffineTransformIdentity, y1.x,y1.y);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y2.x,y2.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x2.x,x2.y,y3.x,y3.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y4.x,y4.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x3.x,x3.y,y5.x,y5.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y6.x,y6.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x4.x,x4.y,y7.x,y7.y,radius);
        
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y8.x,y8.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity,  x1.x,x1.y,y1.x,y1.y,radius);
        
    }
    
    
    CGPathCloseSubpath(pathRef);
    
    return pathRef;
}


//*************************************************************************************//

//*************************************************************************************//

#pragma mark - help methods , about date methods

+ (NSDateComponents *)makeComponents:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit;
    NSDateComponents *comp = [calendar components:unitFlag fromDate:date];
    
    return comp;
}

+ (NSString *)cutDate:(NSDate *)date
{
    NSDateComponents *comp = [MakePdfFile makeComponents:date];
    
    return [NSString stringWithFormat:@"%ld.%ld.%ld",[comp year],[comp month],[comp day]];
}

+ (NSInteger)month:(NSDate *)date
{
    return [[MakePdfFile makeComponents:date] month];
}

+ (NSInteger)day:(NSDate *)date
{
    return [[MakePdfFile makeComponents:date] day];
}

#pragma mark - help methods , get pdf file path

+ (NSString*)getPDFFileName
{
    NSString* fileName = pdfFileName;
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdf = [path stringByAppendingPathComponent:fileName];
    
    NSLog(@"pdf fil path %@",pdf);
    
    return pdf;
    
}

@end
