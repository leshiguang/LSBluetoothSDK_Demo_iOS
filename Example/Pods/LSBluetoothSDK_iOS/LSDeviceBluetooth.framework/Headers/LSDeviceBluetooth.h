//
//  LSDeviceBluetooth.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2017/4/8.
//  Copyright © 2017年 sky. All rights reserved.
//  otool -l LSDeviceBluetooth | grep __LLVM | wc -l 检测sdk是否支持bitcode
//

#import <UIKit/UIKit.h>
#import <LSDeviceBluetooth/LSBluetoothManager.h>
#import <LSDeviceBluetooth/LSBluetoothManager+Push.h>

//! Project version number for LSDeviceBluetooth.
FOUNDATION_EXPORT double LSDeviceBluetoothVersionNumber;

//! Project version string for LSDeviceBluetooth.
FOUNDATION_EXPORT const unsigned char LSDeviceBluetoothVersionString[];

// In this header, you should import all the public headers of your framework using statements
// like #import <LSDeviceBluetooth/LSDeviceBluetooth.h>

#pragma mark - LSBluetooth SDK Version 1.2.1

/**
 * Version 1.2.1 更新记录
 * 1、新增设备信息推送接口，如推送健康分数、设备定位（寻找手环）、拍摄信息等
 * 2、新增设备上传远程控制指令解析，如播放音乐、暂停、上一曲、下一曲
 */

#pragma mark - LSBluetooth SDK Version 1.2.2

/**
 * Version 1.2.2 更新记录
 * 1、新增多运动支持
 * 2、新增有氧运动12分钟跑支持
 * 3、新增A6互联秤协议实时数据解析及返回
 *
 */

#pragma mark - LSBluetooth SDK Version 1.2.3

/**
 * Version 1.2.3 更新记录
 * 1、新增设置设备测量数据Delegate属性
 * 2、新增GPS连接成功后，支持App下发运动参数（运动配速、距离等）功能实现
 * 3、修复428产品，设备电量解析不正确的问题
 */

#pragma mark - LSBluetooth SDK Version 1.2.4
/**
 * Version 1.2.4 更新记录
 * 1、新增心情手环支持及心情提醒设置命令
 * 2、新增设备SN与设备ID的转换方法
 * 3、新增DMD 自定义A3协议产品支持
 */

#pragma mark - LSBluetooth SDK Version 1.2.5
/**
 * Version 1.2.5 更新记录
 */

#pragma mark - LSBluetooth SDK Version 1.2.6
/**
 *  Version 1.2.6 更新记录
 *  新增Kchiing 多类型、多提醒设置功能
 */

#pragma mark - LSBluetooth SDK Version 1.2.7
/**
 * 新增M5手环支持
 * 新增勿扰模式设置，
 * 新增太极拳、健身舞运动
 */

#pragma mark - LSBluetooth SDK Version 1.2.8
/**
 * 新增BluetoothPeripheral Usage Description 描述
 */


#pragma mark - LSBluetooth SDK Version 1.2.9
/**
 * 修复A6 互联秤 UTC转换错误的问题
 * 修复蓝牙初始化时，禁用系统提示框操作
 */

#pragma mark - LSBluetooth SDK Version 1.3.0
/**
 * 新增可配置的蓝牙初始化接口
 * 新增A2/A3血压计产品，不规则心率检测状态分析
 */

#pragma mark - LSBluetooth SDK Version 1.3.1
/**
 * 新增标准蓝牙协议血压计支持
 */

#pragma mark - LSBluetooth SDK Version 1.3.2
/**
 * 新增A2血压计设备电量百分比读取操作
 */

#pragma mark - LSBluetooth SDK Version 1.3.4
/**
 * 修复扫描结果因广播名长度解析出错，导致的App闪退
 */

#pragma mark - LSBluetooth SDK Version 1.3.5
/**
 * 修复A6互联秤与广播包带心率数据的手环，广播包数据解析出错导致A6互联秤MAC解析错误的问题
 */

#pragma mark - Version 1.3.6
/**
 * 新增M5/M5S 游泳模式运动数据支持
 */

#pragma mark - Version 1.4.2
