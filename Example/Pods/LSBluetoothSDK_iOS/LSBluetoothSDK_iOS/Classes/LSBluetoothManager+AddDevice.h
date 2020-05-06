//
//  LSBluetoothManager+AddDevice.h
//  AFNetworking
//
//  Created by alex.wu on 2020/4/21.
//

#import <Foundation/Foundation.h>
#import <LSDeviceBluetooth/LSBluetoothManager.h>
#import "LSAuthorization.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSBluetoothManager(AddDevice)


/**
 * Added in version 1.0.0
 * 添加单个测量设备
 */
-(BOOL)addMeasureDevice:(LSDeviceInfo *)lsDevice result:(void (^)(LSAccessCode)) result;

@end

NS_ASSUME_NONNULL_END
