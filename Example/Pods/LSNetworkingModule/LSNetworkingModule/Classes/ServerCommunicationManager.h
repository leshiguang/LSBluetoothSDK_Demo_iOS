//
//  ServerCommunicationManager.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunicationProtocol.h"
#import "ServerCommunicationEventsDelegate.h"
#import "AFNetworkReachabilityManager.h"

static NSString *const LSNetworkingStatusChangeNotification = @"LSNetworkingStatusChangeNotification";

@interface ServerCommunicationManager : NSObject
<ServerCommunicationProtocol,ServerCommunicationEventsDelegate>
@property (nonatomic, weak) id<ServerCommunicationEventsDelegate> eventsDelegate;

+ (id<ServerCommunicationProtocol>) GetServerCommunication;


/*
 判断网络是否在线
 */
+(BOOL)isReachable;
+(BOOL)isReachableViaWWAN;
+(BOOL)isReachableViaWiFi;

+(void)startNetworkMonitoring;
+(void)stopNetworkMonitoring;
//用了这个之后，通知和成员函数的block就用不了的了
+(void)networkingStatusChange:(void (^)(AFNetworkReachabilityStatus status))networkChangeblock;
@end
