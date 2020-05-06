//
//  DataFormatConverter.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/20.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "DataFormatConverter.h"
#import <objc/runtime.h>

static NSString *kProtocolKitchen=@"KITCHEN_SCALE";
static NSString *kProtocolA4=@"A4";
static NSString *kProtocolGenericFat=@"GENERIC_FAT";


static NSUInteger devicePower;

@implementation DataFormatConverter{
}


+(LSDeviceType)stringToDeviceType:(id)type
{
    int tempType=[type intValue];
    LSDeviceType tempDeviceType;
    switch (tempType)
    {
        case LSDeviceTypeWeightScale: tempDeviceType=LSDeviceTypeWeightScale;  break;
        case LSDeviceTypeFatScale:tempDeviceType=LSDeviceTypeFatScale; break;
        case LSDeviceTypePedometer:tempDeviceType=LSDeviceTypePedometer;break;
        case LSDeviceTypeBloodPressureMeter:tempDeviceType=LSDeviceTypeBloodPressureMeter;break;
        case LSDeviceTypeHeightMeter:tempDeviceType=LSDeviceTypeHeightMeter;break;
        case LSDeviceTypeKitchenScale:tempDeviceType=LSDeviceTypeKitchenScale;break;
        default:
            break;
    }
    return tempDeviceType;
}

+(LSDeviceInfo *)convertedToLSDeviceInfo:(BleDevice *)bleDevice
{
    if (bleDevice)
    {
        LSDeviceInfo *lsDevice=[[LSDeviceInfo alloc] init];
        lsDevice.deviceId=bleDevice.deviceID;
        lsDevice.broadcastId=bleDevice.broadcastID;
        lsDevice.password=bleDevice.password;
        lsDevice.protocolType=bleDevice.protocolType;
        lsDevice.deviceType=[self stringToDeviceType:bleDevice.deviceType];
        lsDevice.deviceUserNumber=[bleDevice.deviceUserNumber integerValue];
        lsDevice.peripheralIdentifier=bleDevice.identifier;
        lsDevice.deviceName=bleDevice.deviceName;
        lsDevice.firmwareVersion=bleDevice.firmwareVersion;
        lsDevice.hardwareVersion=bleDevice.hardwareVersion;
        lsDevice.modelNumber=bleDevice.modelNumber;
        return lsDevice;
    }
    else return nil;
}

+(UIImage *)getDeviceImageViewWithType:(LSDeviceType)deviceType
{
    UIImage *image=nil;
    if(deviceType==LSDeviceTypeFatScale)
    {
        image=[UIImage imageNamed:@"fat_scale.png"];
    }
    else if(deviceType==LSDeviceTypeBloodPressureMeter)
    {
        image=[UIImage imageNamed:@"blood_pressure.png"];
    }
    else if(deviceType==LSDeviceTypePedometer)
    {
        image=[UIImage imageNamed:@"pedometer.png"];
    }
    else if (deviceType==LSDeviceTypeKitchenScale)
    {
        image=[UIImage imageNamed:@"kitchen_scale.png"];
    }
    else if (deviceType==LSDeviceTypeHeightMeter)
    {
        image=[UIImage imageNamed:@"height.png"];
    }
    else if (deviceType==LSDeviceTypeWeightScale || deviceType==LSDeviceTypeFatScale)
    {
        image=[UIImage imageNamed:@"weight_scale.png"];
    }
    else
    {
        image=[UIImage imageNamed:@"unknown.jpg"];
    }
    return image;
    
}

+(NSString *)getDeviceNameForNormalBroadcasting:(NSString *)deviceName
{
    if(deviceName.length)
    {
        if(deviceName.length<=5)
        {
            return deviceName;
        }
        else return deviceName=[deviceName substringToIndex:5];
    }
    else return nil;
    
}

+(BOOL)isNotRequiredPairDevice:(NSString *)protocol
{
    if(protocol.length)
    {
        if([protocol isEqualToString:@"A2"]
           ||[protocol isEqualToString:@"A3"]
           ||[protocol isEqualToString:@"A3.1"])
        {
            return NO;
        }
        else return YES;
        
    }
    else return YES;
}

