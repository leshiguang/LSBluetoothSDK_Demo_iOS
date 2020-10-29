//
//  LSCmdPacket.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2018/11/19.
//  Copyright © 2018年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSCmdPacket : NSObject

@property(nonatomic,strong)NSData *cmdData;
@property(nonatomic,assign)NSUInteger cmd;

@end

NS_ASSUME_NONNULL_END
