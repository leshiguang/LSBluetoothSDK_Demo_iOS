//
//  LSDeviceOperationCmdInfo.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2017/5/19.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,LSDeviceOperationCmd)
{
    DOperationCmdUnknown=0,             //未知状态
    DOperationCmdInputRandomCode=1,     //输入随机码
    DOperationCmdInputPairedConfirm=2,  //输入配对确认
    DOperationCmdInputDeviceId=3,       //输入设备ID
};

@interface LSDeviceOperationCmdInfo : NSObject

@property(nonatomic,strong) id cmdObj;  //操作指令对象
@property(nonatomic,assign) LSDeviceOperationCmd operationCmd;  //操作指令

@end
