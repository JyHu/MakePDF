//
//  HJYMakePdf.m
//  MakePdfFile
//
//  Created by JyHu on 14-5-4.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import "HJYMakePdf.h"
#import <CoreText/CoreText.h>

#define maxOfHorizontalForms    19
#define maxOfVerticalForms      43
#define labelTag                8
#define daySeconds              ((NSTimeInterval)(24 * 60 * 60))


@interface HJYMakePdf()

/**
 *  four direction size of form
 *
 *  @since <#version number#>
 */
@property (assign, nonatomic) UIEdgeInsets formSets;

/**
 *  label font size
 *
 *  @since <#version number#>
 */
@property (retain, nonatomic) UIFont *labelFont;

/**
 *  form circle begin date
 *
 *  @since <#version number#>
 */
@property (retain, nonatomic) NSDate *circleBeginDate;

/**
 *  form lines color
 *
 *  @since <#version number#>
 */
@property (retain, nonatomic) UIColor *formColor;

/**
 *  all label's text color
 *
 *  @since <#version number#>
 */
@property (retain, nonatomic) UIColor *labelColor;

/**
 *  every member must be NSValue type
 *
 *  @since <#version number#>
 */
@property (retain, nonatomic) NSArray *circleTempsArr;

@property (assign, nonatomic) CGFloat perFormHeight;

@property (retain, nonatomic) UILabel *monthLabel;

@end


@implementation HJYMakePdf

@synthesize monthLabel      = _monthLabel;

@synthesize perFormHeight   = _perFormHeight;

@synthesize formSets        = _formSets;

@synthesize labelFont       = _labelFont;

@synthesize circleBeginDate = _circleBeginDate;

@synthesize circleTempsArr  = _circleTempsArr;

@synthesize formColor       = _formColor;

@synthesize labelColor      = _labelColor;

- (id)init
{
    self = [super init];
    if (self) {
        _perFormHeight = 612 / 43.0;
        _formSets = UIEdgeInsetsMake(100, 44, 44, 44);
        _labelFont = [UIFont systemFontOfSize:12];
        _formColor = [UIColor redColor];
        _labelColor = [UIColor blackColor];
        _circleBeginDate = [[NSDate date] dateByAddingTimeInterval:(-1 * daySeconds * 30)];
    }
    return self;
}

- (void)makePdf:(NSString *)fileName andDatas:(NSArray *)datas
{
    UIGraphicsBeginPDFContextToFile(fileName, CGRectZero, nil);
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
    
//    [self drawForm];
    
    UIGraphicsEndPDFContext();
}

- (void)drawForm
{
    CGFloat xOrigin = 0;
    CGFloat yOrigin = 0;
    CGFloat lineWidth = 0;
    CGFloat lineHeight = 0;
    
    [_formColor set];
    
    lineWidth = _perFormHeight * (maxOfVerticalForms + 2);
    
    for (int i=0; i <= maxOfHorizontalForms; i++) {
        xOrigin = 0;
        yOrigin = i * _perFormHeight;
        
        if (i >= 4 && i < maxOfHorizontalForms - 1) {
            xOrigin = 3 * _perFormHeight;
        }
        else
        {
            xOrigin = 0;
        }
        if (i == maxOfHorizontalForms ) {
            yOrigin = (maxOfHorizontalForms + 3) * _perFormHeight;
        }
        [self drawLineFrom:CGPointMake(xOrigin + _formSets.left, yOrigin + _formSets.top) to:CGPointMake(lineWidth + _formSets.left, yOrigin + _formSets.top)];
    }
    
    xOrigin = 0;
    yOrigin = 0;
    lineHeight = (maxOfHorizontalForms + 3) *_perFormHeight;
    
    for (int j=0; j<= maxOfVerticalForms; j++) {
        if (j == 1) {
            xOrigin += 2 * _perFormHeight;
        }
        if (j > 1 && j < maxOfVerticalForms) {
            yOrigin = _perFormHeight;
            lineHeight = (maxOfHorizontalForms - 2) * _perFormHeight;
        }
        if (j == maxOfVerticalForms) {
            yOrigin = 0;
            lineHeight = (maxOfHorizontalForms + 3) * _perFormHeight;
        }
        
        [self drawLineFrom:CGPointMake(xOrigin + _formSets.left, yOrigin + _formSets.top) to:CGPointMake(xOrigin + _formSets.left, yOrigin + lineHeight + _formSets.top)];
        xOrigin += _perFormHeight;
    }
}


-(void)drawLineFrom:(CGPoint)startPoint
                 to:(CGPoint)endPoint
{
    CGContextRef     context = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x,endPoint.y);
    CGContextSetLineWidth(context, 1);
    
    CGContextStrokePath(context);
}

@end



@implementation NSDate(myDateCount)

- (NSInteger)daysOfMonth
{
    NSCalendar *currentCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange dateRange = [currentCalendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];            //时间range
    
    return dateRange.length;
}

- (NSInteger)day
{
    return [[self components] day];
}

- (NSDateComponents *)components
{
    NSCalendar *curCalen = [NSCalendar currentCalendar];
    NSInteger unitFlag = NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents *dateComp = [curCalen components:unitFlag fromDate:self];
    
    return dateComp;
}

- (NSInteger)month
{
    return [[self components] month];
}

- (NSInteger)year
{
    return [[self components] year];
}

- (NSInteger)daysOfNextMonth
{
    NSDate *date = [self dateByAddingTimeInterval:[self daysOfMonth] * daySeconds];
    return [date daysOfMonth];
}

@end