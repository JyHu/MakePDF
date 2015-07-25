//
//  MakePdfFile.h
//  MakePdfFile
//
//  Created by JyHu on 14-5-4.
//  Copyright (c) 2014年 JyHu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MakePdfFile : NSObject

+ (void)drawPDFWithIndex:(NSInteger)index;

+ (void)drawPDFWithDate:(NSDate *)date;

@end
