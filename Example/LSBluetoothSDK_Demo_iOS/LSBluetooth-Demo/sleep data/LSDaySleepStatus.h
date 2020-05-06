//
//  LSDaySleepStatus.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSleepItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSDaySleepStatus : NSObject
@property(nonatomic,strong) NSArray<LSSleepItem *> *datas;
@property(nonatomic,strong) NSDate *dayDate;
@property(nonatomic,assign) long startUtc;
@property(nonatomic,assign) long endUtc;
@property(nonatomic,strong) NSString *hexSleepData;
@end

NS_ASSUME_NONNULL_END
