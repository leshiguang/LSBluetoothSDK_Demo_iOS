//
//  LSAccountAuthorizeRequest.h
//  AFNetworking
//
//  Created by alex.wu on 2020/5/13.
//

#import <Foundation/Foundation.h>
#import <LSNetworkFramework/LSBaseRequest.h>
NS_ASSUME_NONNULL_BEGIN

@interface LSAccountAuthorizeRequest : LSBaseRequest
//必传，外部用户所属的租户ID 对企业/应用唯一
@property(nonatomic) NSInteger tenantId;
//必传，应用对应的租户订阅ID，对应用场景唯一
@property(nonatomic) NSInteger subscriptionId;
//第三方用户账号
@property(nonatomic, strong) NSString *associatedId;
//可选，业务token，用于跟外部业务交互，无则忽略
@property(nonatomic, strong) NSString *businessToken;
//可选，外部用户密码，用于跟外部业务校验associatedId合法性
@property(nonatomic, strong) NSString *password;


-(instancetype) init:(NSInteger)tenantId andSubscirbe:(NSInteger)subscriptionId associatedId:(NSString *)associatedId;
@end

NS_ASSUME_NONNULL_END
