//
//  NSDictionary+Ext.h
//  gqspace
//
//  Created by Chanbo on 15/8/18.
//  Copyright (c) 2015年 Chanbo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Ext)

/**
 *  把当前对象转换成json字符串
 *
 *  @return json格式字符串
 */
- (NSString *)toJsonString;

@end
