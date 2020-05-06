//
//  LSDeviceData.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/13.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"

@interface LSDeviceData : NSObject

@property(nonatomic,strong)id dataObj;              //设备数据对象
@property(nonatomic,strong)NSData *sourceData;      //原始数据
@property(nonatomic,assign)NSUInteger dataType;     //数据类型

@end
