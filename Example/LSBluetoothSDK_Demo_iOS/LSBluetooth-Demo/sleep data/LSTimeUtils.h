//
//  LSTimeUtils.h
//  TestApplication
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSleepItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSTimeUtils : NSObject

+(NSString *)formatDateWithUTC:(long long)utc timeZone:(NSString *)timeZone;

+(NSString *)formatDateWithUTC:(long long)utc;

+(BOOL)isSameDay:(NSDate *)srcDate other:(NSDate *)desDate;

+(NSArray<NSDate *> *)countSameDay:(NSArray<LSSleepItem *> *)sleepItems;

//
+(NSString *)toDayFormatString:(NSDate *)date;

+(NSString *)toTimeFormatString:(NSDate *)date;

+(long)toUtc:(NSString *)time;

+(NSString *)toTimeString:(long)time;

+(NSString *)countPercent:(long)value forSum:(long)sum;
@end

NS_ASSUME_NONNULL_END
