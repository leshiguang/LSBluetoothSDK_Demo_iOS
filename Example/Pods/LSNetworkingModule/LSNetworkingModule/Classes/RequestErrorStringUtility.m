//
//  RequestErrorStringUtility.m
//  LSWearable
//
//  Created by malai on 16/8/18.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import "RequestErrorStringUtility.h"
#import "HttpErrcode.h"

@implementation RequestErrorStringUtility

+ (NSString *)errorStringWithError:(NSError *)error {
    NSString *errorString = nil;
    
    if (error.code == kHttpStatusCodeRequstErrorRequestTimeout || error.code == kHttpStatusCodeServerErrorGatewayTimeout || (error && [error code] == -1001)) {
        
        errorString = @"网络链接超时";
    }
    else if (error.code == kHttpStatusCodeRequstErrorNotFound || error.code == kHttpStatusCodeRequstErrorForbidden || error.code == kHttpStatusCodeServerErrorBadGateway) {
        
        errorString = @"网络连接失败";
    }
    else {
       
        errorString = @"网络错误，请重试";
    }
    
    
    return errorString;
}

@end
