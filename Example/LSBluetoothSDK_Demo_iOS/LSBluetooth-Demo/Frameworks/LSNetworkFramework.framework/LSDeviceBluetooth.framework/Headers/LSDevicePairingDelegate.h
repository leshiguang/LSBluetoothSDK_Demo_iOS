//
//  LSDevicePairingDelegate.h
//  LsBluetooth-Test
//
//  Created by sky on 14-8-13.
//  Copyright (c) 2014年 com.lifesense.ble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceInfo.h"
#import "LSDeviceOperationCmdInfo.h"


@protocol LSDevicePairingDelegate <NSObject>

/**
 * 设备配对结果
 */
@required
-(void)bleDevice:(LSDeviceInfo *)lsDevice didPairingStatusChange:(LSDevicePairedResults)pairingStatus;

/**
 * 设备用户列表更新
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)lsDevice didProductUserlistUpdate:(NSDictionary *)userlist;


/**
 * 设备密码配置结果
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)lsDevice didWifiPasswordConfigResults:(BOOL)isSuccess
           error:(LSErrorCode)code;

/**
 * 在设备绑定或配对过程中，操作指令更新结果回调
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)lsDevice didOperationCommandUpdate:(LSDeviceOperationCmdInfo *)cmdInfo;

@end
