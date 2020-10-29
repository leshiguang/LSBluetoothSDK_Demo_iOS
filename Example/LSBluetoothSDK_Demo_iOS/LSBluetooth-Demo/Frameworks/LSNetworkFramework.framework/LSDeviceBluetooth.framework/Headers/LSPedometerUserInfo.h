//
//  LSPedometerUserInfo.h
//  LifesenseBle
//
//  Created by lifesense on 14-8-1.
//  Copyright (c) 2014年 lifesense. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"
#import "LSProductUserInfo.h"

@interface LSPedometerUserInfo : NSObject

@property(nonatomic,strong)NSString *deviceId;              //对应的设备ID
@property(nonatomic,strong)NSString *weightUnit;            //体重单位
@property(nonatomic,assign)NSInteger userNo;                //用户编号
@property(nonatomic,assign)NSInteger targetStep;            //对应的周目标步数
@property(nonatomic,assign)NSInteger age;                   //用户年龄
@property(nonatomic,assign)NSInteger athleteActivityLevel;  //运动员等级
@property(nonatomic,assign)NSInteger weekStart;             //星期开始点 1 for Sunday,2 for Monday

@property(nonatomic,assign)double weight;                   //用户体重,单位kg
@property(nonatomic,assign)double height;                   //用户身高,单位M
@property(nonatomic,assign)double stride;                   //用户步长
@property(nonatomic,assign)double targetCalories;           //对应的周目标卡路里
@property(nonatomic,assign)double targetDistance;           //对应的周目标距离
@property(nonatomic,assign)double targetExerciseAmount;     //对应的周目标运动量
@property(nonatomic,assign)LSDeviceTimeFormat timeformat;   //时间显示格式，12小时制或24小时制
@property(nonatomic,assign)LSDistanceUnit distanceUnit;     //距离单位，公制或英制
@property(nonatomic,assign)LSWeekTarget targetType;         //周目标类型
@property(nonatomic,assign)LSUserGender userGender;         //用户性别
@property(nonatomic,assign)BOOL isAthlete;                  //是否是运动员

#pragma mark 3.5.0以后的A5协议才有

@property (nonatomic, assign) BOOL isOpenHeartRate;     //心率检测开关
@property (nonatomic, assign) unsigned char startHour;  //心率检测关起始时间(时)
@property (nonatomic, assign) unsigned char startMinute;//心率检测关起始时间(分)
@property (nonatomic, assign) unsigned char endHour;    //心率检测关结束时间(时)
@property (nonatomic, assign) unsigned char endMinute;  //心率检测关结束时间(分)

#pragma mark - M5手环 用户信息更新 0xB5

@property (nonatomic,strong) NSString *productModel;


-(NSData *)currentStateCommandData;

//new change for version1.1.0

-(NSData*)userMessageCommandData;

-(NSData*)weekTargetCommandData;

-(BOOL)isUserMessageSetting;

-(BOOL)isWeekStartSetting;

-(BOOL)isCurrentStateSetting;

-(NSData*)unitConversionCommandData;

-(BOOL)isUnitConversionSetting;

@end
