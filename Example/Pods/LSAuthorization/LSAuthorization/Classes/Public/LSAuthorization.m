//
//  LSAuthorization.m
//  LSAuthorization
//
//  Created by alex.wu on 2020/3/3.
//

#import "LSAuthorization.h"
#import <LSAuthorizationFramework/LSAuthorizationService.h>
#import <LSAuthorizationFramework/LSAuthorizationDelegate.h>
#import "LSAuthorizeRequest.h"
#import "LSAuthorizeResponse.h"
#import "ServerCommunicationManager.h"
#import "LSProtocolPathUtils.h"
@interface LSAuthorization() <LSAuthorizationDelegate>

@end
@implementation LSAuthorization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[RequestMap shareInstance] addProtocolWithFilePath:getProtocolPath(self, @"LSAuthorization", @"Protocols/LSAuthorizationProtocols")];
        [[LSAuthorizationService sharedInstance] addDelagate:self];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static __strong LSAuthorization *authorization = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorization = [[LSAuthorization alloc] init];
    });
    return authorization;
}
- (void)authorizeDevice:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *)mac andModel:(NSString*)model withBlock:(nonnull void (^)(LSAccessCode))complete {
    [[LSAuthorizationService sharedInstance] authorizeDevice:serviceId andVersion:serviceVersion andMac:mac andModel:model withBlock:^(NSInteger ret) {
        complete(ret);
    }];
}


- (void)authorize:(NSString *)serviceId andVersion:(NSString *)serviceVersion withBlock:(void (^)(LSAccessCode))complete {
    [[LSAuthorizationService sharedInstance] authorize:serviceId andVersion:serviceVersion withBlock:^(NSInteger ret) {
        complete(ret);
    }];
}

- (void)onRequest:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *) mac  andModel:(NSString*)model complete:(nonnull void (^)(NSInteger))complete {
    LSAuthorizeRequest *request = [[LSAuthorizeRequest alloc] init:serviceId andVersion:serviceVersion andMac:mac andModel:model];
    [[ServerCommunicationManager GetServerCommunication] sendRequest:request success:^(NSURLSessionDataTask * _Nullable task, NSDictionary*  _Nonnull responseObject) {
        if (!responseObject || !responseObject[@"code"]) {
          complete(-1);
          return ;
        }
        NSNumber *code = (NSNumber *)responseObject[@"code"];
        complete(code.intValue);
    } failure:^(NSError * _Nonnull error) {
        complete(500);
    }];
}

@end
