//
//  LSPedometerAlarmClock.h
//  LsBluetooth-Test
//
//  Created by lifesense on 14-8-15.
//  Copyright (c) 2014年 com.lifesense.ble. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"

typedef enum{
    SUNDAY=0X40,
    MONDAY=0X01,
    TUESDAY=0X02,
    WEANSDAY=0X04,
    THURSDAY=0X08,
    FRIDAY=0X10,
    SATADAY=0X20,
}CLOCK_DAY;


@interface LSPedometerAlarmClock : NSObject

@property(nonatomic,strong)NSString *deviceId;
@property(nonatomic,assign)int8_t command;
@property(nonatomic,assign)int8_t flag;
@property(nonatomic,assign)int8_t switch1;
@property(nonatomic,assign)int8_t day1;
@property(nonatomic,assign)int8_t hour1;
@property(nonatomic,assign)int8_t minute1;
@property(nonatomic,assign)int8_t switch2;
@property(nonatomic,assign)int8_t day2;
@property(nonatomic,assign)int8_t hour2;
@property(nonatomic,assign)int8_t minute2;
@property(nonatomic,assign)int8_t switch3;
@property(nonatomic,assign)int8_t day3;
@property(nonatomic,assign)int8_t hour3;
@property(nonatomic,assign)int8_t minute3;
@property(nonatomic,assign)int8_t switch4;
@property(nonatomic,assign)int8_t day4;
@property(nonatomic,assign)int8_t hour4;
@property(nonatomic,assign)int8_t minute4;

//A5 protocol
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, readonly) NSArray *weeks;
@property (nonatomic, assign) int hour;
@property (nonatomic, assign) int minute;
@property (nonatomic, assign) LSVibrationMode shockType;
@property (nonatomic, assign) int shockTime;
@property (nonatomic, assign) int shockLevel1;
@property (nonatomic, assign) int shockLevel2;

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

-(NSData*)getData;
@end
