//
//  LSDeviceSetting.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2018/12/12.
//  Copyright © 2018年 sky. All rights reserved.
//

#import "LSCmdPacket.h"
#import "LSBluetoothManagerProfiles.h"
#import "LSDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSDeviceSetting : LSCmdPacket

-(NSUInteger)hourOfTime:(NSString *)time;

-(NSUInteger)minuteOfTime:(NSString *)time;

@end

#pragma mark - 勿扰模式设置

@interface LSPedometerQuietMode : LSDeviceSetting

/**
 * <div class="en">Start time period in which quiet mode is in effect</div>
 * <div class="zh">勿扰模式生效的开始时间段，格式：12:09</div>
 */
@property(nonatomic,strong)NSString *startTime;

/**
 * <div class="en">Ends time period in which quiet mode is in effect</div>
 * <div class="zh">勿扰模式生效的结束始时间段,格式：13:09</div>
 */
@property(nonatomic,strong)NSString *endsTime;

/**
 * <div class="en">Status of quiet mode,enable or disable</div>
 * <div class="zh">勿扰模式是否生效状态标志位</div>
 */
@property(nonatomic,assign)BOOL status;

/**
 * <div class="en">List of device features that are allowed or disabled in quiet mode</div>
 * <div class="zh">在勿扰模式下，允许使用或设置禁用的设备功能列表</div>
 */
@property(nonatomic,strong)NSArray <LSDeviceFunctionInfo *> *functions;
@end


@interface LSAppMessage : LSDeviceSetting

@property(nonatomic,strong) NSString *appId;
@property(nonatomic,assign) LSDeviceMessageType type;
@property(nonatomic,assign) BOOL enable;

@end


NS_ASSUME_NONNULL_END
