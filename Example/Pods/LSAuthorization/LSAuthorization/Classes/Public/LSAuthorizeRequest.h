//
//  LSAuthorizeRequest.h
//  LSAuthorization
//
//  Created by alex.wu on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import "LSBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSAuthorizeRequest :LSBaseRequest
//appid， 配置工程的info.plist中

@property(nonatomic, strong) NSString *appId;
//业务的唯一ID，当serviceId代表连接时为设备唯一ID， 其它的情况待补充，必须
@property(nonatomic, strong) NSString *mac;

//服务唯一ID，比如连接服务，算法服务，业务服务等
@property(nonatomic, strong) NSString *serviceId;
//服务的版本，不同的服务版本可能对应到后台不同的计费策略，因此该字段必传
@property(nonatomic, strong) NSString *serviceVersion;
//应用的平台， 1是ios， 2是android
@property(nonatomic, readonly) NSInteger platform;
//应用的唯一ID， 对应到ios的boundleid
@property(nonatomic, strong, readonly) NSString *artifactId;


-(instancetype) init:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *)mac;
@end

NS_ASSUME_NONNULL_END
