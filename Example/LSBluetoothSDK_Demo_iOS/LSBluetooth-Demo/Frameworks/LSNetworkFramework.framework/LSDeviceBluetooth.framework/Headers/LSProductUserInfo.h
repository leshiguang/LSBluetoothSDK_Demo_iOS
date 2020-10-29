//
//  LSProductUserInfo.h
//  LsBluetooth-Test
//
//  Created by lifesense on 14-8-12.
//  Copyright (c) 2014年 com.lifesense.ble. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "LSBluetoothManagerProfiles.h"

@interface LSProductUserInfo : NSObject

@property(nonatomic, strong)NSString *deviceId;        //设备ID
@property(nonatomic,strong)NSString *broadcastId;      //设备广播ID；
@property(nonatomic)NSUInteger userNumber;             //用户编号
@property(nonatomic)LSMeasurementUnit unit;             //测量单位
@property(nonatomic)LSUserGender gender;               //用户性别
@property(nonatomic)NSUInteger age;                    //用户年龄
@property(nonatomic)NSUInteger athleteLevel;           //运动员级别，0表示非运动员，1-5表示运动员
@property(nonatomic)float height;                      //身高，单位M
@property(nonatomic)float goalWeight;                  //目标体重
@property(nonatomic)float waistline;                   //腰围
@property(nonatomic)float weight;                      //用户体重，单位kg
@property(nonatomic)BOOL isAthlete;                    //是否是运动员


-(NSData *)userInfoCommandData;


-(NSString *)keyWords;

@end
