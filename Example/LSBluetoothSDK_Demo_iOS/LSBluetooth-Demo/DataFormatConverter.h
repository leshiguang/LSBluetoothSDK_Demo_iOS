//
//  DataFormatConverter.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/20.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "BleDevice.h"
#import <UIKit/UIKit.h>
#import "DeviceAlarmClock.h"
#import "DeviceUser.h"
#import "DeviceUserProfiles.h"



@interface DataFormatConverter : NSObject


+(LSDeviceType)stringToDeviceType:(id)type;

+(LSDeviceInfo *)convertedToLSDeviceInfo:(BleDevice *)bleDevice;

+(NSString *)doubleValueWithOneDecimalFormat:(double)weightValue;

+(NSString *)doubleValueWithTwoDecimalFormat:(double)weightValue;

+(UIImage *)getDeviceImageViewWithType:(LSDeviceType)deviceType;

+(NSString *)getDeviceNameForNormalBroadcasting:(NSString *)deviceName;

+(BOOL)isNotRequiredPairDevice:(NSString *)protocol;

+(NSDictionary *)parseObjectDetailInDictionary:(id)obj;

+(NSString *)parseObjectDetailInStringValue:(id)obj;

+(NSAttributedString *)parseObjectDetailInAttributedString:(id)obj recordNumber:(NSUInteger)number;

+(int)getAlarmClockDayCount:(DeviceAlarmClock *)deviceAlarmClock;

+(LSPedometerAlarmClock *)getPedometerAlarmClock:(DeviceAlarmClock *)deviceAlarmClock;

+(LSPedometerUserInfo *)getPedometerUserInfo:(DeviceUser *)deviceUser;

+(LSProductUserInfo *)getProductUserInfo:(DeviceUser *)deviceUser;


/**
 * 解析手环测量数据
 */
+(NSArray  *)parseDeviceMeasureData:(LSDeviceData *)data;

/**
 * 解析秤测量数据
 */
+(NSArray *)parseScaleMeasureData:(LSDeviceMeasureData *)data;

/**
 * 解析血压计测量数据
 */
+(NSArray *)parseBloodPressureMeterMeasureData:(LSSphygmometerData *)data;

+(UIColor *)colorWithHexString:(NSString *)hexString;


+(NSArray*)getRepeatWeekDays:(DeviceAlarmClock *)deviceAlarmClock;

+(NSMutableString*) timeLeftSinceDate: (NSDate *) dateT;


+(NSUInteger)currentDevicePower;
@end
