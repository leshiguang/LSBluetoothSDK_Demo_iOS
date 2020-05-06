//
//  LSDeviceSettingItem.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/8.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "LSDeviceSettingItem.h"

@interface LSDeviceSettingItem()

@end


@implementation LSDeviceSettingItem

-(instancetype)initWithCategory:(LSDeviceSettingCategory)category
{
    if(self=[super init])
    {
        _type=category;
        _itemValues=[[NSMutableDictionary alloc] initWithCapacity:10];
        switch (category) {
            case DSCategoryWeekStart:
            {
                _title=title_week_start;
                [_itemValues setObject:@(2) forKey:item_week_start_mon];
                [_itemValues setObject:@(1) forKey:item_week_start_sun];
            }break;
            case DSCategoryTimeFormat:{
                _title=title_time_format;
                [_itemValues setObject:@(LSDeviceTimeFormat12) forKey:item_time_format_12];
                [_itemValues setObject:@(LSDeviceTimeFormat24) forKey:item_time_format_24];
            }break;
            case DSCategoryDistanceUnit:{
                _title=title_distance_unit;
                [_itemValues setObject:@(LSDistanceUnitMetricSystem) forKey:item_distance_unit_k];
                [_itemValues setObject:@(LSDistanceUnitBritishSystem) forKey:item_distance_unit_m];
            }break;
            case DSCategoryScreenMode:{
                _title=title_screen_mode;
                [_itemValues setObject:@(LSScreenDisplayModeHorizontal) forKey:item_screen_mode_h];
                [_itemValues setObject:@(LSScreenDisplayModeVertical) forKey:item_screen_mode_v];
            }break;
            case DSCategoryWearingMode:{
                _title=title_wearing_mode;
                [_itemValues setObject:@(LSWearingStyleLeftHand) forKey:item_wearing_mode_l];
                [_itemValues setObject:@(LSWearingStyleRightHand) forKey:item_wearing_mode_r];
            }break;
            case DSCategoryHeartRateDetect:{
                _title=title_hr_detect_mode;
                [_itemValues setObject:@(LSHRDetectionModeTurnOn) forKey:item_hr_detect_open];
                [_itemValues setObject:@(LSHRDetectionModeTurnOff) forKey:item_hr_detect_close];
            }break;
            case DSCategoryDialpaceMode:{
                _title=title_dialpeace_mode;
                [_itemValues setObject:@(LSDialPeaceStyle1) forKey:item_dialpeace_1];
                [_itemValues setObject:@(LSDialPeaceStyle2) forKey:item_dialpeace_2];
                [_itemValues setObject:@(LSDialPeaceStyle3) forKey:item_dialpeace_3];
                [_itemValues setObject:@(LSDialPeaceStyle4) forKey:item_dialpeace_4];
                [_itemValues setObject:@(LSDialPeaceStyle5) forKey:item_dialpeace_5];
                [_itemValues setObject:@(LSDialPeaceStyle6) forKey:item_dialpeace_6];
                [_itemValues setObject:@(LSDialPeaceStyle7) forKey:item_dialpeace_7];
                [_itemValues setObject:@(LSDialPeaceStyle8) forKey:item_dialpeace_8];
                [_itemValues setObject:@(LSDialPeaceStyle9) forKey:item_dialpeace_9];
                [_itemValues setObject:@(LSDialPeaceStyle10) forKey:item_dialpeace_10];
            }break;
            case DSCategoryAutoDiscern:{
                _title=title_auto_discern;
                [_itemValues setObject:@(LSAutomaticSportstypeWalking) forKey:item_auto_discern_walk];
                [_itemValues setObject:@(LSAutomaticSportstypeRunning) forKey:item_auto_discern_run];
                [_itemValues setObject:@(LSAutomaticSportstypeCycling) forKey:item_auto_discern_cyc];
            }break;
            case DSCategoryTakePictures:{
                _title=title_take_pictures;
                [_itemValues setObject:@(0x00) forKey:item_take_pictures_enter];
                [_itemValues setObject:@(0x01) forKey:item_take_pictures_exits];
            }break;
            case DSCategoryWeekTarget:{
                _title=title_week_target_step;
            }break;
            case DSCategoryCustomPages:{
                _title=title_custom_pages;
                [_itemValues setObject:@(LSDevicePageTime) forKey:page_time];
                [_itemValues setObject:@(LSDevicePageStep) forKey:page_step];
                [_itemValues setObject:@(LSDevicePageCalories) forKey:page_calories];
                [_itemValues setObject:@(LSDevicePageDistance) forKey:page_distance];
                [_itemValues setObject:@(LSDevicePageHeartRate) forKey:page_heartRate];
                [_itemValues setObject:@(LSDevicePageRunning) forKey:page_running];
                [_itemValues setObject:@(LSDevicePageWalking) forKey:page_walking];
                [_itemValues setObject:@(LSDevicePageCycling) forKey:page_cycling];
                [_itemValues setObject:@(LSDevicePageDailyData) forKey:page_daily_data];
                [_itemValues setObject:@(LSDevicePageStopwatch) forKey:page_stop_watch];
                [_itemValues setObject:@(LSDevicePageWeather) forKey:page_weather];
                [_itemValues setObject:@(LSDevicePageAerobicExercise12) forKey:page_aerobic_exercise_12];
                [_itemValues setObject:@(LSDevicePageMusicPlayer) forKey:page_music_player];
                [_itemValues setObject:@(LSDevicePagePhoneLocation) forKey:page_phone_location];
                [_itemValues setObject:@(LSDevicePageDeviceSetting) forKey:page_device_setting];
                [_itemValues setObject:@(LSDevicePageAlipay) forKey:page_alipay];
                [_itemValues setObject:@(LSDevicePageFitnessDance) forKey:page_fitness_dance];
                [_itemValues setObject:@(LSDevicePageTaiChi) forKey:page_tai_chi];
            }break;
            case DSCategoryMessageRemind:{
                _title=title_message_remind;
                [_itemValues setObject:@(LSDeviceMessageIncomingCall) forKey:message_type_incoming_call];
                [_itemValues setObject:@(LSDeviceMessageDefault) forKey:message_type_all];
                [_itemValues setObject:@(LSDeviceMessageSMS) forKey:message_type_sms];
                [_itemValues setObject:@(LSDeviceMessageWechat) forKey:message_type_wechat];
                [_itemValues setObject:@(LSDeviceMessageQQ) forKey:message_type_qq];
            }break;
            case DSCategoryWeatherRemind:{
                _title=navigation_title_weather_remind;
                [_itemValues setObject:@(LSWeatherTypeSunnyDuring) forKey:weather_type_sunny_during];
                [_itemValues setObject:@(LSWeatherTypeSunnyNight) forKey:weather_type_sunny_night];
                [_itemValues setObject:@(LSWeatherTypeCloudy) forKey:weather_type_cloudy];
                [_itemValues setObject:@(LSWeatherTypeGloomy) forKey:weather_type_gloomy];
                [_itemValues setObject:@(LSWeatherTypeShower) forKey:weather_type_shower];
            }break;
            case DSCategorySportsInfo:{
                _title=title_sports_info;
            }break;
            case DSCategorySedentaryRemind:{
                _title=navigation_title_sedentary_remind;
            }break;
            case DSCategoryBehaviorRemind:{
                _title=navigation_title_behavior_remind;
            }break;
            case DSCategoryHeartRateWarning:{
                _title=navigation_title_hr_warning;
            }break;
            case DSCategoryDevicePositioning:{
                _title=title_device_positioning;
            }break;
            case DSCategoryNightMode:{
                _title=title_night_mode;
            }break;
            case DSMoodRecordRemind:{
                _title=title_mood_record;
            }break;
            case DSSimpleRemind:{
                _title=title_simple_remind;
            }break;
            case DSMessageRemind:{
                _title=title_msg_remind;
            }break;
            case DSWakeupRemind:{
                _title=title_wakeup_remind;
            }break;
            case DSAppointmentRemind:{
                _title=title_appointment_remind;
            }break;
            case DSCategoryQuietMode:{
                _title=title_quiet_mode;
            }break;
            default:
                break;
        }
    }
    return self;
}

