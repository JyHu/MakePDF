//
//  HJYMakePdf.h
//  MakePdfFile
//
//  Created by JyHu on 14-5-4.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HJYMakePdf : NSObject

- (void)makePdf:(NSString *)fileName andDatas:(NSArray *)datas;

@end



@interface  NSDate (myDateCount)

- (NSInteger)daysOfMonth;

- (NSInteger)day;

- (NSInteger)month;

- (NSInteger)year;

- (NSInteger)daysOfNextMonth;

@end