+(NSAttributedString *)parseObjectDetailInAttributedString:(id)obj recordNumber:(NSUInteger)number
{
    if(!obj)
    {
        return nil;
    }
    else
    {
        NSMutableString * deviceDetailsMsg=[[NSMutableString alloc] init];
        
        NSMutableDictionary *propertyDictionary = [[NSMutableDictionary alloc] init];
        unsigned int numberOfProperties=0;
        
        objc_property_t *properties=class_copyPropertyList([obj class], &numberOfProperties);
    
        if(number>0)
        {
            NSString *titleHtmlStr=[NSString stringWithFormat:@"</br><h3><font color='#dc143c' size='5'>Record Number : %ld</font></h3>",(unsigned long)number];
            [deviceDetailsMsg appendString:titleHtmlStr];
        }
        else
        {
            NSString *titleHtmlStr=[NSString stringWithFormat:@"<h5><font color='#800080' size='4'>...............Weight Append Data...........</font></h5>"];
            [deviceDetailsMsg appendString:titleHtmlStr];
        }
        
        for(int i=0;i<numberOfProperties; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName=[NSString stringWithUTF8String:property_getName(property)];
            id propValue=[obj valueForKey:propertyName];
            if(propValue)
            {
                [propertyDictionary setObject:propValue forKey:propertyName];
                NSString *msg=[NSString stringWithFormat:@"<font size='5'>%@ : %@</font></br>",propertyName,propValue];
                [deviceDetailsMsg appendString:msg];
            }
            else [propertyDictionary setObject:@"null" forKey:propertyName];
        }
        
        
        NSAttributedString *attributedString=[[NSAttributedString alloc] initWithData:[deviceDetailsMsg dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        return attributedString;
    }

}


+(LSProductUserInfo *)getProductUserInfo:(DeviceUser *)deviceUser
{
//    NSLog(@"device user info %@",[DataFormatConverter parseObjectDetailInDictionary:deviceUser]);
    
    if(!deviceUser.birthday)
    {
        NSLog(@"birthday is nil .......");
    }
    
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear) fromDate:deviceUser.birthday];
    
    NSInteger year=[dateComponents year];
    
    dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger currentYear=[dateComponents year];
    
    LSProductUserInfo *userInfo=[[LSProductUserInfo alloc] init];
    userInfo.height=[deviceUser.height doubleValue];
    userInfo.goalWeight=[deviceUser.userprofiles.weightTarget integerValue];
    userInfo.age=currentYear-year;
    
    if([deviceUser.gender isEqualToString:@"Male"])
    {
        userInfo.gender=LSUserGenderMale;
    }
    else userInfo.gender=LSUserGenderFemale;
    
    if([deviceUser.userprofiles.weightUnit isEqualToString:@"Lb"])
    {
        userInfo.unit=LSMeasurementUnitLb;
    }
    else if([deviceUser.userprofiles.weightUnit isEqualToString:@"St"])
    {
        userInfo.unit=LSMeasurementUnitSt;
    }
    else userInfo.unit=LSMeasurementUnitKg;
    
    userInfo.athleteLevel=[deviceUser.athleteLevel integerValue];
    
    return userInfo;
}

+(LSPedometerAlarmClock *)getPedometerAlarmClock:(DeviceAlarmClock *)deviceAlarmClock
{
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:deviceAlarmClock.alarmClockTime];
    
    NSInteger hour=[dateComponents hour];
    NSInteger minute=[dateComponents minute];
    
    LSPedometerAlarmClock *alarmClock=[[LSPedometerAlarmClock alloc] init];
    alarmClock.switch1=1;
    alarmClock.day1=[self getAlarmClockDayCount:deviceAlarmClock];
    alarmClock.hour1=hour;
    alarmClock.minute1=minute;
    
    return alarmClock;
}

