//
//  LSDebugMessageDelegate.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2017/11/10.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSDebugMessageDelegate <NSObject>

/**
 * 所有调试信息
 */
@optional
-(void)onDebugMessage:(NSString *)msg;


/**
 * 数据同步调试信息
 */
@optional
-(void)onDataSyncingDebugMessage:(NSString *)msg;
@end

