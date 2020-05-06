//
//  LSAuthorizeRequest.m
//  LSAuthorization
//
//  Created by alex.wu on 2020/3/3.
//

#import "LSAuthorizeRequest.h"


@implementation LSAuthorizeRequest



- (instancetype)init:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *)mac {
    self = [super init];
    if (self) {
        self.method = HTTP_POST;
        self.requestName = @"LSAuthorizeRequest";
        self.needToPublicParameters = YES;
        self.accountNeedToLogin = NO;
        self.serviceId = serviceId;
        self.serviceVersion = serviceVersion;
        self.mac = mac;
        self.platform = 1;
        self.appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LX_APPID"];
        self.artifactId = [NSBundle mainBundle].bundleIdentifier;
        self.urlAppendingString = @"";
    }
    return self;
}

-(void) setPlatform:(NSInteger) platform {
    [self addDictionaryValue:@{@"platform" : @(1)}];
}

-(void) setAppId:(NSString * _Nonnull)appId {
    [self addDictionaryValue:@{@"appId" : appId}];
}

-(void) setMac:(NSString *)mac {
    [self addDictionaryValue:@{@"mac" : mac}];
}

-(void) setServiceId:(NSString * _Nonnull)serviceId {
    [self addDictionaryValue:@{@"serviceId" : serviceId}];
}


-(void) setServiceVersion:(NSString * _Nonnull)serviceVersion {
    [self addDictionaryValue:@{@"serviceVersion" : serviceVersion}];
}

-(void) setArtifactId:(NSString * _Nonnull)artifactId {
    [self addDictionaryValue:@{@"artifactId" : artifactId}];
}

@end