+(LSPedometerUserInfo *)getPedometerUserInfo:(DeviceUser *)deviceUser
{
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitYear) fromDate:deviceUser.birthday];
    
    NSInteger year=[dateComponents year];
    
    NSLog(@"user birthday %ld",year);
    
    dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute| NSCalendarUnitYear) fromDate:[NSDate date]];
    NSInteger currentYear=[dateComponents year];
    
    
    LSPedometerUserInfo *puserInfo=[[LSPedometerUserInfo alloc] init];
    puserInfo.height=[deviceUser.height doubleValue];
    puserInfo.weight=[deviceUser.weight doubleValue];
    puserInfo.age=currentYear-year;
    
    NSLog(@"currentYear= %ld",currentYear);
    
    if([deviceUser.userprofiles.weekStart isEqualToString:@"Sunday"])
    {
        puserInfo.weekStart=1;
    }
    else puserInfo.weekStart=2;
    
    if([deviceUser.userprofiles.hourFormat isEqualToString:@"12"])
    {
        puserInfo.timeformat=LSDeviceTimeFormat12;
    }
    else puserInfo.timeformat=LSDeviceTimeFormat24;
    
    if ([deviceUser.userprofiles.distanceUnit isEqualToString:@"Mile"])
    {
        puserInfo.distanceUnit=LSDistanceUnitMetricSystem;
    }
    else puserInfo.distanceUnit=LSDistanceUnitBritishSystem;
    
    puserInfo.targetStep=[deviceUser.userprofiles.weekTargetSteps integerValue];
    puserInfo.targetType=LSWeekTargetStep;
    return puserInfo;
}

+(NSArray*)getRepeatWeekDays:(DeviceAlarmClock *)deviceAlarmClock
{
    NSMutableArray *days=[[NSMutableArray alloc] initWithCapacity:7];
    
    if([deviceAlarmClock.monday boolValue])
    {
        [days addObject:@(LSWeekMonday)];
    }
    if([deviceAlarmClock.tuesday boolValue])
    {
        [days addObject:@(LSWeekTuesday)];
    }
    if([deviceAlarmClock.wednesday boolValue])
    {
        [days addObject:@(LSWeekWednesday)];
    }
    if([deviceAlarmClock.thursday boolValue])
    {
        [days addObject:@(LSWeekThursday)];
    }
    
    if([deviceAlarmClock.friday boolValue])
    {
        [days addObject:@(LSWeekFriday)];
    }
    if([deviceAlarmClock.saturday boolValue])
    {
        [days addObject:@(LSWeekSaturday)];
    }
    if([deviceAlarmClock.sunday boolValue])
    {
        [days addObject:@(LSWeekSunday)];
    }
    return days;
}

+(int)getAlarmClockDayCount:(DeviceAlarmClock *)deviceAlarmClock
{
    int dayCount=0;
    if(deviceAlarmClock)
    {
        if([deviceAlarmClock.monday boolValue])
        {
            dayCount +=MONDAY;
        }
        if([deviceAlarmClock.tuesday boolValue])
        {
            dayCount +=TUESDAY;
        }
        if([deviceAlarmClock.wednesday boolValue])
        {
            dayCount +=WEANSDAY;
        }
        if([deviceAlarmClock.thursday boolValue])
        {
            dayCount +=THURSDAY;
        }
        
        if([deviceAlarmClock.friday boolValue])
        {
            dayCount +=FRIDAY;
        }
        if([deviceAlarmClock.saturday boolValue])
        {
            dayCount +=SATADAY;
        }
        if([deviceAlarmClock.sunday boolValue])
        {
            dayCount +=SUNDAY;
        }
    }
    return dayCount;
}

+(NSString *)parseObjectDetailInStringValue:(id)obj
{
    if(!obj)
    {
        return nil;
    }
    else
    {
        NSMutableString * deviceDetailsMsg=[[NSMutableString alloc] init];
        [deviceDetailsMsg appendString:@"\n"];
        NSMutableDictionary *propertyDictionary = [[NSMutableDictionary alloc] init];
        unsigned int numberOfProperties=0;
        
        objc_property_t *properties=class_copyPropertyList([obj class], &numberOfProperties);
        
        for(int i=0;i<numberOfProperties; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName=[NSString stringWithUTF8String:property_getName(property)];
            id propValue=[obj valueForKey:propertyName];
            if(propValue)
            {
                [propertyDictionary setObject:propValue forKey:propertyName];
                NSString *msg=[NSString stringWithFormat:@"%@ : %@ \n",propertyName,propValue];
                [deviceDetailsMsg appendString:msg];
            }
            else [propertyDictionary setObject:@"null" forKey:propertyName];
        }
        return deviceDetailsMsg;
    }
}


