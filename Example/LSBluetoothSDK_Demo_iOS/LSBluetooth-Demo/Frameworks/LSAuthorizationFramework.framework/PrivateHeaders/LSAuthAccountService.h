//
//  LSAccuntService.h
//  AFNetworking
//
//  Created by alex.wu on 2020/5/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#define LSAAS_USERID [LSAuthAccountService sharedInstance].userId;

@interface LSAuthAccountService : NSObject

@property (nonatomic) NSUInteger userId;               // 用户ID
@property (nonatomic, strong) NSString *accessToken;   // 登录token
@property (nonatomic, assign) BOOL needInfo;      // 是否为新注册后关联（新注册用户为true
@property (nonatomic, strong) NSString *associatedId;  // 外部用户标识，同入参

+ (instancetype)sharedInstance;

- (void)clear;
@end

NS_ASSUME_NONNULL_END
