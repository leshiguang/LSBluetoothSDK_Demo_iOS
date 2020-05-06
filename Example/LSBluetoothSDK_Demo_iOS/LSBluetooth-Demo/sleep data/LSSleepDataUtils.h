//
//  LSSleepDataUtils.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSleepItem.h"
#import "LSSleepData.h"
#import "LSDaySleepStatus.h"
#import "LSTimeUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSSleepDataUtils : NSObject

//格式化睡眠状态数据
+(NSString *)formatSleepStatus:(NSArray<NSNumber *> *)status;

//将睡眠数据转换成状态列表
+(NSArray <LSSleepItem *>*)toSleepStatus:(LSSleepData *)data;

//将睡眠状态列表按天统计
+(NSArray <LSDaySleepStatus *> *)toDaySleepStatus:(NSArray <LSSleepItem *> *)sleepItems;

@end

NS_ASSUME_NONNULL_END
