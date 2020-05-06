//
//  LSAuthorizationService.h
//  LSAuthorizationService
//
//  Created by alex.wu on 2020/3/3.
//

#import <Foundation/Foundation.h>
#import "LSAuthorizationDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface LSAuthorizationService : NSObject
@property id<LSAuthorizationDelegate> delegate;

+(instancetype) sharedInstance;

-(void) addDelagate:(id<LSAuthorizationDelegate>) delegate;
/// 设备鉴权服务
/// @param serviceId 服务ID，由服务中心指定
/// @param serviceVersion 服务版本，由服务中心指定
/// @param mac 设备mac地址
/// @param complete 回调
-(void) authorizeDevice:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *)mac withBlock:(void (^)(NSInteger)) complete;



/// 通用服务鉴权接口，针对算法、SDK等
/// @param serviceId 服务ID，由服务中心指定
/// @param serviceVersion 服务版本
/// @param complete 回调
-(void) authorize:(NSString *)serviceId andVersion:(NSString *)serviceVersion withBlock:(void (^)(NSInteger)) complete;

@end

NS_ASSUME_NONNULL_END
