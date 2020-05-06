//
//  LSSettinItemDelegate.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/10.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDeviceSettingItem.h"

@protocol LSSettingItemDelegate <NSObject>

/**
 * 输入框设置结果回调
 */
@optional
-(void)deviceSettingItem:(LSDeviceSettingItem *)item didInputValue:(NSString *)value;

/**
 * 时间设置结果回调
 */
@optional
-(void)deviceSettingItem:(LSDeviceSettingItem *)item didDatePickerValue:(NSInteger)hour min:(NSInteger)minute;

/**
 * 开关状态设置回调
 */
@optional
-(void)deviceSettingItem:(LSDeviceSettingItem *)item didSwitchStatus:(BOOL)status;


/**
 * 类型选择设置回调
 */
@optional
-(void)deviceSettingItem:(LSDeviceSettingItem *)item didSelectionValue:(NSUInteger)value;
@end


