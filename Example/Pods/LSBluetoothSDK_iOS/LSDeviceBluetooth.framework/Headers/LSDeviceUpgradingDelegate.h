//
//  LSDeviceUpgradingDelegate.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/17.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceInfo.h"

@protocol LSDeviceUpgradingDelegate <NSObject>

/**
 * 设备升级状态改变的回调
 */
-(void)bleDevice:(LSDeviceInfo *)lsDevice didUpgradeStatusChange:(LSDeviceUpgradeStatus)upgradeStatus
           error:(LSErrorCode)errorCode;

/**
 * 设备升级进度回调
 */
-(void)bleDevice:(LSDeviceInfo *)lsDevice didUpgradeProgressUpdate:(NSUInteger)value;
@end
