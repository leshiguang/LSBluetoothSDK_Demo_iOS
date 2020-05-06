//
//  ErrorObject.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "ErrorObject.h"

@implementation ErrorObject

@synthesize errCode = _errCode;
@synthesize errDiscription = _errDiscription;
@synthesize nativeError = _nativeError;

#pragma mark Object Life-cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        self.errCode = -1;
        self.errDiscription = @"";
    }
    return self;
}

- (void)dealloc
{
    self.errDiscription = nil;
    self.nativeError = nil;
}

- (void)printError
{
    NSLog(@"%@\n",self.errDiscription);
}

/**
 * 触发错误处理
 * @return ErrorObject对象本身
 */
- (id)triggerErrorHandler
{
    return [self triggerErrorHandlerWithParameter:nil];
}

/**
 * 触发错误处理
 * param 用户带的参数
 * return ErrorObject对象本身
 */
- (id)triggerErrorHandlerWithParameter:(id)userParameter
{
#if DEBUG
    NSLog(@"Error Occured:%@\nDescription:%@\n",[[self class] description],[userParameter description]);
#endif
    return self;
}

/**
 * 当错误被触发时，触发handler的回调处理错误
 */
+ (void)addHandler:(id<ErrorObjectHandleDelegate>)handler
{
}

+ (void)removeHandler:(id<ErrorObjectHandleDelegate>)handler
{
}

/**
 * 当此类错误被触发时自动打印错误信息
 */
+ (void)autoPrintErrorInfoWhileTriggered:(BOOL)enable
{
}

+ (BOOL)isAutoPrintErrorInfoWhileTriggered
{
    return NO;
}

/**
 * 当此类错误被触发时自动打印堆栈（调试时抛出异常）
 */
+ (void)autoPrintCallStackWhileTriggered:(BOOL)enable
{
    
}

+ (BOOL)isAutoPrintCallStackWhileTriggered
{
    return NO;
}

/**
 * 获得当前堆栈信息
 */
+ (NSString*)getCallStackInfo
{
    NSException* exp = [NSException exceptionWithName:@"ErrorObject Get Call Stack" reason:@"Get Call Stack Info" userInfo:nil];
    NSString* callStackStr = @"";
    NSArray* stackArray = [exp callStackSymbols];
    for (NSString* function in stackArray)
    {
        callStackStr = [callStackStr stringByAppendingFormat:@"%@\n",function];
    }
    return callStackStr;
}

@end