+(NSDictionary *)parseObjectDetailInDictionary:(id)obj
{
    if(!obj)
    {
        return nil;
    }
    else
    {
        NSMutableString * deviceDetailsMsg=[[NSMutableString alloc] init];
        
        NSMutableDictionary *propertyDictionary = [[NSMutableDictionary alloc] init];
        unsigned int numberOfProperties=0;
        
        objc_property_t *properties=class_copyPropertyList([obj class], &numberOfProperties);
        
        for(int i=0;i<numberOfProperties; i++)
        {
            objc_property_t property = properties[i];
            NSString *propertyName=[NSString stringWithUTF8String:property_getName(property)];
            id propValue=[obj valueForKey:propertyName];
            if(propValue)
            {
                [propertyDictionary setObject:propValue forKey:propertyName];
                NSString *msg=[NSString stringWithFormat:@"%@ : %@ \n",propertyName,propValue];
                [deviceDetailsMsg appendString:msg];
            }
            else [propertyDictionary setObject:@"null" forKey:propertyName];
        }
        return propertyDictionary;
    }
}

/**
 * 解析血压计测量数据
 */
+(NSString *)parseBloodPressureMeterMeasureData:(LSSphygmometerData *)data
{
    NSMutableArray *strMap=[[NSMutableArray alloc] init];
    [strMap addObject:[NSString stringWithFormat:@"#Blood Pressure Data"]];
    [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",data.measureTime]];
    [strMap addObject:[NSString stringWithFormat:@"Utc: %llx ",data.utc]];
    [strMap addObject:[NSString stringWithFormat:@"Systolic: %@ ",@(data.systolic)]];
    [strMap addObject:[NSString stringWithFormat:@"Pluse Rate: %@ ",@(data.pluseRate)]];
    [strMap addObject:[NSString stringWithFormat:@"Diastolic: %@ ",@(data.diastolic)]];
    if(data.measurementStatus){
        [strMap addObject:[NSString stringWithFormat:@"status { "]];
        [strMap addObject:[NSString stringWithFormat:@"  isBodyMovement: %@ ",@(data.measurementStatus.bodyMovement)]];
        [strMap addObject:[NSString stringWithFormat:@"  isCuffFit: %@ ",@(data.measurementStatus.cuffFit)]];
        [strMap addObject:[NSString stringWithFormat:@"  isIrregularPulse: %@ ",@(data.measurementStatus.irregularPulse)]];
        [strMap addObject:[NSString stringWithFormat:@"  pulseRateRange: %@ ",@(data.measurementStatus.pulseRateRange)]];
        [strMap addObject:[NSString stringWithFormat:@"  measurementPosition: %@ ",@(data.measurementStatus.measurementPosition)]];
        [strMap addObject:[NSString stringWithFormat:@"}"]];
    }
    return strMap.copy;
}

/**
 * 解析秤测量数据
 */
+(NSArray *)parseScaleMeasureData:(LSDeviceMeasureData *)data
{
    NSMutableArray *strMap=[[NSMutableArray alloc] init];
    if([data isKindOfClass:[LSWeightData class]])
    {
        [strMap addObject:[NSString stringWithFormat:@"#ScaleWeight Data"]];
        LSWeightData *weightData=(LSWeightData *)data;
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",weightData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"UserNumber: %@ ",@(weightData.userNumber)]];
        [strMap addObject:[NSString stringWithFormat:@"Weight: %@ ",@(weightData.weight)]];
        [strMap addObject:[NSString stringWithFormat:@"Resistance2: %@",@(weightData.resistance_2)]];
        [strMap addObject:[NSString stringWithFormat:@"Resistance1: %@",@(weightData.resistance_1)]];
        [strMap addObject:[NSString stringWithFormat:@"deviceId:%@",weightData.deviceId]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(weightData.utc)]];
        [strMap addObject:[NSString stringWithFormat:@"isRealtimeData:%@",@(weightData.isRealtimeData)]];

    }
    else if ([data isKindOfClass:[LSWeightAppendData class]])
    {
        [strMap addObject:[NSString stringWithFormat:@"#ScaleWeight AppendData"]];

        LSWeightAppendData *fatData=(LSWeightAppendData *)data;
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",fatData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"UserNumber: %@ ",@(fatData.userNumber)]];
        [strMap addObject:[NSString stringWithFormat:@"BasalMetabolism: %@ ",@(fatData.basalMetabolism)]];
        [strMap addObject:[NSString stringWithFormat:@"FAT:%@",@(fatData.bodyFatRatio)]];
        [strMap addObject:[NSString stringWithFormat:@"TBW:%@",@(fatData.bodywaterRatio)]];
        [strMap addObject:[NSString stringWithFormat:@"MUS:%@",@(fatData.muscleMassRatio)]];
        [strMap addObject:[NSString stringWithFormat:@"BONE:%@",@(fatData.boneDensity)]];
    }
 
    return strMap;
}


