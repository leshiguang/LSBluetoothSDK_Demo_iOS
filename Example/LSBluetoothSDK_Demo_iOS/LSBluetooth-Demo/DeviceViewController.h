//
//  DeviceViewController.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/7/16.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "BleDevice.h"

@interface DeviceViewController : UIViewController

@property(nonatomic,strong)LSDeviceInfo *currentDevice;
@property(nonatomic,strong)NSArray *pageTitle;
@property(nonatomic,strong)NSArray *measureDatas;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *processingView;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property (weak, nonatomic) IBOutlet UITextView *dataTextView;
@property (weak, nonatomic) IBOutlet UILabel *powerTitleLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *toastView;
@property (weak, nonatomic) IBOutlet UILabel *toastMessageLabel;

@end
