//
//  LSAuthorizationDelegate.h
//  AFNetworking
//
//  Created by alex.wu on 2020/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LSAuthorizationDelegate  <NSObject>


@required
-(void) onRequest:(NSString *)serviceId andVersion:(NSString *)serviceVersion andMac:(NSString *) mac andModel:(NSString *)model complete:(void (^)(NSInteger))complete;


@end

NS_ASSUME_NONNULL_END
