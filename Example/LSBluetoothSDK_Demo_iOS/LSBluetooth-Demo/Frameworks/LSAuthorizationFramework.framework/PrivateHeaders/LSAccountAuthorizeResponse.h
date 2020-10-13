//
//  LSAccountAuthorizeResponse.h
//  AFNetworking
//
//  Created by alex.wu on 2020/5/13.
//

#import <Foundation/Foundation.h>
#import <LSNetworkFramework/LSJSonResponse.h>
NS_ASSUME_NONNULL_BEGIN

@interface LSAccountAuthorizeResponse  : LSJSonResponse

//乐智用户ID
@property(nonatomic) NSInteger userId;
//登录token
@property(nonatomic, strong) NSString *accessToken;
//外部token
@property(nonatomic, strong) NSString *businessToken;
//外部用户标识，同入参
@property(nonatomic, strong) NSString *associatedId;
//是否需要补充信息（新注册用户为true）
@property(nonatomic) BOOL needInfo;



@end

NS_ASSUME_NONNULL_END
