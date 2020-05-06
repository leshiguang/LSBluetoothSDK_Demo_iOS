//
//  LSDeviceFeature.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2017/6/27.
//  Copyright © 2017年 sky. All rights reserved.

//  Added in version 1.0.6 build-1

#import <Foundation/Foundation.h>

@interface LSDeviceFeature : NSObject

@property(nonatomic,strong)NSString *broadacstId;   //设备广播ID
@property(nonatomic,strong)NSString *deviceId;      //设备ID

@end


#pragma mark - LSWeightScaleFeature 互联秤设备功能feature

@interface LSWeightScaleFeature : LSDeviceFeature

@property(nonatomic,assign)BOOL isSupportBind;                  //是否支持绑定
@property(nonatomic,assign)BOOL isSupportUnBind;                //是否支持解除绑定
@property(nonatomic,assign)BOOL isSupportUtc;                   //是否支持UTC设置
@property(nonatomic,assign)BOOL isSupportTimezone;              //是否支持时区设置
@property(nonatomic,assign)BOOL isSupportTimeStamp;             //是否支持时间戳设置
@property(nonatomic,assign)BOOL isSupportMultiUser;             //是否支持多用户
@property(nonatomic,assign)BOOL isSupportBodyFatPercentage;     //是否支持脂肪率
@property(nonatomic,assign)BOOL isSupportBasalMetabolism;       //是否支持基础代谢
@property(nonatomic,assign)BOOL isSupportMusclePercentage;      //是否支持肌肉含量
@property(nonatomic,assign)BOOL isSupportMuscleMass;            //是否支持肌肉质量
@property(nonatomic,assign)BOOL isSupportFatFreeMass;           //是否支持无脂肪质量
@property(nonatomic,assign)BOOL isSupportSoftLeanMass;          //是否支持软肌肉计算
@property(nonatomic,assign)BOOL isSupportBodyWaterMass;         //是否支持水分含量计算
@property(nonatomic,assign)BOOL isSupportImpedance;             //是否支持阻抗测量
@end


#pragma mark - LSBpmFeature 互联血压计功能feature

@interface LSBpmFeature : LSDeviceFeature

@property(nonatomic,assign)BOOL isSupportBind;                  //是否支持绑定
@property(nonatomic,assign)BOOL isSupportUnBind;                //是否支持解除绑定
@property(nonatomic,assign)BOOL isSupportUtc;                   //是否支持UTC设置
@property(nonatomic,assign)BOOL isSupportTimezone;              //是否支持时区设置
@property(nonatomic,assign)BOOL isSupportTimeStamp;             //是否支持时间戳设置
@property(nonatomic,assign)BOOL isSupportMultiUser;             //是否支持多用户
@property(nonatomic,assign)BOOL isSupportPulseRate;             //是否支持脉搏检测
@property(nonatomic,assign)BOOL isSupportBodyMovement;          //是否支持体动检测
@property(nonatomic,assign)BOOL isSupportCuffFit;               //是否支持袖带检测
@property(nonatomic,assign)BOOL isSupportIrregularPulse;        //是否支持脉搏检测
@property(nonatomic,assign)BOOL isSupportMeasurementPosition;   //是否支持位置检测
@property(nonatomic,assign)BOOL isSupportMultipleBond;          //是否支持重复绑定
@property(nonatomic,assign)BOOL isRegistered;                   //设备是否已注册
@end
