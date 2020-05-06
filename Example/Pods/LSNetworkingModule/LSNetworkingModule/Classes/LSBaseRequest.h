//
//  LSBaseRequest.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommunicationDelegate.h"
#import "RequestMap.h"

#define HTTP_GET @"GET"
#define HTTP_POST @"POST"

#define DATA_KEY @"key"
#define FILENAME_KEY @"file"
#define MIME_KEY @"mimetype"
#define BIANRY_DATA_KEY @"data"
#define FILE_PATH_KEY @"filepath"

typedef NS_ENUM(NSInteger, LSBaseRequestType) {
    LSBaseRequestTypeNormal = 0,
    LSBaseRequestTypeCustom
};

@interface LSBaseRequest : NSObject

@property (nonatomic, strong) NSString * method;
@property (nonatomic, strong) NSMutableDictionary * dataDict;
@property (nonatomic, strong) NSString * dataDictJSON;
@property (nonatomic, strong) NSMutableArray * binaryDataArray;
@property (nonatomic, strong) NSMutableArray * fileDataArray;
@property (nonatomic, strong) NSString * urlAppendingString;
@property (nonatomic, strong) NSURLSessionTask* request;
@property (nonatomic, strong) NSString * requestName;
@property (nonatomic, strong) id<ServerCommunicationDelegate> delegate;
@property (nonatomic, assign) NSUInteger requestId;
@property (nonatomic, strong) id context;

@property (nonatomic, strong) NSString * requestUrl;
@property (nonatomic, strong) NSString * responseName;
@property (nonatomic, strong) NSDictionary * requestCookieDict;

@property (nonatomic, assign) int timeout;
@property (nonatomic, assign) LSBaseRequestType baseRequestType;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *httpHeader;

@property (nonatomic, assign) BOOL needsCacheResponse; //缓存response数据
/**
 账号需要登陆 默认为NO
 */
@property (nonatomic, assign) BOOL accountNeedToLogin;


/**
 请求是否需要公有参数 默认为NO
 */
@property (nonatomic, assign) BOOL needToPublicParameters;

#pragma mark -
//仅有dataDict时有效，其他情况自动转换为post. 默认使用httpGet
-(void)setRequestProtocolName:(NSString*)protocolname;
-(void)setRequestHttpGet;
-(void)setRequestHttpPost;

//添加参数，post的时候会自动加到body里面，get的时候会自动添加到url后面
-(void)addStringValue:(NSString*)value forKey:(NSString*)key;
-(void)addDictionaryValue:(NSDictionary*)dict;
-(NSString*)getStringValueForKey:(NSString*)key;
-(void)addBinaryValue:(NSData*)value forKey:(NSString*)key withFileName:(NSString*)filename withMIMEtype:(NSString*)mimetype;
-(void)addFilePathValue:(NSString*)value forKey:(NSString*)key withFileName:(NSString*)filename withMIMEtype:(NSString*)mimetype;

/**
 添加stringValue,然后encode
 **/
-(void)addEncode:(NSString *)value forKey:(NSString *)key;

/**
 添加上传的二进制文件,简单版本
 */
-(void)addBinaryData:(NSData *)updata withFileName:(NSString *)upfilename;

//设置customHttpHeader
-(void)addStrValue:(NSString *)value forHttpHeaderField:(NSString *)key;

#pragma mark - debug
-(void)printRequest;

#pragma mark - getter方法,可以被子类override去定义自己的返回值
// 子类可override,去定义自己的url
- (NSString *)requestUrl;
// 子类可override,去定义自己的responseName
- (NSString *)responseName;
// 子类可override,去定义自己的requestCookieDict
- (NSDictionary *)requestCookieDict;

-(void)generateRequestToken;

-(NSString *)mergeUrlParameters;
#pragma mark - 公共参数, add by huowang, 20170215
/**
 随机数
 
 @return 字符串
 */
+ (NSString *)udid;


/**
 当前app版本号
 
 @return 字符串
 */
+ (NSString *)appVersion;


/**
 当前屏幕宽度
 
 @return 字符串
 */
+ (NSString *)screenWidth;


/**
 当前屏幕高度
 
 @return 字符串
 */
+ (NSString *)screenHeight;

/**
 当前系统
 
 @return 字符串
 */
+ (NSString *)systemType;


#pragma mark - 以下的函数为UUID提供支持
+ (void)save:(NSString *)service data:(id)data;
+ (id)getUUIDWithKey:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
