//
//  LSDeviceSettingItem.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/8.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceSettingProfiles.h"

//title

#define title_week_target_step          @"Set Week Target Step"
#define title_time_format               @"Set Time Format"
#define title_week_start                @"Set Week Start"
#define title_distance_unit             @"Set Distance Unit"
#define title_screen_mode               @"Set Screen Mode"
#define title_wearing_mode              @"Set Wearing Mode"
#define title_hr_detect_mode            @"Set Heart Rate Detect Mode"
#define title_dialpeace_mode            @"Set Dialpeace Mode"
#define title_auto_discern              @"Set Auto Discern"
#define title_take_pictures             @"Set Photographing Command"
#define title_swith_status              @"Set Switch Status"
#define title_custom_pages              @"Set Custom Pages"
#define title_message_remind            @"Set Message Remind"
#define title_device_positioning        @"Device Positioning"
#define title_night_mode                @"Night Mode"
#define title_select_upgrade_file       @"Select Upgrade File"
#define title_sports_info               @"Sports Info"
#define title_mood_record               @"Mood Record Remind"

#define title_appointment_remind        @"Appoointment Reminder"
#define title_simple_remind             @"Simple Reminder"
#define title_msg_remind                @"Message Reminder"
#define title_wakeup_remind             @"Wakeup Reminder"
#define title_quiet_mode                @"Quiet Mode"


#define item_cell_start_time            @"Start Time"
#define item_cell_end_time              @"End Time"
#define item_cell_switch_status         @"Switch Status"
#define item_cell_vibration_time        @"Vibration Time(s)"
#define item_cell_vibration_interval    @"Vibration Interval(min)"
#define item_cell_min_hr                @"Min Heart Rate"
#define item_cell_max_hr                @"Max Heart Rate"
#define item_cell_message_type          @"Message Type"
#define item_cell_weather_type          @"Weather Type"
#define item_cell_weather_aqi           @"AQI"
#define item_cell_temperature_max       @"Temperature Max"
#define item_cell_temperature_min       @"Temperature Min"
#define item_cell_weather_date          @"Weather Date"
#define item_cell_speed                 @"Speed(s)"
#define item_cell_distance              @"Distance(m)"

#define item_cell_appointment_time      @"Appointment Time"
#define item_cell_reminder_time         @"Reminder Time"
#define item_cell_vibration_length      @"Vibration Length"
#define item_cell_repeat_mode           @"Repeat Mode"
#define item_cell_join_agenda           @"Join Agenda"
#define item_cell_reminder_title        @"Title"
#define item_cell_reminder_content      @"Content"
#define item_cell_reminder_location     @"Location"
#define item_cell_reminder_index        @"Reminder Index"
#define item_cell_reminder_icon         @"Reminder Icon"
#define item_cell_ends_time             @"Expiration Date"
#define item_cell_snooze_length         @"Snooze Length"
#define item_cell_device_funs           @"Device Founctions"

//setting item value

#define item_time_format_12             @"12 h"
#define item_time_format_24             @"24 h"
#define item_week_start_mon             @"Monday"
#define item_week_start_sun             @"Sunday"
#define item_distance_unit_k            @"Kilometer"
#define item_distance_unit_m            @"Mile"
#define item_screen_mode_h              @"Horizontal"
#define item_screen_mode_v              @"Vertical"
#define item_wearing_mode_l             @"Left"
#define item_wearing_mode_r             @"Right"
#define item_hr_detect_close            @"Close"
#define item_hr_detect_open             @"Open"
#define item_dialpeace_1                @"Dialpeace 1"
#define item_dialpeace_2                @"Dialpeace 2"
#define item_dialpeace_3                @"Dialpeace 3"
#define item_dialpeace_4                @"Dialpeace 4"
#define item_dialpeace_5                @"Dialpeace 5"
#define item_dialpeace_6                @"Dialpeace 6"
#define item_dialpeace_7                @"Dialpeace 7"
#define item_dialpeace_8                @"Dialpeace 8"
#define item_dialpeace_9                @"Dialpeace 9"
#define item_dialpeace_10               @"Dialpeace 10"
#define item_auto_discern_run           @"Running"
#define item_auto_discern_walk          @"Walking"
#define item_auto_discern_cyc           @"Cycing"
#define item_auto_discern_swim          @"Swimming"
#define item_auto_discern_body          @"Body Building"
#define item_take_pictures_enter        @"Enter Photographing"
#define item_take_pictures_exits        @"Exits Photographing"
#define item_switch_enable              @"Enable"
#define item_switch_disable             @"Disable"

#define prompt_setting                  @"syncing settings...\n\n"
#define prompt_setting_failure          @"Setting Failure,Code:"
#define prompt_setting_success          @"Setting Successfully!"

