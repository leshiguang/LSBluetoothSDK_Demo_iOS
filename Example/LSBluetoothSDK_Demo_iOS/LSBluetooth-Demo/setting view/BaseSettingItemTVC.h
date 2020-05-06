//
//  BaseSettingItemTVC.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/13.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSDeviceSettingItem.h"
#import "LSSettinItemDelegate.h"

@interface BaseSettingItemTVC : UITableViewController

@property (nonatomic,strong)NSArray <LSDeviceSettingItem *>*dataSources;
@property (nonatomic,strong)id<LSSettingItemDelegate> itemDelegate;
@property (nonatomic,strong)LSDeviceInfo *activeDevice;
@property (nonatomic,strong)NSString *viewTitle;
@property (nonatomic,strong)LSDeviceSettingItem *item;
@end
