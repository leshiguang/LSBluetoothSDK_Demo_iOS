//
//  LSDBaseModel.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/3/15.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "NSDictionary+Ext.h"
#import "LSPedometerAlarmClock.h"
#import "KCIReminder.h"

#pragma mark - LSDBaseModel push指令的基类

@interface LSDBaseModel : NSObject
@property (nonatomic, assign) int command;
@property (nonatomic, assign) int packageIndex;

-(NSString *)toJson;

/**
 * get hour value of time
 * e.g. 12:29,return 12
 */
-(NSUInteger)hourOfTime:(NSString *)time;

/**
 * get minute value of time
 * e.g. 12:39,return 39
 */
-(NSUInteger)minuteOfTime:(NSString *)time;

@end

#pragma mark - LSDMessageReminder 来电提醒

@interface LSDMessageReminder : LSDBaseModel
@property (nonatomic, assign)  LSDeviceMessageType type;
@property (nonatomic, assign)   BOOL isOpen;
@property (nonatomic, assign)   int shockDelay;
@property (nonatomic, assign)   LSVibrationMode shockType;
@property (nonatomic, assign)   int shockTime;
@property (nonatomic, assign)   int shockLevel1;
@property (nonatomic, assign)   int shockLevel2;
@end

#pragma mark - LSDTimeType 手环时间显示格式

@interface LSDTimeType : LSDBaseModel
@property (nonatomic, assign) LSDeviceTimeFormat timeType;
@end

#pragma mark - LSDDistanceUnit 手环距离计算格式

@interface LSDDistanceUnit : LSDBaseModel
@property (nonatomic, assign) LSDistanceUnit distanceUnit;
@end

#pragma mark - LSDConfirmPair 配对确认

@interface LSDConfirmPair : LSDBaseModel
@property (nonatomic, assign) double weight;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) LSWeekTarget target;
@property (nonatomic, assign) double targetValue;
@end

#pragma mark - LSDDisplayPage 手环自定义页面

@interface LSDDisplayPage : LSDBaseModel
@property (nonatomic, assign, readonly) NSUInteger pageNum;

- (void)addPage:(LSDevicePageType)page;
- (void)removePage:(LSDevicePageType)page;
@end

#pragma mark - LSDEncourage 手环目标步数

@interface LSDEncourage : LSDBaseModel
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) int targetValue;
@end


#pragma mark - LSDHeartRate 手环心率检测方式

@interface LSDHeartRate : LSDBaseModel
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMinute;
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMinute;
@end

#pragma mark - LSHeartSection 手环心率区间

@interface LSHeartSection : NSObject
@property (nonatomic, assign) NSUInteger min;//下限
@property (nonatomic, assign) NSUInteger max;//上限
@end

#pragma mark - LSDHeartSection 手环心率区间push指令对象

@interface LSDHeartSection : LSDBaseModel
@property (nonatomic, assign) NSUInteger age;//年龄

- (BOOL)addHeartSection:(LSHeartSection *)heartSection;
@end

#pragma mark - LSDNightMode 手环夜间显示方式

@interface LSDNightMode : LSDBaseModel
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMin;
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMin;
@end

#pragma mark - LSDPreventLost 手环防丢设置指令

@interface LSDPreventLost : LSDBaseModel
@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,assign) NSUInteger disconnectTime;//断开时间，当手环与手机的断开时间达到设定值时，开始提醒
@end

#pragma mark - LSDPushGetInfo 获取手环的设置信息

@interface LSDPushGetInfo : LSDBaseModel
@property (nonatomic, assign)  LSGetDeviceInfoType type;
@property (nonatomic, assign)  int flashType;
@property (nonatomic, assign)  int beginAddr;
@property (nonatomic, assign)  int endAddr;
@end

#pragma mark - LSDScreenDisplay 手环屏幕显示内容

@interface LSDScreenDisplay : LSDBaseModel
@property (nonatomic, assign) LSScreenDisplayMode screeWay;
@end


#pragma mark - LSSedentaryClock 久坐提醒

@interface LSSedentaryClock : NSObject
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, readonly) NSArray *weeks;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMinute;
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMinute;
@property (nonatomic, assign) LSVibrationMode shockType;
@property (nonatomic, assign) int shockTime;
@property (nonatomic, assign) int shockLevel1;
@property (nonatomic, assign) int shockLevel2;
@property (nonatomic, assign) int interval;