//custom pages
#define page_time                       @"Time"
#define page_step                       @"Step"
#define page_calories                   @"Calories"
#define page_distance                   @"Distance"
#define page_heartRate                  @"HeartRate"
#define page_running                    @"Running"
#define page_walking                    @"Walking"
#define page_cycling                    @"Cycling"
#define page_daily_data                 @"Daily Data"
#define page_stop_watch                 @"Stop Watch"
#define page_weather                    @"Weather"
#define page_battery                    @"Battery"
#define page_aerobic_exercise_12        @"Aerobic Exercise 12"
#define page_music_player               @"Music Player"
#define page_phone_location             @"Phone Location"
#define page_device_setting             @"Device Setting"

#define page_alipay                     @"Alipay"
#define page_fitness_dance              @"Fitness Dance"
#define page_tai_chi                    @"Tai Chi"



#define message_type_incoming_call      @"Incoming Call"
#define message_type_all                @"All"
#define message_type_other              @"other"
#define message_type_sms                @"sms"
#define message_type_wechat             @"wechat"
#define message_type_qq                 @"QQ"
#define message_type_facebook           @"Facebook"
#define message_type_twitter            @"Twitter"
#define message_type_gamil              @"Gamil"
#define message_type_whatsapp           @"Whatsapp"

#define date_today                      @"Today"
#define date_tomorrw                    @"Tomorrw"
#define date_day_after_tomorrow         @"Day After Tomorrow"

#define weather_type_sunny_during       @"Sunny During"
#define weather_type_sunny_night        @"Sunny Night"
#define weather_type_cloudy             @"Cloudy"
#define weather_type_gloomy             @"Gloomy"
#define weather_type_shower             @"Shower"


#define navigation_title_weather_remind         @"Weather Remind"
#define navigation_title_sedentary_remind       @"Sedentary Remind"
#define navigation_title_behavior_remind        @"Behavior Remind"
#define navigation_title_message_remind         @"Message Remind"
#define navigation_title_hr_warning             @"HeartRate Warning"

#define repeat_mode_once                 @"Once"
#define repeat_mode_1x                   @"1x"
#define repeat_mode_2x                   @"2x"
#define repeat_mode_3_minutes            @"Every 3 minutes"

#define funs_disable_screen_turn_on      @"Disable Screen Lights Up"
#define funs_enable_screen_turn_on       @"Enable Screen Lights Up"


typedef NS_ENUM(NSUInteger,LSDeviceSettingCategory){
    DSCategoryWeekStart = 0,                //星期开始设置
    DSCategoryAlarmClock,                   //闹钟提醒设置
    DSCategoryTimeFormat,                   //时间显示格式设置
    DSCategoryDistanceUnit,                 //距离单位设置
    DSCategoryWeekTarget,                   //同目标类型设置
    DSCategoryEventClock,                   //事件提醒设置，带标题
    DSCategoryNightMode,                    //夜间模式设置
    DSCategoryScreenMode,                   //屏幕显示方式设置
    DSCategoryWearingMode,                  //穿戴方式设置
    DSCategoryHeartRateDetect,              //心率检测方式设置
    DSCategoryDialpaceMode,                 //表盘样式设置
    DSCategoryAutoDiscern,                  //自动识别设置
    DSCategoryHeartRateWarning,             //心率预警设置
    DSCategorySedentaryRemind,              //久坐提醒设置
    DSCategoryWeatherRemind,                //天气设置
    DSCategoryBehaviorRemind,               //行为提醒设置
    DSCategoryMessageRemind,                //消息提醒设置
    DSCategoryCustomPages,                  //自定义页面设置
    DSCategoryTakePictures,                 //远程拍摄方式设置
    DSCategoryDevicePositioning,            //设备定位设置
    DSCategorySportsInfo,                   //运动配速、距离设置
    DSMoodRecordRemind,                     //心情提醒设置
    DSAppointmentRemind,                    //Kchiing Appointment Reminder
    DSSimpleRemind,                         //Kchiing Simple Reminder
    DSMessageRemind,                        //Kchiing Message Reminder
    DSWakeupRemind,                         //Kchiing Wakeup Reminder
    DSCategoryQuietMode,                    //勿扰模式设置
};


typedef NS_ENUM(NSUInteger,LSSettingItemType){
    LSSettingItemSingleChoice,
    LSSettingItemMultiChoice,
    LSSettingItemText,
    LSSettingItemNumber,
    LSSettingItemSwitch,
    LSSettingItemDatePicker,
    LSSettingItemFile
};



@interface LSDeviceSettingItem : NSObject

@property (nonatomic,strong)NSString *title;
@property (nonatomic,assign)LSDeviceSettingCategory type;
@property (nonatomic,strong)NSArray <NSString *>*values;
@property (nonatomic,assign)LSSettingItemType itemType;
@property (nonatomic,strong)id itemValue;
@property (nonatomic,strong)NSMutableDictionary *itemValues;
@property (nonatomic,strong)NSString *filePath;
@property (nonatomic,strong)NSIndexPath *indexPath;


-(instancetype)initWithCategory:(LSDeviceSettingCategory)category;

-(NSNumber *)valueOfKey:(NSString *)key;

+(NSArray *)customDevicePages;

+(NSArray *)settingItemWithCagetory:(LSDeviceSettingCategory)type;


@end
