//
//  RequestMap.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 配置字典中的key值
extern NSString *const kLSWConfigHostKey;  // host
extern NSString *const kLSWConfigStaticHostKey; // staticHost
extern NSString *const kLSWConfigWebSocketKey;  // webSocketHost
extern NSString *const kLSWConfigTypeKey;       // dev,qa,release,custom


extern NSString *const kLSWConfigCustomType;  // custom
extern NSString *const kLSWConfigDevType;  // dev
extern NSString *const kLSWConfigQaType;  // qa
extern NSString *const kLSWConfigQa2Type;  // qa2
extern NSString *const kLSWConfigReleaseType;  // release



@interface RequestMap : NSObject

/**
 当前host
 */
@property (nonatomic, readonly) NSString *currentHost;


/**
 当前静态页面host
 */
@property (nonatomic, readonly) NSString *currentStaticHost;


/**
 当前websocketHost
 */
@property (nonatomic, readonly) NSString *currentWebsocketHost;


/**
 当前配置类型
 */
@property (nonatomic, readonly) NSString *currentConfigType;


/**
 当前配置
 */
@property (nonatomic, readonly) NSDictionary *currentConfig;

+ (instancetype)shareInstance;

/**
 清除requestMap
 */
+ (void)cleanUp;

+ (NSString *)getDefaultHostKey;

/**
 获取request

 @param name 请求名
 @return request
 */
- (nullable NSString *)getRequestV2UrlByName:(NSString *)name;

/**
 获取response

 @param name 请求名
 @return response
 */
- (nullable NSString *)getResponseV2ByName:(NSString *)name;


/**
 所有的配置（包括默认的和自定义的）

 @return 配置信息
 */
- (NSMutableArray *)allConfigs;


/**
 增加一个配置

 @param configDict 配置
 */
- (void)addWithConfigDict:(NSDictionary *)configDict;


/**
 删除一个配置

 @param configDict 配置
 */
- (void)deleteWithConfigDict:(NSDictionary *)configDict;


/**
 设置当前配置

 @param configDict 配置信息
 */
- (void)setWithConfigDict:(NSDictionary *)configDict;

/**
 监测是否有相同的配置存在

 @param config 配置信息
 @return yes & no
 */
- (BOOL)checkConfigHasContained:(NSDictionary *)config;

/**
 添加自定义的protocol
 */
- (void)addProtocolWithFilePath:(NSString *)filePath;

//更改默认的 key, 建议只提供 dev, qa, qa2, release 这四种值
-(BOOL)changeDefaultHostKey:(NSString *)key;

//更改默认的host，默认的key不变, 主要用来更改服务端下发的host
//更改默认的host, static host, websockethost， 就是把3个用下发的link覆盖，请使用setWithConfigDict
-(BOOL)changeDefaultHost:(NSString *)hostLink ;

//取得协议地址，直接返回。这个返回是直接返回plist里面的配置的url。
- (nullable NSString *)getOriginRequestUrl:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

