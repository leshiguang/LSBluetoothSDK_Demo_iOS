//
//  LSDeviceSettingProfiles.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/1.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "LSDeviceSettingProfiles.h"
#import "DeviceUser.h"
#import "ScanFilter.h"
#import "LSDatabaseManager.h"
#import "DeviceUser+Handler.h"
#import "BleDevice+Handler.h"
#import "DataFormatConverter.h"


@implementation LSDeviceSettingProfiles

//-(void)updateDeviceSedentaryInfo
//{
//
//    LSSedentaryClock *sedentaryClock=[[LSSedentaryClock alloc] init];
//    sedentaryClock.isOpen=YES;
//    sedentaryClock.startHour=9;
//    sedentaryClock.startMinute=30;
//    sedentaryClock.endHour=23;
//    sedentaryClock.endMinute=30;
//    sedentaryClock.shockType=LSVibrationModeContinued;
//    sedentaryClock.shockTime=10;
//    sedentaryClock.shockLevel1=7;
//    sedentaryClock.shockLevel2=8;
//    sedentaryClock.interval=5;
//    [sedentaryClock addWeek:LSWeekMonday,LSWeekTuesday,LSWeekWednesday,LSWeekThursday,LSWeekFriday,LSWeekSaturday,LSWeekSunday];
//
//    [[LSBluetoothManager defaultManager]  updateSedentaryInfo:@[sedentaryClock] isEnableAll:YES
//                                                    forDevice:self.currentDevice.broadcastId
//                                                     andBlock:^(BOOL isSuccess, NSUInteger errorCode)
//     {
//         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Sedentary Clock"];
//     }];
//}


+(void)enterSportMode:(NSString *)broadcastId
{
    LSSportRequestInfo *request=[[LSSportRequestInfo alloc] init];
    request.sportMode=LSSportModeAerobicSport12;
    request.state=0x00;
    [[LSBluetoothManager defaultManager] pushDeviceMessage:request
                                                 forDevice:broadcastId
                                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode) {

    }];
}

#pragma mark - Update Device Setting Info

