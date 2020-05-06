//
//  PedometerAlarmClockTVC.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/25.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSDeviceSettingItem.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>

@interface PedometerAlarmClockTVC : UITableViewController

@property(nonatomic,assign)LSDeviceSettingCategory settingCategory;
@property(nonatomic,strong)LSDeviceInfo *activeDevice;

@end