-(NSArray <NSString *>*)values
{
    return self.itemValues.allKeys;
}

-(NSNumber *)valueOfKey:(NSString *)key
{
    return (NSNumber *)[self.itemValues valueForKey:key];
}




+(NSArray *)customDevicePages
{
    NSMutableArray *pages=[NSMutableArray arrayWithCapacity:10];
    [pages addObject:page_time];
    [pages addObject:page_step];
    [pages addObject:page_calories];
    [pages addObject:page_distance];
    [pages addObject:page_heartRate];
    [pages addObject:page_running];
    [pages addObject:page_cycling];
    [pages addObject:page_walking];
    [pages addObject:page_battery];
    [pages addObject:page_weather];
    [pages addObject:page_stop_watch];
    [pages addObject:page_daily_data];
    [pages addObject:page_music_player];
    [pages addObject:page_phone_location];
    [pages addObject:page_device_setting];
    [pages addObject:page_aerobic_exercise_12];
    [pages addObject:page_alipay];
    [pages addObject:page_fitness_dance];
    [pages addObject:page_tai_chi];

    return pages.copy;
}

+(NSArray *)messageType
{
    NSMutableArray *messages=[NSMutableArray arrayWithCapacity:10];
    [messages addObject:message_type_incoming_call];
    [messages addObject:message_type_all];
    [messages addObject:message_type_other];
    [messages addObject:message_type_sms];
    [messages addObject:message_type_wechat];
    [messages addObject:message_type_qq];
    [messages addObject:message_type_facebook];
    [messages addObject:message_type_twitter];
    [messages addObject:message_type_gamil];
    [messages addObject:message_type_whatsapp];
    return messages.copy;
}