/**
 *  添加提醒的日期,如果没有设置，将会提醒一次，最后一个一定得是LSWeekNone
 *
 *  @param week1 LSWeek 星期几
 */
- (void)addWeek:(LSWeek)week1,...;

/**
 *  删除提醒日期，最后一个一定得是LSWeekNone
 *
 *  @param week1 LSWeek 星期几
 */
- (void)removeWeek:(LSWeek)week1,...;

/**
 *  添加提醒的日期
 *
 *  @param weekDay LSWeek 星期几
 */
-(void)addWeekDay:(LSWeek)weekDay;

/**
 *  删除提醒的日期
 *
 *  @param weekDay LSWeek 星期几
 */
-(void)removeWeekDay:(LSWeek)weekDay;
@end

#pragma mark - LSDSedentary 久坐提醒设置

@interface LSDSedentary : LSDBaseModel
@property (nonatomic, assign) BOOL isOpenAlert;
@property (nonatomic, readonly) NSArray<LSSedentaryClock*> *alarms;

- (void)addClock:(LSSedentaryClock *)clock;
@end


#pragma mark - LSDSmartHeart 心率检测

@interface LSDSmartHeart : LSDBaseModel
@property (nonatomic, assign) LSHRDetectionMode smartHeartType;
@end

#pragma mark - LSDSportHeartRate 运动心率区间

@interface LSDSportHeartRate : LSDBaseModel
@property (nonatomic, assign) int maxHeartRateZone;//运动区间心率上限
@property (nonatomic, assign) int minHeartRateZone;//运动区间心率下限
@end


#pragma mark - LSDUserInfo 设备用户信息

@interface LSDUserInfo : LSDBaseModel
@property (nonatomic, assign) double weight;
@property (nonatomic, assign) double height;
@property (nonatomic, assign) LSWeekTarget target;
@property (nonatomic, assign) double targetValue;
@property (nonatomic, assign) int startHour;
@property (nonatomic, assign) int startMinute;
@property (nonatomic, assign) int endHour;
@property (nonatomic, assign) int endMinute;
@property (nonatomic,assign) BOOL isOpenHeartRate;
@end

#pragma mark - LSDWearingModel 手环穿戴方式

@interface LSDWearingModel : LSDBaseModel
@property (nonatomic, assign) LSWearingStyle wearingWay;
@end

#pragma mark - LSDWeekTarget 手环周目标类型

@interface LSDWeekTarget : LSDBaseModel
@property (nonatomic, assign)  double weight;
@property (nonatomic, assign)  double height;
@property (nonatomic, assign)  LSWeekTarget target;
@property (nonatomic, assign)  double targetValue;
@end

//#pragma mark - LSDSportState 手环运动状态
//
//@interface LSDSportState : LSDBaseModel
//@property (nonatomic,assign) LSFunctionTestType functionTest;//功能检测
//@property (nonatomic,assign) int state;//开关状态
//@end

#pragma mark - LSDAlarmClock 设备闹钟

@interface LSDAlarmClock : LSDBaseModel
@property (nonatomic, assign) BOOL isOpenAlert;
@property (nonatomic, readonly) NSArray<LSPedometerAlarmClock*> *alarms;

- (void)addClock:(LSPedometerAlarmClock *)clock;
@end


@interface LSDCommonResult : LSDBaseModel

@property (nonatomic, assign)   int cmd;
@property (nonatomic, assign)   BOOL isSuccess;
@end

#pragma mark - Version 1.1.0 Update

#pragma mark - LSAutomaticSportstypeModel 运动模式自动识别类型

@interface LSAutomaticSportstypeModel : NSObject

@property (nonatomic, assign) LSAutomaticSportstype type; //自动识别的运动类型
@property (nonatomic, assign) BOOL isOpen;   //是否启用
@end


@interface LSDAutomaticSportstype : LSDBaseModel

@property (nonatomic, assign, readonly) NSUInteger automaticNum;
@property (nonatomic, readonly) NSArray<LSAutomaticSportstypeModel*> *automatics;

/**
 *  添加自动识别多运动
 *  @param model LSAutomaticSportstypeModel 自动识别多运动对象
 */
- (void)addAutomatic:(LSAutomaticSportstypeModel *)model;
@end

#pragma mark - LSDeviceEncourageInfo

@interface LSDeviceEncourageInfo : LSDBaseModel

@property(nonatomic,assign)BOOL isEnable;
@property(nonatomic,assign)float targetValue;          //卡路里单位:0.1Kcal  目标距离单位:米
@property(nonatomic,assign)LSEncourageTargetType type;  //目标类型
@end

