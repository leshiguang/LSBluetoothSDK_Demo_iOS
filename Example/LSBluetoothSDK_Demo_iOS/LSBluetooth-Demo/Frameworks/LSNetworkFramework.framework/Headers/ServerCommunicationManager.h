//
//  ServerCommunicationManager.h
//  TestProject_Example
//
//  Created by pengpeng on 2020/5/21.
//  Copyright © 2020 pengpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunicationProtocol.h"
#import "ServerCommunicationEventsDelegate.h"
#import "LSReachability.h"
#import "LSBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const LSNetworkingStatusChangeNotification = @"LSNetworkingStatusChangeNotification";

@interface ServerCommunicationManager : NSObject <ServerCommunicationProtocol, ServerCommunicationEventsDelegate>

@property (nonatomic, weak) id<ServerCommunicationEventsDelegate> eventsDelegate;

+ (id<ServerCommunicationProtocol>) GetServerCommunication;

@property (nonatomic, strong) LSReachability *reachability;

- (void)addNetworkingStatusChange;

/*
 判断网络是否在线
 */
+(BOOL)isReachable;
+(BOOL)isReachableViaWWAN;
+(BOOL)isReachableViaWiFi;

+(void)startNetworkMonitoring;
+(void)stopNetworkMonitoring;
//用了这个之后，通知和成员函数的block就用不了的了
+(void)networkingStatusChange:(void (^)(LSNetworkStatus status))networkChangeblock;

@end

NS_ASSUME_NONNULL_END