+(NSArray *)weatherDate
{
    
    return @[@{date_today:@(0)},@{date_tomorrw:@(1)},@{date_day_after_tomorrow:@(2)}];
}


+(NSArray *)settingItemWithCagetory:(LSDeviceSettingCategory)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:5];
    if(DSCategoryWeatherRemind == type){
        LSDeviceSettingItem *dateItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryWeatherRemind];
        dateItem.title=item_cell_weather_date;
        dateItem.itemType=LSSettingItemSingleChoice;
        dateItem.itemValue=@"---";
        //resset select menu
        dateItem.itemValues=[[NSMutableDictionary alloc] initWithCapacity:3];
        [dateItem.itemValues setObject:@(0) forKey:date_today];
        [dateItem.itemValues setObject:@(1) forKey:date_tomorrw];
        [dateItem.itemValues setObject:@(2) forKey:date_day_after_tomorrow];

        
        LSDeviceSettingItem *maxTemItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryWeatherRemind];
        maxTemItem.title=item_cell_temperature_max;
        maxTemItem.itemType=LSSettingItemNumber;
        maxTemItem.itemValue=@"---";
        
        LSDeviceSettingItem *minTemItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryWeatherRemind];
        minTemItem.title=item_cell_temperature_min;
        minTemItem.itemType=LSSettingItemNumber;
        minTemItem.itemValue=@"---";
        
        LSDeviceSettingItem *aqiItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryWeatherRemind];
        aqiItem.title=item_cell_weather_aqi;
        aqiItem.itemType=LSSettingItemNumber;
        aqiItem.itemValue=@"---";
        
        LSDeviceSettingItem *typeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryWeatherRemind];
        typeItem.title=item_cell_weather_type;
        typeItem.itemType=LSSettingItemSingleChoice;
        typeItem.itemValue=@"---";
        
        return @[aqiItem,typeItem,maxTemItem,minTemItem];
    }
    else if(DSCategorySedentaryRemind == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryMessageRemind];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *startTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        startTimeItem.title=item_cell_start_time;
        startTimeItem.itemType=LSSettingItemDatePicker;
        startTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *endTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        endTimeItem.title=item_cell_end_time;
        endTimeItem.itemType=LSSettingItemDatePicker;
        endTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];

        LSDeviceSettingItem *sedentaryTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        sedentaryTimeItem.title=item_cell_vibration_time;
        sedentaryTimeItem.itemType=LSSettingItemNumber;
        sedentaryTimeItem.itemValue=@"---";
        
        LSDeviceSettingItem *intervalTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        intervalTimeItem.title=item_cell_vibration_interval;
        intervalTimeItem.itemType=LSSettingItemNumber;
        intervalTimeItem.itemValue=@"---";

        return @[switchItem,startTimeItem,endTimeItem,sedentaryTimeItem,intervalTimeItem];
    }
    else if (DSCategoryHeartRateWarning == type)
    {
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryHeartRateWarning];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        LSDeviceSettingItem *minItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryHeartRateWarning];
        minItem.title=item_cell_min_hr;
        minItem.itemType=LSSettingItemNumber;
        minItem.itemValue=@"---";
        
        LSDeviceSettingItem *maxItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryHeartRateWarning];
        maxItem.title=item_cell_max_hr;
        maxItem.itemType=LSSettingItemNumber;
        maxItem.itemValue=@"---";
        return @[switchItem,minItem,maxItem];
    }
    else if(DSCategoryBehaviorRemind == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryMessageRemind];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *startTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        startTimeItem.title=item_cell_start_time;
        startTimeItem.itemType=LSSettingItemDatePicker;
        startTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *endTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        endTimeItem.title=item_cell_end_time;
        endTimeItem.itemType=LSSettingItemDatePicker;
        endTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *intervalTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        intervalTimeItem.title=item_cell_vibration_interval;
        intervalTimeItem.itemType=LSSettingItemNumber;
        intervalTimeItem.itemValue=@"---";
        
        return @[switchItem,startTimeItem,endTimeItem,intervalTimeItem];
    }
    else if(DSCategoryMessageRemind == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryMessageRemind];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        LSDeviceSettingItem *typeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryMessageRemind];
        typeItem.title=item_cell_message_type;
        typeItem.itemType=LSSettingItemSingleChoice;
        typeItem.itemValue=@"---";
        
        return @[switchItem,typeItem];
    }
    else if(DSCategoryNightMode == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryMessageRemind];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *startTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        startTimeItem.title=item_cell_start_time;
        startTimeItem.itemType=LSSettingItemDatePicker;
        startTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *endTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySedentaryRemind];
        endTimeItem.title=item_cell_end_time;
        endTimeItem.itemType=LSSettingItemDatePicker;
        endTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        return @[switchItem,startTimeItem,endTimeItem];
    }
    else if(DSCategorySportsInfo == type){
        LSDeviceSettingItem *speedItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySportsInfo];
        speedItem.title=item_cell_speed;
        speedItem.itemType=LSSettingItemNumber;
        speedItem.itemValue= @"---";
        
        LSDeviceSettingItem *distanceItem=[[LSDeviceSettingItem alloc] initWithCategory:DSCategorySportsInfo];
        distanceItem.title=item_cell_distance;
        distanceItem.itemType=LSSettingItemNumber;
        distanceItem.itemValue= @"---";
        
        return @[speedItem,distanceItem];
    }
    else if(DSMoodRecordRemind == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:DSMoodRecordRemind];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *startTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSMoodRecordRemind];
        startTimeItem.title=item_cell_start_time;
        startTimeItem.itemType=LSSettingItemDatePicker;
        startTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *endTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSMoodRecordRemind];
        endTimeItem.title=item_cell_end_time;
        endTimeItem.itemType=LSSettingItemDatePicker;
        endTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *vibrationTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSMoodRecordRemind];
        vibrationTimeItem.title=item_cell_vibration_time;
        vibrationTimeItem.itemType=LSSettingItemNumber;
        vibrationTimeItem.itemValue=@"---";
        
        LSDeviceSettingItem *intervalTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:DSMoodRecordRemind];
        intervalTimeItem.title=item_cell_vibration_interval;
        intervalTimeItem.itemType=LSSettingItemNumber;
        intervalTimeItem.itemValue=@"---";
        
        return @[switchItem,startTimeItem,endTimeItem,vibrationTimeItem,intervalTimeItem];
    }
    else if (DSAppointmentRemind == type ||DSMessageRemind ==type
             || DSSimpleRemind ==type || DSWakeupRemind == type)
    {
        //switch
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        //appointment time
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *appointmentTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        appointmentTimeItem.title=item_cell_appointment_time;
        appointmentTimeItem.itemType=LSSettingItemDatePicker;
        appointmentTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        //reminder time
        LSDeviceSettingItem *reminderTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        reminderTimeItem.title=item_cell_reminder_time;
        reminderTimeItem.itemType=LSSettingItemDatePicker;
        reminderTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        
        //vibration time
        LSDeviceSettingItem *vibrationTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        vibrationTimeItem.title=item_cell_vibration_length;
        vibrationTimeItem.itemType=LSSettingItemNumber;
        vibrationTimeItem.itemValue=@"---";
        
        //repeat mode item
        LSDeviceSettingItem *repeatModeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        repeatModeItem.title=item_cell_repeat_mode;
        repeatModeItem.itemType=LSSettingItemSingleChoice;
        repeatModeItem.itemValue=@"---";
        repeatModeItem.itemValues=[[NSMutableDictionary alloc] initWithCapacity:3];
        [repeatModeItem.itemValues setObject:@(0) forKey:repeat_mode_once];
        [repeatModeItem.itemValues setObject:@(1) forKey:repeat_mode_1x];
        [repeatModeItem.itemValues setObject:@(2) forKey:repeat_mode_2x];
        [repeatModeItem.itemValues setObject:@(3) forKey:repeat_mode_3_minutes];
        
        //join agenda item
        LSDeviceSettingItem *agendaItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        agendaItem.title=item_cell_join_agenda;
        agendaItem.itemType=LSSettingItemSwitch;
        agendaItem.itemValue=@"Disable";
        
        //title
        LSDeviceSettingItem *titleItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        titleItem.title=item_cell_reminder_title;
        titleItem.itemType=LSSettingItemText;
        titleItem.itemValue=@"--";
        
        //content
        LSDeviceSettingItem *contentItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        contentItem.title=item_cell_reminder_content;
        contentItem.itemType=LSSettingItemText;
        contentItem.itemValue=@"--";
        
        //location
        LSDeviceSettingItem *locationItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        locationItem.title=item_cell_reminder_location;
        locationItem.itemType=LSSettingItemText;
        locationItem.itemValue=@"--";
        
        //ends time
        LSDeviceSettingItem *endsTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:(LSDeviceSettingCategory)type];
        endsTimeItem.title=item_cell_ends_time;
        endsTimeItem.itemType=LSSettingItemDatePicker;
        endsTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        //icon item
        LSDeviceSettingItem *iconItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        iconItem.title=item_cell_reminder_icon;
        iconItem.itemType=LSSettingItemNumber;
        iconItem.itemValue=@"--";

        //snooze length
        LSDeviceSettingItem *snoozeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        snoozeItem.title=item_cell_snooze_length;
        snoozeItem.itemType=LSSettingItemNumber;
        snoozeItem.itemValue=@"--";
        
        if(DSAppointmentRemind == type){
            return @[switchItem,appointmentTimeItem,reminderTimeItem,vibrationTimeItem,repeatModeItem,
                     agendaItem,titleItem,contentItem,locationItem];
        }
        else if(DSMessageRemind == type){
            return @[switchItem,reminderTimeItem,vibrationTimeItem,agendaItem,contentItem];
        }
        else if(DSSimpleRemind == type){
            return @[switchItem,iconItem,reminderTimeItem,vibrationTimeItem,repeatModeItem,
                     agendaItem,endsTimeItem,titleItem,contentItem];
        }
        else if (DSWakeupRemind == type){
            return @[switchItem,reminderTimeItem,vibrationTimeItem,repeatModeItem,
                     agendaItem,snoozeItem,titleItem,contentItem];
        }
    }
    else if (DSCategoryQuietMode == type){
        LSDeviceSettingItem *switchItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        switchItem.title=item_cell_switch_status;
        switchItem.itemType=LSSettingItemSwitch;
        switchItem.itemValue=@"Disable";
        
        NSDate *currentTime=[NSDate date];
        LSDeviceSettingItem *startTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        startTimeItem.title=item_cell_start_time;
        startTimeItem.itemType=LSSettingItemDatePicker;
        startTimeItem.itemValue= [dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *endTimeItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        endTimeItem.title=item_cell_end_time;
        endTimeItem.itemType=LSSettingItemDatePicker;
        endTimeItem.itemValue=[dateFormatter stringFromDate:currentTime];
        
        LSDeviceSettingItem *funsItem=[[LSDeviceSettingItem alloc] initWithCategory:type];
        funsItem.title=item_cell_device_funs;
        funsItem.itemType=LSSettingItemSingleChoice;
        funsItem.itemValue=@"---";
        funsItem.itemValues=[[NSMutableDictionary alloc] initWithCapacity:3];
        [funsItem.itemValues setObject:@(0) forKey:funs_disable_screen_turn_on];
        [funsItem.itemValues setObject:@(1) forKey:funs_enable_screen_turn_on];
        return @[switchItem,startTimeItem,endTimeItem,funsItem];
    }
    return items.copy;
}
@end
