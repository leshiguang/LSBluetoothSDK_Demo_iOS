//
//  ServerComunicationManagerInternal.h
//  LSWearable
//
//  Created by ZhangWenzheng on 16/4/8.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "ServerCommunicationManager.h"

@interface ServerCommunicationManager ()

/**
 *  回调queue，默认为main queue
 */
@property (nonatomic, strong) dispatch_queue_t callbackQueue;

/**
 *  隔离queue的label
 */
@property (nonatomic, strong) NSString *isolationQueueLabel;

/**
 *  数据隔离queue
 */
@property (nonatomic, strong) dispatch_queue_t isolationQueue;

/**
 *  通过requestId获取LSBaseRequest实例
 *
 *  @note 只能在isolationQueue中调用此方法
 *
 *  @param rid requestId
 *
 *  @return 如果存在则返回相应的LSBaseRequest实例，否则返回nil
 */
- (LSBaseRequest*)findSendRequestInfoById:(NSUInteger)rid;

/**
 *  移除LSBaseRequest实例
 *
 *  @note 只能在isolationQueue中调用此方法
 *
 *  @param info LSBaseRequest实例
 */
- (void)removeSendRequestInfo:(LSBaseRequest*)info;

/**
 *  构造LSBaseResponse实例
 *
 *  @param request      LSBaseRequest实例
 *  @param responseData responseData
 *
 *  @return LSBaseResponse实例
 */
- (LSBaseResponse*)responseFromRequest:(LSBaseRequest*)request ResponseData:(NSData*)responseData;
@end