/*
-(void)updateDeviceAlarmClock:(NSString *)broadcastId
{
    DeviceUser *currentDeviceUser=[[[LSDatabaseManager defaultManager] allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    DeviceAlarmClock *deviceAlarmClock=currentDeviceUser.userprofiles.deviceAlarmClock;
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:deviceAlarmClock.alarmClockTime];
    NSInteger hour=[dateComponents hour];
    NSInteger minute=[dateComponents minute];
    
    LSPedometerAlarmClock *alarmClock=[[LSPedometerAlarmClock alloc] init];
    alarmClock.isOpen=YES;
    alarmClock.hour=hour;
    alarmClock.minute=minute;
    alarmClock.shockType=LSVibrationModeInterval;
    alarmClock.shockTime=15;
    alarmClock.shockLevel1=6;
    alarmClock.shockLevel2=8;
    
    for(NSNumber *day in [DataFormatConverter getRepeatWeekDays:deviceAlarmClock])
    {
        [alarmClock addWeek:(LSWeek)day.integerValue];
    }
    [[LSBluetoothManager defaultManager]  updateAlarmClock:@[alarmClock] isEnableAll:YES
                              forDevice:broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger code)
     {
         
     }];
}

-(void)updateDeviceMessageRemind:(LSDeviceMessageType)messageType
{
    //无来电提醒时，调用一下这个接口，
    LSDMessageReminder *callRemind=[[LSDMessageReminder alloc] init];
    callRemind.type=messageType;
    callRemind.isOpen=YES;
    callRemind.shockDelay=2;
    callRemind.shockType=LSVibrationModeInterval;
    callRemind.shockTime=10;
    callRemind.shockLevel1=6;
    callRemind.shockLevel2=8;
    [[LSBluetoothManager defaultManager]  updateMessageRemind:callRemind
                                 forDevice:self.currentDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Call Remind"];
     }];
}
-(void)updateDeviceUserInfo
{
    LSPedometerUserInfo *userInfo=[DataFormatConverter getPedometerUserInfo:self.currentDeviceUser];
    [[LSBluetoothManager defaultManager]  updateDeviceUserInfo:userInfo forDevice:self.currentDevice.broadcastId
                                   andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"User Info"];
     }];
}


-(void)updateDeviceAntilostInfo
{
    LSDPreventLost *lostRemind=[[LSDPreventLost alloc] init];
    lostRemind.isOpen=YES;
    lostRemind.disconnectTime=10;
    [[LSBluetoothManager defaultManager]  updateAntilostInfo:lostRemind forDevice:self.currentDevice.broadcastId
                                 andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Anti lost"];
     }];
}

-(void)updateDeviceStepGoal
{
    [[LSBluetoothManager defaultManager]  updateStepGoal:10000 isEnable:YES
                            forDevice:self.currentDevice.broadcastId
                             andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Step Goal"];
         
     }];
    
}
-(void)updateDeviceHeartRateDetection
{
    LSDHeartRate *detection=[[LSDHeartRate alloc] init];
    detection.isOpen=YES;
    detection.startHour=0;
    detection.startMinute=0;
    detection.endHour=0;
    detection.endMinute=0;
    [[LSBluetoothManager defaultManager]  updateHeartRateDetection:detection
                                      forDevice:self.currentDevice.broadcastId
                                       andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Heart Rate Detection"];
     }];
}

-(void)updateDeviceHeartRateRange
{
    [[LSBluetoothManager defaultManager]  updateHeartRateRange:40
                                  forDevice:self.currentDevice.broadcastId
                                   andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Heart Rate Range"];
     }];
}
-(void)updateDeviceNightDisplayMode
{
    LSDNightMode *nightMode=[[LSDNightMode alloc] init];
    nightMode.startHour=9;
    nightMode.startMin=40;
    nightMode.endHour=9;
    nightMode.endMin=45;
    nightMode.isOpen=YES;
    [[LSBluetoothManager defaultManager]  updateNightDisplayMode:nightMode
                                    froDevcie:self.currentDevice.broadcastId
                                     andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Night Display Mode"];
     }];
}

-(void)updateDeviceWearingStyles
{
    [[LSBluetoothManager defaultManager]  updateWearingStyles:LSWearingStyleRightHand
                                 forDevice:self.currentDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Wearing Styles"];
     }];
}
-(void)updateDeviceScreenMode
{
    [[LSBluetoothManager defaultManager]  updateScreenMode:LSScreenDisplayModeHorizontal
                              forDevice:self.currentDevice.broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger code)
     {
         [self showDeviceUpdateResult:isSuccess error:code type:@"Screen Mode"];
     }];
}

-(void)updateDevicePageSequence
{
    LSDDisplayPage *page=[[LSDDisplayPage alloc] init];
    [page addPage:LSDevicePageTime];
    [page addPage:LSDevicePageCalories];
    [page addPage:LSDevicePageDistance];
    [page addPage:LSDevicePageRunning];
    [page addPage:LSDevicePageHeartRate];
    [page addPage:LSDevicePageStep];
    
    [[LSBluetoothManager defaultManager]  updatePageSequence:page forDevice:self.currentDevice.broadcastId
                                 andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Page Sequence"];
     }];
    
}

-(void)updateDeviceHeartRateDetectionMode
{
    [[LSBluetoothManager defaultManager]  updateHeartRateDetectionMode:LSHRDetectionModeIntelligent
                                          forDevice:self.currentDevice.broadcastId
                                           andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Heart Rate Detection Mode"];
     }];
}
-(void)updateDeviceTimeFormat
{
    [[LSBluetoothManager defaultManager]  updateTimeFormat:LSDeviceTimeFormat24
                              forDevice:self.currentDevice.broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Time Format"];
     }];
}

-(void)updateDeviceDistanceUnits
{
    [[LSBluetoothManager defaultManager]  updateDistanceUnits:LSDistanceUnitMetricSystem
                                 forDevice:self.currentDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Distance Unit"];
     }];
}

-(void)updateDeviceDialPeace
{
    LSDeviceDialPeaceInfo *dialPeace=[[LSDeviceDialPeaceInfo alloc] init];
    dialPeace.dialStyle=LSDialPeaceStyle2;
    [[LSBluetoothManager defaultManager]  updateDialPeaceInfo:dialPeace forDevice:self.currentDevice.broadcastId andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
        [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Dial Peace"];
    }];
}



-(void)updateDeviceWeather
{
    LSDeviceWeatherInfo *weather=[[LSDeviceWeatherInfo alloc] init];
    LSFutureWeatherModel *model=[[LSFutureWeatherModel alloc] init];
    model.type=LSWeatherTypedFog;
    model.temperatureOne=23;
    model.temperatureTwo=10;
    model.AQI=10;
    long long utc = [NSDate date].timeIntervalSince1970;
    weather.utc=utc;
    [weather addWeatherData:model];
    [[LSBluetoothManager defaultManager]  updateWeatherInfo:weather
                               forDevice:self.currentDevice.broadcastId
                                andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
                                }];
}


-(void)updateHeartbeatInfo:(BOOL)isEnable
{
    LSDeviceFunctionInfo *functionSwitchInfo=[[LSDeviceFunctionInfo alloc] init];
    functionSwitchInfo.enable=isEnable;
    functionSwitchInfo.function=LSDeviceFunctionHeartbeat;
    [[LSBluetoothManager defaultManager]  updateDeviceFunctionInfo:functionSwitchInfo
                                      forDevice:self.currentDevice.broadcastId
                                       andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
                                           [self showDeviceUpdateResult:isSuccess error:errorCode type:@"Device Function"];
                                           
                                       }];
}
*/
/*
//在数据同步模式中，设置秤的用户信息
-(void)setProductUserInfoOnSyncMode
{
    LSProductUserInfo *userInfo=[DataFormatConverter getProductUserInfo:self.currentDeviceUser];
    userInfo.deviceId=self.currentDevice.deviceId;
    userInfo.userNumber=self.currentDevice.deviceUserNumber;
    NSLog(@"set product user info on sync mode %@",[DataFormatConverter parseObjectDetailInDictionary:userInfo]);
    [[LSBluetoothManager defaultManager]  setProductUserInfo:userInfo forDevice:self.currentDevice.deviceId];
}

//在数据同步模式中，设置闹钟信息
-(void)setPedometerUserInfoOnSyncMode
{
    DeviceAlarmClock *deviceAlarmClock=self.currentDeviceUser.userprofiles.deviceAlarmClock;
    
    //set pedometer alarm clock in data syncing mode
    LSPedometerAlarmClock *alarmClock=[DataFormatConverter getPedometerAlarmClock:deviceAlarmClock];
    alarmClock.deviceId=self.currentDevice.deviceId;
    [[LSBluetoothManager defaultManager]  setPedometerAlarmClock:alarmClock forDevice:self.currentDevice.deviceId];
    
    //set pedometer user info in data syncing mode
    LSPedometerUserInfo *pedometerUserInfo=[DataFormatConverter getPedometerUserInfo:self.currentDeviceUser];
    pedometerUserInfo.deviceId=self.currentDevice.deviceId;
    [[LSBluetoothManager defaultManager]  setPedometerUserInfo:pedometerUserInfo forDevice:self.currentDevice.deviceId];
}
*/

@end
