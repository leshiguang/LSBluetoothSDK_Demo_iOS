//
//  LSBluetoothStatusDelegate.h
//  DeviceUpgrade-Library
//
//  Created by caichixiang on 2016/10/14.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol LSBluetoothStatusDelegate <NSObject>

/*!
 * 系统蓝牙状态改变的回调
 */
-(void)systemDidBluetoothStatusChange:(CBManagerState)bleState;

@end
