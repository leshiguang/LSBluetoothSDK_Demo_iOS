//
//  TMBaseNetworkErrorProtocol.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorObjectProtocol.h"

enum {
    RET_DEFAULT_ERROR = -1,
    RET_SUCCESS = 200,
    RET_TOKEN_OVERTIME = 401,
    RET_NO_NEW_SOFTWARE_VERSION = -328,
};
typedef int ServerReturnValue;

enum {
    NO_ERROR = 0,
    NETWORK_UNAVAILABLE = 1,//判断网络不可用时返回该错误码
    COMMON_NETWORK_ERROR = 2,//http返回非200
    REQUEST_TIMEOUT = 3,//http请求超时
    REQUEST_CONNECTION_FAILED = 4,//网站请求不存在:404
    RESPONSE_PARSE_ERROR = 5,//http返回数据200,但解析数据（目前时json）失败
    RESPONSE_PARSE_RET_ERROR = 6,//逻辑解析后ret非0
    REQUEST_URL_NOFOUND = 7, //找不到配置里的url
    RESPONSE_TYPE_NOFOUND = 8, //找不到对应处理的response
    RESPONSE_DATA_NIL = 9, //200返回data数组为空
    PROTOCOL_IS_NOT_V2_ERROR = 200, //协议不是V2版本
    RESPONSE_DATA_INVALID = 10, //服务端返回的数据非法
};
typedef int NetworkErrorType;

@protocol BaseNetworkErrorProtocol <ErrorObjectProtocol>

@property (nonatomic,assign) NSInteger httpStatusCode;
@property (nonatomic,assign) NSInteger serverReturnValue;
@property (nonatomic,assign) NSInteger serverErrorCode;
@property (nonatomic,assign) NetworkErrorType serverErrorType;
@property (nonatomic,retain) NSString* serverErrorMsg;

@end