/**
 * 解析手环测量数据
 */
+(NSArray *)parseDeviceMeasureData:(LSDeviceData *)data
{
    NSMutableArray *strMap=[[NSMutableArray alloc] init];
    if([data.dataObj isKindOfClass:[LSPedometerData class]])
    {
        [strMap addObject:@"#WalkStep Data"];
        //手环步数、运动距离测量数据
        LSPedometerData *pedData=(LSPedometerData *)data.dataObj;
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",pedData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"Step Number: %@ ",@(pedData.walkSteps)]];
        [strMap addObject:[NSString stringWithFormat:@"Calories: %@ ",@(pedData.calories)]];
        [strMap addObject:[NSString stringWithFormat:@"Distance: %@ ",@(pedData.distance)]];
        [strMap addObject:[NSString stringWithFormat:@"Exercise Time:%@",@(pedData.exerciseTime)]];
        [strMap addObject:[NSString stringWithFormat:@"Voltage: %@ ",@(pedData.voltage)]];
        [strMap addObject:[NSString stringWithFormat:@"Battery Percent: %@%%",@(pedData.batteryPercent)]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(pedData.utc)]];
        devicePower=pedData.batteryPercent;
    }
    else if([ data.dataObj isKindOfClass:[NSArray class]])
    {
        NSString *cmd=[NSString stringWithFormat:@"Device Packet:%lX",(unsigned long)data.dataType];
        NSArray *datalist=(NSArray *)data.dataObj;
        if(data.dataType == LSPacketCommand82 || data.dataType ==LSPacketCommand8B
           || data.dataType == LSPacketCommandCA || data.dataType == LSPacketCommandC9
           || data.dataType == LSPacketDataPerhourSteps || data.dataType == LSPacketDataDailySteps)
        {
            [strMap addObject:[NSString stringWithFormat:@"#WalkStep Data,Count:%@",@(datalist.count)]];
            NSUInteger index=0;
            for(LSPedometerData *pedData in datalist)
            {
                index++;
                [strMap addObject:[NSString stringWithFormat:@"%@;          index:%@",cmd,@(index)]];
                [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@",pedData.measureTime]];
                [strMap addObject:[NSString stringWithFormat:@"Step Number: %@",@(pedData.walkSteps)]];
                [strMap addObject:[NSString stringWithFormat:@"Calories: %@",@(pedData.calories)]];
                [strMap addObject:[NSString stringWithFormat:@"Distance: %@",@(pedData.distance)]];
                [strMap addObject:[NSString stringWithFormat:@"Voltage: %@",@(pedData.voltage)]];
                [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(pedData.utc)]];
                [strMap addObject:[NSString stringWithFormat:@"Battery Percent: %@%%",@(pedData.batteryPercent)]];
                [strMap addObject:@"\n"];
                devicePower=pedData.batteryPercent;
            }
        }
        else if(data.dataType == LSPacketCommand83 || data.dataType==LSPacketCommandCE)
        {
            [strMap addObject:[NSString stringWithFormat:@"#Sleep Data,Count:%@",@(datalist.count)]];

            NSMutableString *sleepStatus=[[NSMutableString alloc] init];
            for(LSUSleepData *sData in datalist)
            {
                [sleepStatus appendFormat:@"%@,",sData.sleepLevel];
            }
            LSUSleepData *sleepData=(LSUSleepData *)[datalist objectAtIndex:0];
            [strMap addObject:cmd];
            [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@",sleepData.measureTime]];
            [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(sleepData.utc)]];
            [strMap addObject:[NSString stringWithFormat:@"Sleep Status: %@",sleepStatus]];
        }
    }
   
    else if ([ data.dataObj isKindOfClass:[LSUHearRate class]])
    {
       if ([ data.dataObj isKindOfClass:[LSUSportHeartRate class]])
        {
            //手环运动心率数据
            LSUSportHeartRate *obj=(LSUSportHeartRate *) data.dataObj;
            [strMap addObject:@"#Movement HeartRate Data"];
            [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",obj.measureTime]];
            [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(obj.utc)]];
            NSMutableString *mutableStr=[[NSMutableString alloc] init];
            if(obj.heartRateList.count)
            {
                for(NSNumber *value in obj.heartRateList)
                {
                    [mutableStr appendFormat:@"%@,",value];
                }
            }
            [strMap addObject:[NSString stringWithFormat:@"Soprt HeartRates: %@ ",mutableStr]];
        }
       else{
           //手环心率测量数据
           LSUHearRate *obj=(LSUHearRate *) data.dataObj;
           [strMap addObject:[NSString stringWithFormat:@"#HeartRate Data,Count:%@",@(obj.heartRateList.count)]];
           [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",obj.measureTime]];
           [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(obj.utc)]];
           NSMutableString *mutableStr=[[NSMutableString alloc] init];
           if(obj.heartRateList.count)
           {
               for(NSNumber *value in obj.heartRateList)
               {
                   [mutableStr appendFormat:@"%@,",value];
               }
           }
           [strMap addObject:[NSString stringWithFormat:@"Heart Rates: %@ ",mutableStr]];
       }
    }
    else if ([ data.dataObj isKindOfClass:[LSUSleepData class]])
    {
        //手环睡眠测量数据
        LSUSleepData *sleepData=(LSUSleepData *) data.dataObj;
        [strMap addObject:[NSString stringWithFormat:@"#Sleep Data,Count:%@",@(sleepData.statusList.count)]];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",sleepData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(sleepData.utc)]];
        NSMutableString *mutableStr=[[NSMutableString alloc] init];
        if(sleepData.statusList.count)
        {
            for(NSNumber *value in sleepData.statusList)
            {
                [mutableStr appendFormat:@"%@,",value];
            }
        }
        [strMap addObject:[NSString stringWithFormat:@"Sleep Values: %@ ",mutableStr]];
        
    }
    else if ([ data.dataObj isKindOfClass:[LSUCaloriesData class]])
    {
        //手环卡路里测量数据
        LSUCaloriesData *caloriesData=(LSUCaloriesData *) data.dataObj;
        [strMap addObject:[NSString stringWithFormat:@"#Movement Calories Data,Count:%@",@(caloriesData.calorieList.count)]];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",caloriesData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(caloriesData.utc)]];
        NSMutableString *mutableStr=[[NSMutableString alloc] init];
        if(caloriesData.calorieList.count)
        {
            for(NSNumber *value in caloriesData.calorieList)
            {
                [mutableStr appendFormat:@"%@,",value];
            }
        }
        NSString *msg=[self parseObjectDetailInStringValue:caloriesData];
        [[LSBluetoothManager defaultManager] logMessage:msg];
        [strMap addObject:[NSString stringWithFormat:@"Calories Values: %@ ",mutableStr]];
    }
    
    else if ([ data.dataObj isKindOfClass:[LSUHRSection class]])
    {
        //手环心率区间测量数据
        LSUHRSection *obj=(LSUHRSection *) data.dataObj;
        [strMap addObject:@"#HeartRate Section Data"];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",obj.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(obj.utc)]];
        [strMap addObject:[NSString stringWithFormat:@"HeartRate Section1: %@ ",@(obj.hrSectionTime1)]];
        [strMap addObject:[NSString stringWithFormat:@"HeartRate Section2: %@ ",@(obj.hrSectionTime2)]];
        [strMap addObject:[NSString stringWithFormat:@"HeartRate Section3: %@ ",@(obj.hrSectionTime3)]];
    }
    else if ([ data.dataObj isKindOfClass:[LSUSportData class]])
    {
        //手环运动数据
        LSUSportData *obj=(LSUSportData *) data.dataObj;
        [strMap addObject:@"#Movement Data"];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",obj.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"Sport Mode: %@ ",@(obj.sportMode)]];
        [strMap addObject:[NSString stringWithFormat:@"Sport SubMode: %@ ",@(obj.sportSubMode)]];
        [strMap addObject:[NSString stringWithFormat:@"Time: %@ ",@(obj.time)]];
        [strMap addObject:[NSString stringWithFormat:@"Step: %@ ",@(obj.step)]];
        [strMap addObject:[NSString stringWithFormat:@"Calories: %@ ",@(obj.calories)]];
        [strMap addObject:[NSString stringWithFormat:@"Max Heart Rate: %@ ",@(obj.maxHR)]];
        [strMap addObject:[NSString stringWithFormat:@"Avg Heart Rate: %@ ",@(obj.avgHR)]];
        [strMap addObject:[NSString stringWithFormat:@"Max Step Freq: %@ ",@(obj.maxStepFreq)]];
        [strMap addObject:[NSString stringWithFormat:@"Avg Step Freq: %@ ",@(obj.avgStepFreq)]];
        [strMap addObject:[NSString stringWithFormat:@"Distance:%@",@(obj.distance)]];
        if(obj.stepFreqList.count){
            [strMap addObject:@"Sport Status {"];
            for(LSStepFreqInfo *status in obj.stepFreqList){
                [strMap addObject:[NSString stringWithFormat:@"status=%@,utc=%@ ",@(status.status),@(status.utc)]];
            }
            [strMap addObject:@"}"];
        }
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(obj.utc)]];
        NSString *msg=[self parseObjectDetailInStringValue:obj];
        [[LSBluetoothManager defaultManager] logMessage:msg];
    }
    else if ([ data.dataObj isKindOfClass:[LSSportNotify class]])
    {
        //手环运动状态
        LSSportNotify *obj=(LSSportNotify *) data.dataObj;
        [strMap addObject:@"#Sport Notify Data"];
        [strMap addObject:[NSString stringWithFormat:@"Notify Type: %@ ",@(obj.type)]];
        [strMap addObject:[NSString stringWithFormat:@"Sport Mode: %@ ",@(obj.sportMode)]];
        [strMap addObject:[NSString stringWithFormat:@"State: %@ ",@(obj.state)]];
    }
    else if ([data.dataObj isKindOfClass:[LSDeviceHeartbeatData class]])
    {
        LSDeviceHeartbeatData *heartbeatData=(LSDeviceHeartbeatData *)data.dataObj;
        [strMap addObject:@"#Heartbeat Data"];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",heartbeatData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(heartbeatData.utc)]];
        [strMap addObject:[NSString stringWithFormat:@"current count=%@",@(heartbeatData.currentSendDataCount)]];
        [strMap addObject:[NSString stringWithFormat:@"unsent count=%@",@(heartbeatData.unsentDataCount)]];
        for(LSHeartbeatData *heartbeat in heartbeatData.heartbeatDatas)
        {
            [strMap addObject:[NSString stringWithFormat:@"timeOffset=%@,value=%@ ",@(heartbeat.timeOffset),@(heartbeat.value)]];
        }
        NSLog(@"Heartbeat Data log :%@",strMap);
    }
    else if([data.dataObj isKindOfClass:[LSMoodbeamData class]]){
        LSMoodbeamData *moodbeamData=(LSMoodbeamData *)data.dataObj;
        [strMap addObject:@"#Moodbeam Data"];
        [strMap addObject:[NSString stringWithFormat:@"MeasureTime: %@ ",moodbeamData.measureTime]];
        [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(moodbeamData.utc)]];
        [strMap addObject:[NSString stringWithFormat:@"length: %@",@(moodbeamData.length)]];
        [strMap addObject:[NSString stringWithFormat:@"current count=%@",@(moodbeamData.count)]];
        [strMap addObject:[NSString stringWithFormat:@"unsent count=%@",@(moodbeamData.remainingAmount)]];
        for(LSMoodRecord *record in moodbeamData.records){
            [strMap addObject:[NSString stringWithFormat:@"utc: %@",@(record.utc)]];
            [strMap addObject:[NSString stringWithFormat:@"value: %@",@(record.value)]];
        }
    }
    else if([data.dataObj isKindOfClass:[LSUSwimData class]]){
        //游泳模式运动数据
        LSUSwimData *swimData=(LSUSwimData*)data.dataObj;
        [strMap addObject:@"#Swimming Data"];
        [strMap addObject:[NSString stringWithFormat:@"startUtc: %@",@(swimData.startUTC)]];
        [strMap addObject:[NSString stringWithFormat:@"endUtc: %@",@(swimData.endUTC)]];
        [strMap addObject:[NSString stringWithFormat:@"number of swimming=%@",@(swimData.laps)]];
        [strMap addObject:[NSString stringWithFormat:@"time of swimming=%@",@(swimData.time)]];
        [strMap addObject:[NSString stringWithFormat:@"calories=%@",@(swimData.calories)]];
    }
    else
    {
        [strMap addObject:@"#Undefine Data"];
        [strMap addObject:[NSString stringWithFormat:@"%@",
                           [self parseObjectDetailInStringValue:data]]];
        
    }

    return strMap;
}

