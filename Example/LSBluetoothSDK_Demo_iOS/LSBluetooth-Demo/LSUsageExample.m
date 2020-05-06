//
//  LSUsageExample.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2017/4/15.
//  Copyright © 2017年 Lifesense. All rights reserved.
//

#import "LSUsageExample.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "LSBluetoothManager+AddDevice.h"

@interface LSUsageExample()<LSDeviceDataDelegate,LSDevicePairingDelegate>
@property(nonatomic,strong)LSBluetoothManager *lsBleManager;

@end

@implementation LSUsageExample

#pragma mark - LSDataDelegate

//Device connection state change
-(void)bleDevice:(LSDeviceInfo *)device didConnectStateChange:(LSDeviceConnectState)connectState
{
    //TODO
}

//Device information update
-(void)bleDeviceDidInformationUpdate:(LSDeviceInfo *)device
{
    //TODO optional
}

//Product user info update
-(void)bleDevice:(LSDeviceInfo *)device didProductUserInfoUpdate:(LSProductUserInfo *)userInfo
{
    //TODO optional
}

//Weight measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeight:(LSWeightData *)weightData
{
    //TODO optional
}

//fat measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeightAppend:(LSWeightAppendData *)data
{
    //TODO optional
}

//Blood prossure measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodPressure:(LSSphygmometerData *)data
{
    //TODO optional
}

//Kitchen scale measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForKitchen:(LSKitchenScaleData *)kitData
{
    //TODO optional
}

//Device battery voltage update
-(void)bleDevice:(LSDeviceInfo *)lsDevice didBatteryVoltageUpdate:(LSUVoltageModel *)voltageObj
{
    
    NSString *msg=[NSString stringWithFormat:@"device voltage results:%@,isCharging ? %@",@(voltageObj.voltage),voltageObj.isCharging ? @"Yes":@"No"];
}

//Pedometer measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForPedometer:(LSDeviceData *)data
{
    [self parsePedometerData:data];
}


/**
 * Parse pedometer measurement data
 */
-(void)parsePedometerData:(LSDeviceData *)data
{
    if([data.dataObj isKindOfClass:[LSPedometerData class]])
    {
        //TODO
        LSPedometerData *pedData=(LSPedometerData *)data.dataObj;
    }
    else if([ data.dataObj isKindOfClass:[NSArray class]])
    {
        //TOTO wechat product data
        NSArray *datalist=(NSArray *)data.dataObj;
        if(data.dataType == LSPacketCommand82 || data.dataType ==LSPacketCommand8B
           || data.dataType == LSPacketCommandCA || data.dataType == LSPacketCommandC9)
        {
            for(LSPedometerData *pedData in datalist)
            {
                
            }
        }
        else if(data.dataType == LSPacketCommand83 || data.dataType==LSPacketCommandCE)
        {
            //sleep data
            for(LSUSleepData *sData in datalist)
            {
                //sData.sleepLevel
            }
        }
    }
    else if ([ data.dataObj isKindOfClass:[LSUHearRate class]])
    {
        //TODO A5 product heart rate measurement data
        LSUHearRate *obj=(LSUHearRate *) data.dataObj;
        //obj.heartRateList
    }
    else if ([ data.dataObj isKindOfClass:[LSUSleepData class]])
    {
        //TODO A5 product sleep data
        LSUSleepData *sleepData=(LSUSleepData *) data.dataObj;
        //sleepData.statusList
    }
    else if ([ data.dataObj isKindOfClass:[LSUCaloriesData class]])
    {
        //Running calorie measurement data
        LSUCaloriesData *caloriesData=(LSUCaloriesData *) data.dataObj;
        //caloriesData.calorieList]
    }
    else if ([ data.dataObj isKindOfClass:[LSUHRSection class]])
    {
        //Heart rate interval measurement data
        LSUHRSection *obj=(LSUHRSection *) data.dataObj;
    }
    else if ([ data.dataObj isKindOfClass:[LSUSportData class]])
    {
        //Running measurement data
        LSUSportData *obj=(LSUSportData *) data.dataObj;
        
    }
    else if ([ data.dataObj isKindOfClass:[LSUSportHeartRate class]])
    {
        //Running heart rate measurement data
        LSUSportHeartRate *obj=(LSUSportHeartRate *) data.dataObj;
        //obj.heartRateList
    }
   
}

-(BOOL)isDeviceConnected:(NSString *)broadcastId
{
    if([self.lsBleManager checkDeviceConnectState:broadcastId]==LSDeviceStateConnectSuccess)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}


