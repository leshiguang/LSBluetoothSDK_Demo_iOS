//
//  LSBluetoothManager+Push.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/4/6.
//  Copyright © 2017年 sky. All rights reserved.
//

#import "LSBluetoothManager.h"
#import "LSCmdPacket.h"
#import "KCIReminder.h"
#import "LSDeviceSetting.h"


@interface LSBluetoothManager (Push)



#pragma mark -  Push Command


/**
 * Added in version 1.0.0
 * 更新设备的用户信息
 */
-(void)updateDeviceUserInfo:(LSPedometerUserInfo *)userInfo
                  forDevice:(NSString *)broadacstId
                   andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的闹钟信息，如Mambo、MamboCall、MamboHR、MamboWatch、Mambo2等
 */
-(void)updateAlarmClock:(NSArray<LSPedometerAlarmClock *> *)alarmClocks
            isEnableAll:(BOOL)enable
              forDevice:(NSString *)broadcastId
               andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新设备消息提醒设置
 */
- (void)updateMessageRemind:(LSDMessageReminder *)remind
                  forDevice:(NSString *)broadcastId
                   andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新设备久坐提醒设置信息
 */
- (void)updateSedentaryInfo:(NSArray<LSSedentaryClock *> *)sedentarys
                isEnableAll:(BOOL)enable
                  forDevice:(NSString *)broadcastId
                   andBlock:(DeviceSettingBlock)settingBlock;



/**
 * Added in version 1.0.0
 * 更新设备的防丢设置信息
 */
- (void)updateAntilostInfo:(LSDPreventLost *)lostInfo
                 forDevice:(NSString *)broadcastId
                  andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新设备的目标步数，鼓励设置信息
 */
- (void)updateStepGoal:(int)step
              isEnable:(BOOL)enable
             forDevice:(NSString *)broadcastId
              andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新设备的心率检测设置信息
 */
-(void)updateHeartRateDetection:(LSDHeartRate *)detectInfo
                      forDevice:(NSString *)broadcastId
                       andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 根据用户年龄，更新设备的心率区间计算范围(Watch)
 */
- (void)updateHeartRateRange:(NSUInteger)userAge
                   forDevice:(NSString *)broadcastId
                    andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的夜间显示模式(MT,Gold)
 */
- (void)updateNightDisplayMode:(LSDNightMode *)nightMode
                     froDevcie:(NSString *)broadcastId
                      andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的佩戴方式(MT,Gold)
 */
-(void)updateWearingStyles:(LSWearingStyle)wearingStyle
                 forDevice:(NSString *)broadcastId
                  andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的屏幕显示方式(MT,Gold)
 */
-(void)updateScreenMode:(LSScreenDisplayMode)screenMode
              forDevice:(NSString *)broadcastId
               andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的自定义显示页面(MT,Gold)
 */
-(void)updatePageSequence:(LSDDisplayPage *)displayPage
                forDevice:(NSString *)broadcastId
                 andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的智能心率检测开关(MT,Gold)
 */
-(void)updateHeartRateDetectionMode:(LSHRDetectionMode)type
                          forDevice:(NSString *)broadcastId
                           andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的时间显示格式设置信息，如12小时，或24小时
 */
-(void)updateTimeFormat:(LSDeviceTimeFormat)type
              forDevice:(NSString *)broadcastId
               andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.0.0
 * 更新手环的距离单位设置信息
 */
-(void)updateDistanceUnits:(LSDistanceUnit)unit
                 forDevice:(NSString *)broadcastId
                  andBlock:(DeviceSettingBlock)settingBlock;


#pragma mark - Version 1.1.0 Update

/**
 * Added in version 1.1.0
 * 更新手环运动模式的自动识别状态
 */
-(void)updateAutoRecognition:(NSArray <LSAutomaticSportstypeModel *>*)autoRecognitions
                   forDevice:(NSString *)broadcastId
                    andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.1.0
 * 更新手环的事件提醒设置信息
 */
-(void)updateEventReminderInfo:(LSDeviceEventReminderInfo *)eventInfo
                     forDevice:(NSString *)broadcastId
                      andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.1.0
 * 更新手环的鼓励目标设置，支持不同类型的鼓励目标，包括：步数；卡路里；距离；
 */
-(void)updateEncourageInfo:(LSDeviceEncourageInfo *)encourageInfo
                 forDevice:(NSString *)broadcastId
                  andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.1.0
 * 更新手环的天气显示信息
 */
-(void)updateWeatherInfo:(LSDeviceWeatherInfo *)weatherInfo
               forDevice:(NSString *)broadcastId
                andBlock:(DeviceSettingBlock)settingBlock;

/**
 * Added in version 1.1.0
 * 更新手环的表盘样式
 */
-(void)updateDialPeaceInfo:(LSDeviceDialPeaceInfo *)dialInfo
                 forDevice:(NSString *)broadcastId
                  andBlock:(DeviceSettingBlock)settingBlock;


/**
 * Added in version 1.1.0
 * 更新手环在运动模式下的心率预警信息
 */
-(void)updateHeartRateAlertInfo:(LSDeviceHeartRateAlertInfo *)alertInfo
                      forDevice:(NSString *)broadcastId
                       andBlock:(DeviceSettingBlock)settingBlock;

#pragma mark - Added In Version 1.1.3
/**
 * Added in version 1.1.3
 * 更新手环功能开关设置信息
 */
-(void)updateDeviceFunctionInfo:(LSDeviceFunctionInfo *)switchInfo
                      forDevice:(NSString *)broadcastId
                       andBlock:(DeviceSettingBlock)settingBlock;

#pragma mark - Added in version 1.1.8
/**
 * Added in version 1.1.8
 * 更新手环的行为功能提醒
 */
-(void)updateBehaviorRemind:(LSBehaviorRemindInfo *)remindInfo
                  forDevice:(NSString *)broadcastId
                   andBlock:(DeviceSettingBlock)settingBlock;


#pragma mark - Added in version 1.2.1

/**
 * Added in version 1.2.1
 * 推送设备信息
 */
-(void)pushDeviceMessage:(id)msg
               forDevice:(NSString *)broadcastId
                andBlock:(DeviceSettingBlock)settingBlock;

@end
