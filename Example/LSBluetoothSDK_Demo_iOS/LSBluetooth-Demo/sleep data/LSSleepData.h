//
//  LSSleepData.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>

@interface LSSleepData : NSObject
@property(nonatomic,strong) NSString *deviceMac;
@property(nonatomic,assign) long utc;
@property(nonatomic,assign) int timeOffset;
@property(nonatomic,strong) NSString *srcData;
@property(nonatomic,strong) NSArray<NSNumber *> *status;


-(instancetype)initWithData:(LSUSleepData *)data;

@end

