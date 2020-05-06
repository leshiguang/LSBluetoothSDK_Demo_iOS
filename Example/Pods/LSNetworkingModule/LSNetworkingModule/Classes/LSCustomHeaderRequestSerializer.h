//
//  LSCustomHeaderRequestSerializer.h
//  Pods
//
//  Created by ouhuowang on 2017/8/4.
//
//

#import <AFNetworking/AFNetworking.h>

@interface LSCustomHeaderRequestSerializer : AFHTTPRequestSerializer
-(void)setupCustomHeader:(NSDictionary<NSString *, NSString *> *)header;
-(void)removeCustomHeader;
@end
