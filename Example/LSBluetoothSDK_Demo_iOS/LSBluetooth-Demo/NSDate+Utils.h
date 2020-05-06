//
//  NSDate+Utils.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/11/22.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Utils)

/**
 * 带时区的转换
 */
//-(NSDate *) toLocalTime;

-(NSDate *) toGlobalTime;

@end

NS_ASSUME_NONNULL_END
