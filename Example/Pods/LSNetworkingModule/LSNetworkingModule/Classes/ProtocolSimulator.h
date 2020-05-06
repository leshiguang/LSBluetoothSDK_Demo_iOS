//
//  ProtocolSimulator.h
//  LSWearable
//
//  Created by rolandxu on 15/12/27.
//  Copyright © 2015年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseRequest.h"

@interface ProtocolSimulator : NSObject

/**
 *  根据配置文件，读取相对应request的response数据，并模拟网络回调。
 *  若配置文件里有对应request的response则返回YES，否则NO.
 */
- (BOOL)sendRequest:(LSBaseRequest *)request;

- (void)setResponseUTF8String:(NSString*)data forRequestName:(NSString*)requestName;

-(void)removeResponseUTF8StringForRequestName:(NSString*)requestName;

@end
