//
//  ErrorObjectProtocol.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorObjectHandleDelegate.h"

@protocol ErrorObjectProtocol <NSObject>

@required

@property (nonatomic,assign) NSInteger errCode;
@property (nonatomic,retain) NSString* errDiscription;
@property (nonatomic,retain) NSError* nativeError;

/**
 * 简单打印错误信息
 */
- (void)printError;

/**
 * 触发错误处理
 * @return ErrorObject对象本身
 */
- (id)triggerErrorHandler;

/**
 * 触发错误处理
 */
- (id)triggerErrorHandlerWithParameter:(id)userParameter;

/**
 * 当错误被触发时，触发handler的回调处理错误
 */
+ (void)addHandler:(id<ErrorObjectHandleDelegate>)handler;
+ (void)removeHandler:(id<ErrorObjectHandleDelegate>)handler;

/**
 * 当此类错误被触发时自动打印错误信息
 */
+ (void)autoPrintErrorInfoWhileTriggered:(BOOL)enable;
+ (BOOL)isAutoPrintErrorInfoWhileTriggered;

/**
 * 当此类错误被触发时自动打印堆栈（调试时抛出异常）
 */
+ (void)autoPrintCallStackWhileTriggered:(BOOL)enable;
+ (BOOL)isAutoPrintCallStackWhileTriggered;

/**
* 获得当前堆栈信息
*/
+ (NSString*)getCallStackInfo;

@end
