//
//  KHReminder.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2018/11/9.
//  Copyright © 2018年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSCmdPacket.h"
#import "LSDataFormatUtils.h"

//一个数据包（6帧），有效字节的最大长度为105
#define PACKET_MAX_SIZE 105

//内容最大长度
#define CONTENT_MAX_SIZE PACKET_MAX_SIZE-2

typedef NS_ENUM(NSUInteger,KReminderType){
   
    KReminderUnknown=0xFF,
    KReminderAppointment=0x00,      //Appointment Reminder
    KReminderSimple=0x01,           //Simple Reminder
    KReminderMessage=0x02,          //Message Reminder
    KReminderSilentWakeup=0x03,     //Silent Wakeup Reminder
};

typedef NS_ENUM(NSUInteger,KRepeatType){
    KRepeatNone=0x00,
    KRepeatBasedOnNumbers=0x01,     //repeat according to the number of times
    KRepeatBasedOnMinutes=0x02,    //Repeat according to the minutes
};

typedef NS_ENUM(NSUInteger,KReminderCmd) {
    KReminderCmdTime=0xA0,
    KReminderCmdIcon=0xA1,
    KReminderCmdTitle=0xA2,
    KReminderCmdContent=0xA3,
    KReminderCmdAppointmentTime=0xA4,
    KReminderCmdAppointmentLocation=0xA5,
    KReminderCmdCountdownTime=0xA6,
    KReminderCmdSnoozeTime=0xA7,
    KReminderCmdVibrationTime=0xA8,
    KReminderCmdRepeatMode=0xA9,
};

@interface KRepeatSetting : NSObject
    
@property(nonatomic,assign)KRepeatType repeatType;
@property(nonatomic,strong)NSArray * _Nullable weekDays;          //Repeat week days of reminder
@property(nonatomic,assign)long startTime;             //Start time of repeat reminder
@property(nonatomic,assign)long endsTime;             //Ends time of  repeat reminder
    
/**
 * Repeat value
 * if repeatType==KRepeatType.Numbers,value means the count of repeat
 * if repeatType==KRepeatType.Minutes,value means the minute of repeat,uint:minutes
 */
@property(nonatomic,assign)int value;
    
/**
 * if repeatType==KRepeatType.Numbers && value >0;
 * then the Application must add the corresponding number of time stamps
 */
@property(nonatomic,strong)NSArray * _Nullable multiRemindTimes;

/**
 * Expiration date of repeat reminder
 */
@property (nonatomic,assign)long expirationDate;

-(NSData *_Nullable)toBytes;
@end


@interface KReminderCommand : NSObject
    
@property(nonatomic,strong)NSString * _Nonnull key;
@property(nonatomic,strong)NSData * _Nonnull data;
@property(nonatomic,assign)int size;
@end


NS_ASSUME_NONNULL_BEGIN

@interface KCIReminder : LSCmdPacket

/**
 * Index of reminder,1~25
 */
@property(nonatomic,assign)int reminderIndex;
    
/**
 * Status of reminder
 * if true,means this reminder will enable
 * or false means this reminder will disable
 */
@property(nonatomic,assign)BOOL status;
    
/**
 * Status of all reminder switch
 */
@property(nonatomic,assign)BOOL totalStatus;
    
/**
 * Type of reminder
 */
@property(nonatomic,assign)KReminderType type;
    
/**
 * Icon of reminder >=1
 */
@property(nonatomic,assign)int iconIndex;
    
/**
 * Title of reminder
 */
@property(nonatomic,strong)NSString *title;
    
/**
 * Description of reminder
 */
@property(nonatomic,strong)NSString *content;
    
/**
 * Time of reminder
 * e.g 2018/10/29 12:32:34 to long
 */
@property(nonatomic,assign)long remindTime;
    
/**
 * Vibration length of reminder
 * unit:minute
 */
@property(nonatomic,assign)int vibrationLength;
    
/**
 * Whether to join the agenda
 * if true,this reminder will show in the agenda
 */
@property(nonatomic,assign)BOOL joinAgenda;
    
/**
 * Repeat setting of this minder
 */
@property(nonatomic,strong)KRepeatSetting *repeatSetting;
    
/**
 * Command list,only read
 */
@property(nonatomic,strong,readonly)NSMutableArray<KReminderCommand*> *cmdlists;

/**
 * 根据包序号，格式化数据包头部内容
 */
-(NSData *)formatPacketHeader:(NSUInteger)packetNum;
@end

/**
 * Appointment Reminder
 */
@interface KCIAppointmentReminder : KCIReminder
@property(nonatomic,assign)long appointTime;        //appoint time
@property(nonatomic,strong)NSString *location;      //location
@end

/**
 * Simple Reminder
 */
@interface KCISimpleReminder : KCIReminder
@end

/**
 * Message Reminder
 */
@interface KCIMessageReminder : KCIReminder
@end

/**
 * Wakeup Reminder
 */
@interface KCIWakeupReminder : KCIReminder
@property(nonatomic,assign) int snoozeLength; //Snooze length,unit:minute
@end


NS_ASSUME_NONNULL_END
