//
//  LSSleepStatus.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSSleepItem : NSObject
@property(nonatomic) int value;
@property(nonatomic) long long utc;
@property(nonatomic,strong) NSDate*date;

@end

NS_ASSUME_NONNULL_END
