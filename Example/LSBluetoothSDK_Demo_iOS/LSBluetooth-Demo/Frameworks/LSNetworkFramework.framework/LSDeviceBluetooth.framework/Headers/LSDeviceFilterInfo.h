//
//  LSDeviceFilterInfo.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2017/7/3.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"


@interface LSDeviceFilterInfo : NSObject

@property(nonatomic,strong)NSString *broadcastName;          //广播名
@property(nonatomic,assign)LSBroadcastNameMatchWay matchWay; //匹配方式


-(NSString *)objectIdentity;

@end
