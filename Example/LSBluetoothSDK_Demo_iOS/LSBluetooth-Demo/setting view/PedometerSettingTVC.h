//
//  PedometerSettingTVC.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>

@interface PedometerSettingTVC : UITableViewController

@property(nonatomic,strong)LSDeviceInfo *activeDevice;

@end