#pragma mark - LSDeviceWeatherInfo

@interface LSFutureWeatherModel : NSObject

@property (nonatomic, assign) LSWeatherType type;   //天气气象类型
@property (nonatomic, assign) int temperatureOne;  //温度范围1
@property (nonatomic, assign) int temperatureTwo;  //温度范围2
@property (nonatomic, assign) int AQI;             //空气质量指数AQI
@end


@interface LSDeviceWeatherInfo : LSDBaseModel

@property (nonatomic, assign) long long utc;    // 天气更新的UTC(天气获取时刻的时间，不是手机系统的时间)
@property (nonatomic, readonly) NSArray<LSFutureWeatherModel*> *weatherModels;//查看已经添加的未来天气信息对象(只读)

/**
 *  添加天气未来天气信息
 *  @param model LSFutureWeatherModel 未来天气信息对象
 */
- (void)addWeatherData:(LSFutureWeatherModel *)model;
@end


#pragma mark - LSDeviceDialPeaceInfo

@interface LSDeviceDialPeaceInfo : LSDBaseModel

@property(nonatomic,assign)LSDialPeaceStyle dialStyle;//表盘风格或表盘类型
@end

#pragma mark - LSDeviceHeartRateAlertInfo

@interface LSDeviceHeartRateAlertInfo : LSDBaseModel

@property(nonatomic,assign)NSUInteger minHeartRate; //最小心率值
@property(nonatomic,assign)NSUInteger maxHeartRate; //最大心率值
@property(nonatomic,assign)BOOL isEnable;           //是否启用
@end

#pragma mark - LSDeviceEventReminderInfo

@interface LSDeviceEventReminderInfo : NSObject

@property (nonatomic, assign) LSReminderType reminderType;  //提醒类型
@property (nonatomic, assign) int index;                    //事件提醒序号(必须在1~5)
@property (nonatomic, strong) NSString *eventcontent;       //事件描述内容
@property (nonatomic, assign) BOOL eventSwitch;             //事件提醒开关
@property (nonatomic, assign) int hour;                     //事件提醒时间(小时)
@property (nonatomic, assign) int minute;                   //事件提醒时间(分钟)
@property (nonatomic, readonly) NSArray *weeks;             //事件提醒重复时间(重复提醒的日期)
@property (nonatomic, assign) LSVibrationMode shockType;    //事件提醒震动方式
@property (nonatomic, assign) int shockTime;                //事件提醒震动持续时长
@property (nonatomic, assign) int shockLevel1;              //事件提醒震动强度1
@property (nonatomic, assign) int shockLevel2;              //事件提醒震动强度2

/**
 *  添加提醒的日期,如果没有设置，将会提醒一次，最后一个一定得是LSWeekNone
 *  @param week1 LSWeek 星期几
 */
- (void)addWeek:(LSWeek)week1,...;

/**
 *  删除提醒日期，最后一个一定得是LSWeekNone
 *
 *  @param week1 LSWeek 星期几
 */
- (void)removeWeek:(LSWeek)week1,...;

/**
 *  添加提醒的日期
 *
 *  @param weekDay LSWeek 星期几
 */
-(void)addWeekDay:(LSWeek)weekDay;

/**
 *  删除提醒的日期
 *
 *  @param weekDay LSWeek 星期几
 */
-(void)removeWeekDay:(LSWeek)weekDay;
@end

@interface LSDeviceEventReminderlist : LSDBaseModel
@property (nonatomic,assign)int reminderType;   //提醒类型
@property (nonatomic,assign)NSUInteger reminderCmd;     //提醒指令
@property (nonatomic, readonly) NSArray<LSDeviceEventReminderInfo*> *events;

/**
 *  添加事件提醒对象
 *  @param event LSEventRemind 事件提醒对象
 */
- (void)addEvent:(LSDeviceEventReminderInfo *)event;
@end

//Added in version 1.0.6 build-1
#pragma mark - LSScaleUserInfo 互联秤的用户信息

@interface LSScaleUserInfo : LSDBaseModel
@property (nonatomic ,assign) NSUInteger userNumber;    //用户编号
@property (nonatomic ,assign) LSUserGender gender;      //用户性别
@property (nonatomic ,assign) NSUInteger age;           //年龄
@property (nonatomic ,assign) NSUInteger height;        //身高 ，单位cm(0.01m)
@property (nonatomic ,assign) double weight;            //体重
@property (nonatomic ,assign) BOOL isAthlete;           //是否是运动员
@property (nonatomic ,assign) NSUInteger athleteLevel;  //运动等级
@end