#pragma mark - private methods
//保留一位小数
+(NSString *)doubleValueWithOneDecimalFormat:(double)weightValue
{
    
    NSNumberFormatter *doubleValueFormatter=[[NSNumberFormatter alloc] init];
    [doubleValueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [doubleValueFormatter setPaddingPosition:NSNumberFormatterPadAfterSuffix];
    [doubleValueFormatter setFormatWidth:1];
    [doubleValueFormatter setMaximumFractionDigits:1];
    NSString *lbValueStr=[doubleValueFormatter stringFromNumber:[NSNumber numberWithDouble:weightValue]];
    return lbValueStr;
    
}

+(NSString *)doubleValueWithTwoDecimalFormat:(double)weightValue
{
    
    NSNumberFormatter *doubleValueFormatter=[[NSNumberFormatter alloc] init];
    [doubleValueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [doubleValueFormatter setPaddingPosition:NSNumberFormatterPadAfterSuffix];
    [doubleValueFormatter setFormatWidth:2];
    [doubleValueFormatter setMaximumFractionDigits:2];
    NSString *lbValueStr=[doubleValueFormatter stringFromNumber:[NSNumber numberWithDouble:weightValue]];
    return lbValueStr;
    
}

// Input is without the # ie : white = FFFFFF
+(UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned int hex;
    [[NSScanner scannerWithString:hexString] scanHexInt:&hex];
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


+(NSMutableString*) timeLeftSinceDate: (NSDate *) dateT
{
    
    NSMutableString *timeLeft = [[NSMutableString alloc]init];
    
    NSTimeInterval endTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:endTimeInterval];
    
    NSInteger seconds = [endDate timeIntervalSinceDate:dateT];
    
    NSInteger days = (int) (floor(seconds / (3600 * 24)));
    if(days) seconds -= days * 3600 * 24;
    
    NSInteger hours = (int) (floor(seconds / 3600));
    if(hours) seconds -= hours * 3600;
    
    NSInteger minutes = (int) (floor(seconds / 60));
    if(minutes)
        seconds -= minutes * 60;
    
    if(days) {
        [timeLeft appendString:[NSString stringWithFormat:@"%ld Days", (long)days]];
    }
    
    if(hours) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ld h ", (long)hours]];
    }
    
    if(minutes) {
        [timeLeft appendString: [NSString stringWithFormat: @"%ld min ",(long)minutes]];
    }
    
    if(seconds) {
        [timeLeft appendString:[NSString stringWithFormat: @"%ld s ", (long)seconds]];
    }
    
    return timeLeft;
}

-(void)test{
   
    
    
    
    
}

+(NSUInteger)currentDevicePower{
    return devicePower;
}


@end
