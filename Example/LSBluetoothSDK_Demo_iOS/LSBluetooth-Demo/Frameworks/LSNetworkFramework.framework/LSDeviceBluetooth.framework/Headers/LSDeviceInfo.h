//
//  LSDeviceProfiles.h
//  LifesenseBle
//
//  Created by lifesense on 14-8-1.
//  Copyright (c) 2014年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSDeviceMeasureData.h"


@interface LSDeviceInfo : NSObject

@property(nonatomic, strong) NSString *deviceId;            //设备ID
@property(nonatomic, strong) NSString *deviceSn;            //设备SN
@property(nonatomic, strong) NSString *deviceName;          //设备名称
@property(nonatomic, strong) NSString *modelNumber;         //设备型号
@property(nonatomic, strong) NSString *password;            //密码
@property(nonatomic, strong) NSString *broadcastId;         //广播ID,A2,A3是广播ID,A5是mac地址（无冒号的形式）
@property(nonatomic, strong) NSString *protocolType;        //协议类型
@property(nonatomic, assign) BOOL preparePair;              //是否处于配对状态，不用保存在数据库，只是临时变量
@property(nonatomic, assign) LSDeviceType deviceType;       //设备类型
@property(nonatomic, assign) NSInteger maxUserQuantity;     //最大用户数
@property(nonatomic, strong) NSString *softwareVersion;     //软件版本
@property(nonatomic, strong) NSString *hardwareVersion;     //硬件版本
@property(nonatomic, strong) NSString *firmwareVersion;     //固件版本
@property(nonatomic, strong) NSString *manufactureName;     //制造商名称
@property(nonatomic, strong) NSString *timezone;            //时区，有些有
@property(nonatomic, assign) BOOL isInSystem;               // 是否在系统列表中
@property(nonatomic, strong) NSString *peripheralIdentifier;//系统蓝牙设备的id,可以唯一表示一个设备
@property(nonatomic, assign) NSUInteger deviceUserNumber;   //设备当前的用户编号
@property(nonatomic, strong) NSString *macAddress;          // 设备mac地址
@property(nonatomic,strong)  NSNumber *rssi;                //信号强度
@property(nonatomic,strong)  NSArray  *services;            //设备gatt服务列表
@property(nonatomic,strong)  NSString *manufacturerData;    //广播信息
@property(nonatomic, assign) BOOL isUpgrading;              // 是否正在升级
@property(nonatomic, strong) NSString *reverseMac;          // 反序的设备mac地址

#pragma mark - Version 1.1.0 Update
@property(nonatomic, assign) BOOL isRegistered;             //是否已注册,互联秤的广播内容

#pragma mark - Added in version 1.2.5
@property(nonatomic, strong) LSScaleUserInfo *userInfo;     //互联秤用户信息
@property(nonatomic, assign) int battery;                   //设备电量

#pragma mark - Added in version 1.3.2
@property(nonatomic, assign) int heartRate;                 //广播数据包里的当前心率

#pragma mark - Added in version 1.3.6
@property(nonatomic,assign) BOOL delayDisconnect;           //延时断开

@property(nonatomic,assign,readonly) BOOL autoRegister;     //自动注册设备ID

@property(nonatomic,assign)long syncUtc;                    //custom utc value by App
@property(nonatomic,assign)BOOL syncAllData;                //不区分血压计的用户编号，同步所有数据，默认为NO

/**
 * 设备关键信息概述
 */
-(NSString *)keyWords;

/**
 * 设备版本信息
 */
-(NSString *)versionInfo;


-(NSString *)serviceStringValue;

/**
 * 自动注册设备ID
 */
-(void)autoRegister:(NSString *)key;
@end