-(void)addMeasureDevice
{
    //create LSDeviceInfo object,and set the key information
    LSDeviceInfo *lsDevice=[[LSDeviceInfo alloc] init];
    lsDevice.deviceId=@"xxxxxxxx";//nonnull
    lsDevice.broadcastId=@"xxxxx";//nonnull
    lsDevice.macAddress=@"xxxxxx";//nullable
    lsDevice.protocolType=@"xxxx";//nonnull
    lsDevice.deviceType=LSDeviceTypePedometer;//@"nonnull"
    
    if([lsDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame
       ||[lsDevice.protocolType caseInsensitiveCompare:@"A3"]==NSOrderedSame
       ||[lsDevice.protocolType caseInsensitiveCompare:@"A3_1"]==NSOrderedSame
       ||[lsDevice.protocolType caseInsensitiveCompare:@"A3_3"]==NSOrderedSame)
    {
        lsDevice.password=@"xxxxx";//nonnull;
    }
    
    /**
     * in some old products, such as A2, A3,
     * you can change the device's settings info before starting the data sync service
     */
    if(LSDeviceTypeWeightScale==lsDevice.deviceType||LSDeviceTypeFatScale==lsDevice.deviceType)
    {
        /**
         * optional step,set product user info in data synchronization mode
         */
        LSProductUserInfo *userInfo=[[LSProductUserInfo alloc] init];
        userInfo.age=34;					//user age
        userInfo.height=1.78;               //unit of measurement is m
        userInfo.goalWeight=80;             //unit of measurement is kg
        userInfo.unit=LSMeasurementUnitKg;	//measurement unit
        userInfo.gender=LSUserGenderMale;	//user gender
        userInfo.athleteLevel=5;			//athlete level
        userInfo.deviceId=lsDevice.deviceId;
        
        //calling interface
        [self.lsBleManager setProductUserInfo:userInfo forDevice:lsDevice.deviceId];
    }
    else if(LSDeviceTypePedometer == lsDevice.deviceType
            && [lsDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame)
    {
        /**
         * optional step,set pedometer user info in data synchronization mode
         */
        LSPedometerUserInfo *pedometerUserInfo=[[LSPedometerUserInfo alloc] init];
        pedometerUserInfo.userNo=1;
        pedometerUserInfo.weight=80;            //unit of measurement is kg; max <= 300kg
        pedometerUserInfo.height=1.87;          //unit of measurement is m;max <=2.5m
        pedometerUserInfo.age=36;			  	  //user age
        pedometerUserInfo.isAthlete=YES;		  //it is an athlete
        pedometerUserInfo.athleteActivityLevel=3;	 // minimum=1,maximum=5
        pedometerUserInfo.userGender=LSUserGenderMale; //user gender
        pedometerUserInfo.weekStart=1;			   //1 for Sunday,2 for Monday
        pedometerUserInfo.targetStep=8000;          //target number of step
        pedometerUserInfo.targetType=LSWeekTargetStep;
        pedometerUserInfo.deviceId=lsDevice.deviceId;
        
        //calling interface
        [self.lsBleManager setPedometerUserInfo:pedometerUserInfo forDevice:lsDevice.deviceId];
        
        /**
         * optional step,set pedometer alarm clock in data synchronization mode
         */
        //repeat day
        int weekDay=MONDAY+TUESDAY+WEANSDAY+THURSDAY+FRIDAY+SATADAY+SUNDAY;
        LSPedometerAlarmClock *alarmClock=[[LSPedometerAlarmClock alloc] init];
        alarmClock.switch1=1;
        alarmClock.day1=weekDay;
        alarmClock.hour1=15;
        alarmClock.minute1=16;
        alarmClock.deviceId=lsDevice.deviceId;
        [self.lsBleManager setPedometerAlarmClock:alarmClock forDevice:lsDevice.deviceId];
    }
    
    //remove all devices that have been added
    
    //add the new measure device
    [self.lsBleManager addMeasureDevice:lsDevice result:^(LSAccessCode result) {
        
    }];
}


#pragma mark - LSDevicePairingDelegate

-(void)bleDevice:(LSDeviceInfo *)lsDevice didProductUserlistUpdate:(NSDictionary *)userlist
{
    //binding device's user
    [self.lsBleManager bindingDeviceUser:lsDevice userNumber:1 userName:@"sky"];
}

-(void)bleDevice:(LSDeviceInfo *)lsDevice didPairingStatusChange:(LSDevicePairedResults)state
{
    if(LSDevicePairedResultsSuccess == state && lsDevice)
    {
        //paired success
        //handle paired results,save device key information
        [self saveDeviceInfo:lsDevice];
        
    }
    else
    {
        //paired failure
    }
}

/**
 * pairing with device
 */
-(void)pairingDevice:(LSDeviceInfo *)lsDevice
{
    //stop search
    [[LSBluetoothManager defaultManager] stopSearch];
    /**
     * in some old products, such as A2, A3,
     * you can change the device's settings info before pairing
     */
    if(LSDeviceTypeWeightScale==lsDevice.deviceType||LSDeviceTypeFatScale==lsDevice.deviceType)
    {
        /**
         * optional step,set product user info in pairing mode
         */
        LSProductUserInfo *userInfo=[[LSProductUserInfo alloc] init];
        userInfo.age=34;					//user age
        userInfo.height=1.78;               //unit of measurement is m
        userInfo.goalWeight=80;             //unit of measurement is kg
        userInfo.unit=LSMeasurementUnitKg;	//measurement unit
        userInfo.gender=LSUserGenderMale;	//user gender
        userInfo.athleteLevel=5;			//athlete level
        
        //calling interface
        [self.lsBleManager setProductUserInfo:userInfo forDevice:lsDevice.deviceId];
    }
    else if(LSDeviceTypePedometer == lsDevice.deviceType)
    {
        /**
         * optional step,set pedometer user info in pairing mode
         */
        LSPedometerUserInfo *pedometerUserInfo=[[LSPedometerUserInfo alloc] init];
        pedometerUserInfo.userNo=1;
        pedometerUserInfo.weight=80;        //unit of measurement is kg; max <= 300kg
        pedometerUserInfo.height=1.87;      //unit of measurement is m;max <=2.5m
        pedometerUserInfo.age=36;			  	  //user age
        pedometerUserInfo.isAthlete=YES;		  //it is an athlete
        pedometerUserInfo.athleteActivityLevel=3;	 // minimum=1,maximum=5
        pedometerUserInfo.userGender=LSUserGenderMale; //user gender
        pedometerUserInfo.weekStart=1;			   //1 for Sunday,2 for Monday
        pedometerUserInfo.targetStep=8000;          //target number of step
        pedometerUserInfo.targetType=LSWeekTargetStep;
        
        //calling interface
        [self.lsBleManager setPedometerUserInfo:pedometerUserInfo forDevice:lsDevice.deviceId];
        
        /**
         * optional step,set pedometer alarm clock in pairing mode
         */
        //repeat day
        int weekDay=MONDAY+TUESDAY+WEANSDAY+THURSDAY+FRIDAY+SATADAY+SUNDAY;
        LSPedometerAlarmClock *alarmClock=[[LSPedometerAlarmClock alloc] init];
        alarmClock.switch1=1;
        alarmClock.day1=weekDay;
        alarmClock.hour1=15;
        alarmClock.minute1=16;
        [self.lsBleManager setPedometerAlarmClock:alarmClock forDevice:lsDevice.deviceId];
    }
    
    //pairing device
    [self.lsBleManager pairingWithDevice:lsDevice delegate:self];
}



-(void)saveDeviceInfo:(LSDeviceInfo*)lsDevice
{
    //TODO save device info,like this
    NSString *broadcastId = lsDevice.broadcastId;
    NSString *macAddress = lsDevice.macAddress;
    NSString *deviceType = @(lsDevice.deviceType).stringValue;
    NSString *deviceName = lsDevice.deviceName;
    NSString *protocolType = lsDevice.protocolType;
    
    /**
     * in some old products, such as A2, A3,
     * password and device ID must be saved
     */
    NSString *protoStr=lsDevice.protocolType;
    if([@"A2" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3_1" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3_3" caseInsensitiveCompare:protoStr]==NSOrderedSame)
    {
        NSString *deviceId=lsDevice.deviceId;
        NSString *password=lsDevice.password;
    }
}


-(void)handleScanResults:(LSDeviceInfo *)lsDevice
{
    if(!lsDevice)
    {
        return ;
    }
    NSString *protoStr=lsDevice.protocolType;
    //Check device's protocol and whether it is supported pairing operation
    if([@"A2" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3_1" caseInsensitiveCompare:protoStr]==NSOrderedSame
       || [@"A3_3" caseInsensitiveCompare:protoStr]==NSOrderedSame)
    {
        if(lsDevice.preparePair)
        {
            /**
             * select the target device and pairing
             * before pairing the device, must stop search,like this
             * LsBleManager.getInstance().stopSearch();
             */
            //TODO
        }
    }
    else
    {
        //TODO  display scan results or select the target device
    }
    
}

-(void)searchDevice
{
    if(ManagerStatusFree == self.lsBleManager.managerStatus)
    {
        /**
         * optional step,set scan filter conditions
         * different device types and broadcast type will affect the scan results
         */
        NSMutableArray *scanDeviceType=[[NSMutableArray alloc] init];
        
        //scan scale's pairing broadcast，like this
        [scanDeviceType addObject:@(LSDeviceTypeFatScale)];
        [scanDeviceType addObject:@(LSDeviceTypeWeightScale)];
        //calling searchDevice method
        [self.lsBleManager searchDevice:scanDeviceType broadcast:BroadcastTypePair resultsBlock:^(LSDeviceInfo *lsDevice) {
            //TODO handle scan results
            [self handleScanResults:lsDevice];
        }];
        
        //scan pedometer's all broadcast,like this
        [scanDeviceType addObject:@(LSDeviceTypePedometer)];
        //calling searchDevice method
        [self.lsBleManager searchDevice:scanDeviceType broadcast:BroadcastTypeAll resultsBlock:^(LSDeviceInfo *lsDevice) {
            //TODO handle scan results
            [self handleScanResults:lsDevice];
        }];
        
        //scan Blood Pressure Meter's all broadcast,like this
        [scanDeviceType addObject:@(LSDeviceTypeBloodGlucoseMeter)];
        //calling searchDevice method
        [self.lsBleManager searchDevice:scanDeviceType broadcast:BroadcastTypeAll resultsBlock:^(LSDeviceInfo *lsDevice) {
            //TODO handle scan results
            [self handleScanResults:lsDevice];
        }];
    }
}


#pragma mark - Update Device Setting Info

-(void)updateDeviceUserInfo:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSPedometerUserInfo *userInfo=[[LSPedometerUserInfo alloc] init];
    userInfo.userNo=1;
    userInfo.weight=80;          //unit of measurement is kg; max <= 300kg
    userInfo.height=1.87;        //unit of measurement is m;max <=2.5m
    userInfo.age=36;			 //user age
    userInfo.isAthlete=YES;	     //it is an athlete
    userInfo.weekStart=1;		 //1 for Sunday,2 for Monday
    userInfo.targetStep=8000;    //target number of step
    userInfo.targetType=LSWeekTargetStep;
    userInfo.athleteActivityLevel=3;	 // minimum=1,maximum=5
    userInfo.userGender=LSUserGenderMale; //user gender
    
    [self.lsBleManager updateDeviceUserInfo:userInfo forDevice:lsDevice.broadcastId
                                   andBlock:^(BOOL isSuccess, NSUInteger errorCode)
    {
        if(isSuccess)
        {
            //TODO update success
        }
        else
        {
            //TODO update failure
        }
    }];
}

-(void)updateDeviceAlarmClock:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSPedometerAlarmClock *alarmClock=[[LSPedometerAlarmClock alloc] init];
    alarmClock.isOpen=YES;
    alarmClock.hour=10;
    alarmClock.minute=28;
    alarmClock.shockType=LSVibrationModeContinued;
    alarmClock.shockTime=15;
    alarmClock.shockLevel1=6;
    alarmClock.shockLevel2=8;
    [alarmClock addWeek:LSWeekMonday,LSWeekTuesday,LSWeekWednesday,LSWeekThursday,LSWeekFriday,LSWeekSaturday,LSWeekSunday];
    [self.lsBleManager updateAlarmClock:@[alarmClock] isEnableAll:YES forDevice:lsDevice.broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger code)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceMessageRemind:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSDMessageReminder *callRemind=[[LSDMessageReminder alloc] init];
    callRemind.isOpen=YES;
    callRemind.shockDelay=2;
    callRemind.shockType=LSVibrationModeInterval;
    callRemind.shockTime=10;
    callRemind.shockLevel1=6;
    callRemind.shockLevel2=8;
    
    //optional,update device's incoming call message remind setting
    callRemind.type=LSDeviceMessageIncomingCall;
    
    //optional,update device's sms message remind setting
    callRemind.type=LSDeviceMessageSMS;
    
    //optional,update device's wechat message remind setting
    callRemind.type=LSDeviceMessageWechat;
    
    [self.lsBleManager updateMessageRemind:callRemind
                                 forDevice:lsDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceSedentaryInfo:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSSedentaryClock *sedentaryClock=[[LSSedentaryClock alloc] init];
    sedentaryClock.isOpen=YES;
    sedentaryClock.startHour=9;
    sedentaryClock.startMinute=30;
    sedentaryClock.endHour=10;
    sedentaryClock.endMinute=0;
    sedentaryClock.shockType=LSVibrationModeContinued;
    sedentaryClock.shockTime=10;
    sedentaryClock.shockLevel1=7;
    sedentaryClock.shockLevel2=8;
    sedentaryClock.interval=2;
    [sedentaryClock addWeek:LSWeekMonday,LSWeekTuesday,LSWeekWednesday,LSWeekThursday,LSWeekFriday,LSWeekSaturday,LSWeekSunday];
    
    [self.lsBleManager updateSedentaryInfo:@[sedentaryClock] isEnableAll:YES
                                 forDevice:lsDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}
-(void)updateDeviceAntilostInfo:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSDPreventLost *lostRemind=[[LSDPreventLost alloc] init];
    lostRemind.isOpen=YES;  //true enable disconnect remind
    lostRemind.disconnectTime=10; //disconnect time in seconds
    [self.lsBleManager updateAntilostInfo:lostRemind forDevice:lsDevice.broadcastId
                                 andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceStepGoal:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    [self.lsBleManager updateStepGoal:10000 isEnable:YES
                            forDevice:lsDevice.broadcastId
                             andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
    
}
-(void)updateHeartRateDetection:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    //In 11:35 to 11:40 this time period, turn off the heart rate detection function
    LSDHeartRate *detection=[[LSDHeartRate alloc] init];
    detection.isOpen=NO;
    detection.startHour=11;
    detection.startMinute=35;
    detection.endHour=11;
    detection.endMinute=40;
    [self.lsBleManager updateHeartRateDetection:detection
                                      forDevice:lsDevice.broadcastId
                                       andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceHeartRateRange:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    [self.lsBleManager updateHeartRateRange:40
                                  forDevice:lsDevice.broadcastId
                                   andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}
-(void)updateDeviceNightDisplayMode:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    LSDNightMode *nightMode=[[LSDNightMode alloc] init];
    nightMode.startHour=9;
    nightMode.startMin=40;
    nightMode.endHour=9;
    nightMode.endMin=45;
    nightMode.isOpen=YES;
    [self.lsBleManager updateNightDisplayMode:nightMode
                                    froDevcie:lsDevice.broadcastId
                                     andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceWearingStyles:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    /**
     * LSWearingStyleLeftHand, left hand
     * LSWearingStyleRightHand,right hand
     */
    [self.lsBleManager updateWearingStyles:LSWearingStyleRightHand
                                 forDevice:lsDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}
-(void)updateDeviceScreenMode:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    /**
     * LSScreenDisplayModeHorizontal, Horizontal screen
     * LSScreenDisplayModeVertical，Vertical screen
     */
    [self.lsBleManager updateScreenMode:LSScreenDisplayModeHorizontal
                              forDevice:lsDevice.broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger code)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDevicePageSequence:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    //Set the page display order
    LSDDisplayPage *page=[[LSDDisplayPage alloc] init];
    [page addPage:LSDevicePageTime]; //the first page:time
    [page addPage:LSDevicePageCalories];
    [page addPage:LSDevicePageDistance];
    [page addPage:LSDevicePageRunning];
    [page addPage:LSDevicePageHeartRate];
    [page addPage:LSDevicePageStep];
    
    [self.lsBleManager updatePageSequence:page forDevice:lsDevice.broadcastId
                                 andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceHeartRateDetectionMode:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    /**
     * LSHRDetectionModeTurnOn,enable heart rate detection
     * LSHRDetectionModeTurnOff,close heart rate detection
     * LSHRDetectionModeIntelligent,use intelligent detection mode
     */
    [self.lsBleManager updateHeartRateDetectionMode:LSHRDetectionModeIntelligent
                                          forDevice:lsDevice.broadcastId
                                           andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}
-(void)updateDeviceTimeFormat:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    [self.lsBleManager updateTimeFormat:LSDeviceTimeFormat12
                              forDevice:lsDevice.broadcastId
                               andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
}

-(void)updateDeviceDistanceUnits:(LSDeviceInfo *)lsDevice
{
    if(![self isDeviceConnected:lsDevice.broadcastId])
    {
        return ;
    }
    [self.lsBleManager updateDistanceUnits:LSDistanceUnitMetricSystem
                                 forDevice:lsDevice.broadcastId
                                  andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         if(isSuccess)
         {
             //TODO update success
         }
         else
         {
             //TODO update failure
         }
     }];
    LSSphygmometerData *bpData;
    bpData.utc;//format utc to timestamp
    
    //Update device time，during the binding process
    lsDevice.syncUtc=0;//TODO
    [[LSBluetoothManager defaultManager] pairingWithDevice:lsDevice delegate:self];
    
    //Update device time，during the data syncing process
    lsDevice.syncUtc=0;//TODO
    [[LSBluetoothManager defaultManager] addMeasureDevice:lsDevice result:^(LSAccessCode result) {
        
    }];
    
}



@end
