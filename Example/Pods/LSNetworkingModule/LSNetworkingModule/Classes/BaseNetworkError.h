//
//  TMBaseNetworkError.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorObject.h"
#import "BaseNetworkErrorProtocol.h"

@interface BaseNetworkError : ErrorObject <BaseNetworkErrorProtocol>

+ (BaseNetworkError*) errorWithHttpStatusCode:(NSInteger)httpCode
                              serverReturnValue:(ServerReturnValue)serverRet
                                serverErrorCode:(NSInteger)serverErrCode
                                serverErrorType:(NetworkErrorType)serverErrType
                                 serverErrorMsg:(NSString*)msg;

@end
