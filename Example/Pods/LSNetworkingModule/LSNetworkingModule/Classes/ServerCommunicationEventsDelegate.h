//
//  ServerCommunicationEventsDelegate.h
//  LSNetworking
//
//  Created by ouhuowang on 2017/1/5.
//  Copyright © 2017年 ouhuowang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ServerCommunicationProtocol.h"
#import "LSBaseRequest.h"
#import "LSBaseResponse.h"

//这些方法统一在一个私有Queue中回调
@protocol ServerCommunicationEventsDelegate <NSObject>
@optional
- (BOOL)serverCommunicationManager:(id<ServerCommunicationDelegate>)manager shouldSendRequest:(LSBaseRequest *)request;

- (void)communicationManager:(id<ServerCommunicationDelegate>)manager
          sendRequestSucceed:(LSBaseRequest *)request
          didReceiveResponse:(LSBaseResponse *)response;

- (void)communicationManager:(id<ServerCommunicationDelegate>)manager
           sendRequestFailed:(LSBaseRequest *)request
                    response:(LSBaseResponse *)response;

- (void)communicationManager:(id<ServerCommunicationDelegate>)manager
didReceiveInvalidDataResponse:(LSBaseResponse *)response;
@end
