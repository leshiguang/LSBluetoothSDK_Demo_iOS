//
//  TMBaseNetworkError.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "BaseNetworkError.h"

@implementation BaseNetworkError

@synthesize httpStatusCode = _httpStatusCode;
@synthesize serverErrorType = _serverErrorType;
@synthesize serverReturnValue = _serverReturnValue;
@synthesize serverErrorCode = _serverErrorCode;
@synthesize serverErrorMsg = _serverErrorMsg;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    self.serverErrorMsg = nil;
}

+ (BaseNetworkError*) errorWithHttpStatusCode:(NSInteger)httpCode
                              serverReturnValue:(ServerReturnValue)serverRet
                               serverErrorCode:(NSInteger)serverErrCode
                               serverErrorType:(NetworkErrorType)serverErrType
                                serverErrorMsg:(NSString*)msg
{
    BaseNetworkError* ret = [[BaseNetworkError alloc] init];
    ret.httpStatusCode = httpCode;
    ret.serverReturnValue = serverRet;
    ret.serverErrorType = serverErrType;
    ret.serverErrorCode = serverErrCode;
    ret.serverErrorMsg = msg;
    ret.errDiscription = [NSString stringWithFormat:@"[Network Error] <HTTP Code> %li , <Server> retVal %li , errType %i, errCode %li, errMsg {%@}",(long)ret.httpStatusCode, (long)ret.serverReturnValue, ret.serverErrorType, (long)ret.serverErrorCode, ret.serverErrorMsg];
    [ret triggerErrorHandler];
    return ret;
}

@end