#pragma mark - LSScaleTargetInfo 互联秤的目标信息

@interface LSScaleTargetInfo : LSDBaseModel
@property (nonatomic ,assign) int userNumber;           //用户编号
@property (nonatomic ,assign) int targetType;           //目标类型
@property (nonatomic ,assign) double targetWeight;      //目标体重
@end


#pragma mark - LSScaleTimeInfo 互联秤的时间信息

@interface LSScaleTimeInfo : LSDBaseModel
@property (nonatomic ,assign) LSDeviceTimeFeature feature;  //时间feature
@property (nonatomic ,assign) NSUInteger utc;               //utc时间
@property (nonatomic ,assign) NSUInteger timeZone;          //时区
@property (nonatomic ,strong) NSDate *timeStamp;            //时间戳，具体的时间
@end


#pragma mark - LSScaleDataClearInfo 互联秤的数据清除信息

@interface LSScaleDataClearInfo : LSDBaseModel
@property (nonatomic ,assign) int userNumber;               //用户编号
@property (nonatomic ,assign) LSDataClearType clearType;    //待删除的数据类型
@end

#pragma mark - LSDeviceFunctionInfo 设备功能开关信息

@interface LSDeviceFunctionInfo : LSDBaseModel
@property (nonatomic) BOOL enable;                        //开关状态
@property (nonatomic,assign)LSDeviceFunction function;    //设备功能
@end

#pragma mark - Added in version 1.1.8

@interface LSBehaviorRemindInfo:LSDBaseModel
@property (nonatomic,assign)LSReminderType type;   //提醒类型，0x01=表示喝水提醒，其他待定
@property (nonatomic)BOOL enable;                        //开关
@property (nonatomic,strong)NSString *startTime;         //开始时间，格式18:00
@property (nonatomic,strong)NSString *endTime;           //结束时间，格式12:00
@property (nonatomic)NSUInteger intervalTime;            //提醒间隔，单位分钟
@end

#pragma mark - Added in version 1.2.1 LSHealthScoreInfo 健康分数

@interface LSHealthScoreInfo:LSDBaseModel
@property (nonatomic)NSUInteger value;      //健康分数
@end

#pragma mark - Added in version 1.2.1 LSPhotographingInfo 远程拍摄信息

@interface LSPhotographingInfo:LSDBaseModel
@property (nonatomic)NSUInteger status;     //拍摄状态,0=代表退出拍照模式;1=代表进入拍照模式
@end

#pragma mark - Added in version 1.2.1 LSPositioningInfo 设备定位信息

@interface LSPositioningInfo:LSDBaseModel
@end

#pragma mark - Added in version 1.2.2 LSSportNotifyConfirm

@interface LSSportNotifyConfirm:LSDBaseModel
@property (nonatomic,assign)LSSportNotifyType type;         //运动通知类型
@property (nonatomic,assign)LSGpsState gpsState;            //GPS状态
@end

@interface LSSportRequestInfo:LSDBaseModel
@property (nonatomic,assign)LSDeviceSportMode sportMode;    //运动类型
@property (nonatomic,assign)NSUInteger state;               //运动请求状态，0x00=开始运动，0x01=结束运动
@end

@interface LSDeviceStatusConfirm:LSDBaseModel
@property (nonatomic,assign)NSUInteger type;
@property (nonatomic,assign)NSUInteger state;
@end

#pragma mark - Added in version 1.2.3

@interface LSSportsInfo:LSDBaseModel
@property (nonatomic,assign)NSUInteger speed; //配速,单位秒,指跑（走）完1km需要多久时间，例如256表示4’16’’
@property (nonatomic,assign)NSUInteger distance;//距离，单位米，
@end

#pragma mark - Added in version 1.2.4
@interface LSMoodRecordReminder:LSDBaseModel
@property (nonatomic,assign)BOOL enable;                //Status of Mood record reminder
@property (nonatomic,strong)NSString *startTime;        //Start time of Mood record reminder
@property (nonatomic,strong)NSString *endTime;          //End time of Mood record reminder
@property (nonatomic,assign)NSUInteger vibrationTime;    //Vibration time of reminder
@property (nonatomic,assign)NSUInteger vibrationInterval;//Vibration interval of reminder
@end
