//
//  LSBluetoothManager.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/1.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSDeviceInfo.h"
#import "LSDevicePairingDelegate.h"
#import "LSDeviceDataDelegate.h"
#import "LSBluetoothStatusDelegate.h"
#import "LSDeviceUpgradingDelegate.h"
#import "LSDeviceFilterInfo.h"
#import "LSDebugMessageDelegate.h"


FOUNDATION_EXPORT NSString *const  LSDeviceBluetoothFrameworkVersion;

@interface LSBluetoothManager : NSObject

//sdk 版本名称
@property(nonatomic,strong,readonly)NSString *versionName;
//sdk 工作状态
@property(nonatomic,assign,readonly)LSBManagerStatus managerStatus;
//手机蓝牙是否可用
@property(nonatomic,assign,readonly)BOOL isBluetoothPowerOn;
//手机当前的时区
@property(nonatomic,assign,readonly)NSInteger currentTimeZone;
//设备测量数据同步Delegate
@property(nonatomic,strong)id<LSDeviceDataDelegate> deviceDataDelegate;

@property(nonatomic,strong)DeviceSettingBlock settingCallback;

@property(nonatomic,strong)NSMutableArray <NSData *>* kchiingReminderCmds;

@property(nonatomic,strong)DeviceSettingBlock localSettingBlock;

@property(nonatomic,strong)NSString *activeMac;

#pragma mark - public methods

/**
 * Added in version 1.0.0
 * 获取实例对象
 */
+(instancetype)defaultManager;

/**
 * Added in version 1.0.0
 * 采用系统默认配置的蓝牙初始化
 */
-(void)initManagerWithDispatch:(dispatch_queue_t)dispatchQueue;

/**
 * Added in version 1.3.0
 * 带可选项的系统蓝牙初始化
 */
-(void)initManagerWithDispatch:(dispatch_queue_t)queue
                       options:(nullable NSDictionary<NSString *, id> *)options;

/**
 * Added in version 1.0.0
 * 将调试信息保存到相应的文件目录中
 */
-(void)saveDebugMessage:(BOOL)enable forFileDirectory:(NSString *)filePath;

/**
 * Added in version 1.0.0
 * 设置调试模式
 */
-(void)setDebugMode:(NSString *)permissionKey;


/**
 * Added in version 1.0.0
 * 检查手机蓝牙状态
 */
-(void)checkingBluetoothStatus:(id<LSBluetoothStatusDelegate>)bleStatusDelegate;

/**
 * Added in version 1.0.0
 * 根据指定条件搜索设备
 */
-(BOOL)searchDevice:(NSArray *)deviceTypes
          broadcast:(BroadcastType)broadcastType
       resultsBlock:(SearchResultsBlock)searchResults;

/**
 * Added in version 1.0.0
 * 停止搜索
 */
-(BOOL)stopSearch;
//
///**
// * Added in version 1.0.0
// * 设置测量设备列表
// */
//-(BOOL)setMeasureDeviceList:(NSArray *)deviceList;

/**
 * Added in version 1.0.0
 * 添加单个测量设备
 */
-(BOOL)addMeasureDevice:(LSDeviceInfo *)lsDevice service:(NSString *)serviceId version:(NSString *)serviceVersion;

/**
 * Added in version 1.0.0
 * 根据广播ID删除单个测量设备
 */
-(BOOL)deleteMeasureDevice:(NSString *)broadcastId;

/**
 * Added in version 1.0.0
 * 启动测量数据接收服务
 */
-(BOOL)startDataReceiveService:(id<LSDeviceDataDelegate>)dataDelegate;

/**
 * Added in version 1.0.0
 * 停止测量数据接收服务
 */
-(BOOL)stopDataReceiveService;

/**
 * Added in version 1.0.0
 * 根据设备macAddress,检查设备当前的连接状态
 */
-(LSDeviceConnectState)checkDeviceConnectState:(NSString *)broadcastId;

/**
 * Added in version 1.0.0
 * 绑定设备
 */
-(BOOL)pairingWithDevice:(LSDeviceInfo *)lsDevice
                delegate:(id<LSDevicePairingDelegate>)pairedDelegate;

/**
 * Added in version 1.0.0
 * 取消设备的配对操作
 */
-(void)cancelDevicePairing:(LSDeviceInfo *)lsDevice;

/**
 * Added in version 1.0.0
 * 绑定设备用户编号
 */
-(BOOL)bindingDeviceUser:(LSDeviceInfo *)lsDevice
              userNumber:(NSUInteger)number
                userName:(NSString *)name;


/**
 * Added in version 1.0.0
 * 升级设备固件
 */
