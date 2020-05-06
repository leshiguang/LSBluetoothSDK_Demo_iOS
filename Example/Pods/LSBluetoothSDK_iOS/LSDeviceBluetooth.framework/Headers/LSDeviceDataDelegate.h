//
//  LSDeviceDataDelegate.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/2/28.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceInfo.h"
#import "LSPedometerAlarmClock.h"
#import "LSPedometerUserInfo.h"
#import "LSProductUserInfo.h"
#import "LSDeviceMeasureData.h"
#import "LSDeviceData.h"

@protocol LSDeviceDataDelegate <NSObject>

//设备连接状态改变
@required
-(void)bleDevice:(LSDeviceInfo *)device didConnectStateChange:(LSDeviceConnectState)connectState;

//设备信息更新
@optional
-(void)bleDeviceDidInformationUpdate:(LSDeviceInfo *)device;

//接收产品用户信息
@optional
-(void)bleDevice:(LSDeviceInfo *)device didProductUserInfoUpdate:(LSProductUserInfo *)userInfo;


//体重测量数据更新
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeight:(LSWeightData *)weightData;

//脂肪测量数据更新
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeightAppend:(LSWeightAppendData *)data;

//血压测量数据更新
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodPressure:(LSSphygmometerData *)data;

//厨房秤测量数据
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForKitchen:(LSKitchenScaleData *)kitData;

//身高测量数据更新
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForHeight:(LSHeightData *)heightData;

/**
 * 设备电量电压数据更新
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)lsDevice didBatteryVoltageUpdate:(LSUVoltageModel *)voltageModel;

/**
 * 手环数据更新，如A2手环、微信手环、A5手环的数据更新
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForPedometer:(LSDeviceData *)dataObj;

#pragma mark - Added in version 1.1.4 LSBloodGlucoseData

/**
 * 血糖仪测量数据回调
 */
@optional
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodGlucose:(LSBloodGlucoseData *)data;
@end