-(BOOL)upgradingWithDevice:(LSDeviceInfo *)lsDevice
                      file:(NSURL *)fileUrl
                  delegate:(id<LSDeviceUpgradingDelegate>)upgradingDelegate;


/**
 * Added in version 1.0.0
 * 取消设备固件的升级
 */
-(void)cancelDeviceUpgrading:(NSString *)broadcastId;


/**
 * Added in version 1.0.0
 * 设置设备的产品用户信息，A3脂肪秤、A3体重秤
 * 当deviceId为空时，表示在配对模式下，设置设备的用户信息，
 * deviceId不为空时，表示在数据同步模式下，设置指定设备的用户信息
 */
-(void)setProductUserInfo:(LSProductUserInfo *)userInfo forDevice:(NSString *)deviceId;

/**
 * Added in version 1.0.0
 * 设置手环的用户信息，A2手环
 * 当deviceId为空时，表示在配对模式下，设置设备的用户信息，
 * deviceId不为空时，表示在数据同步模式下，设置指定手环的用户信息
 */
-(void)setPedometerUserInfo:(LSPedometerUserInfo *)userInfo forDevice:(NSString *)deviceId;


/**
 * Added in version 1.0.0
 * 设置手环的闹钟信息，A2手环
 * 当deviceId为空时，表示在配对模式下，设置手环的闹钟信息，
 * deviceId不为空时，表示在数据同步模式下，设置指定设备的闹钟信息
 */
-(void)setPedometerAlarmClock:(LSPedometerAlarmClock *)alarmClock forDevice:(NSString *)deviceId;

/**
 * Added in version 1.0.0
 * 读取设备电量电压信息，读取结果将通过对象LSDeviceDataDelegate里的接口bleDevice:didBatteryVoltageUpdate:返回
 */
-(BOOL)readDeviceVoltage:(NSString *)deviceMac;

/**
 * Added in version 1.0.0
 * 清空CBPeripheral对象缓存
 */
-(void)clearPeripheralCache;


/**
 * Added in version 1.0.2
 * 取消所有设备正在执行的升级操作
 */
-(void)cancelAllDeviceUpgrading;

/**
 * Added in version 1.0.2
 * 更新手机当前的gps状态
 */
-(void)updatePhoneGpsState:(BOOL)enable;

/**
 * Added in version 1.0.3
 * 通过蓝牙配置设备的wifi密码
 */
-(BOOL)configWifiPassword:(NSString *)password
             networksName:(NSString *)ssid
                forDevice:(LSDeviceInfo *)lsDevice
                 delegate:(id<LSDevicePairingDelegate>)delegate;

#pragma mark - Version 1.0.6 Update

/**
 * Added in version 1.0.6
 * 根据不同的工作模式，不同的匹配方式，设置设备过滤信息，filterInfos=nil表示删除已存在的过滤信息或执行无过滤操作
 */
-(BOOL)setDeviceFilterInfo:(NSArray <LSDeviceFilterInfo *>*)filterInfos
           forWorkingState:(LSBManagerStatus)state;


#pragma mark - Version 1.1.0 Update

/**
 * Added in version 1.1.0
 * 在设备绑定或配对过程中，输入相应操作回复指令
 */
-(NSInteger)inputOperationCmd:(LSDeviceOperationCmd)cmd
                     replyObj:(id)obj
                    forDevice:(NSString *)broadcastId;


#pragma mark - Version 1.1.2 Update

/**
 * Added in version 1.1.2
 * 设置调试信息回调对象
 */
-(void)setDebugMessageDelegate:(id<LSDebugMessageDelegate>)delegate permission:(NSString *)key;


#pragma mark - Version 1.1.5 Update

/**
 * 根据电阻值、用户信息计算相关的人体成分数据,
 * 其中用户信息必须填充用户身高（单位M）、用户体重（单位kg）、用户年龄、用户性别、运动员等级，其中运动等级=0表示非运动员
 */
-(LSWeightAppendData *)calculateBodyCompositionData:(double)resistance_2
                                           userInfo:(LSProductUserInfo *)userInfo;


#pragma mark - Added in version 1.2.1

/**
 * 测试远程控制指令
 */
//-(void)testRemoteControlCmd:(LSRemoteControlCmd)cmd;

/**
 * 在文件中记录调试信息
 */
-(void)logMessage:(NSString *)msg;

#pragma mark - Added in version 1.2.4

/**
 * Device ID 转 Device SN
 */
-(NSString *)toDeviceSn:(NSString *)deviceId;

/**
 * Device SN 转 Device ID
 */
-(NSString *)toDeviceID:(NSString *)deviceSn;
@end
