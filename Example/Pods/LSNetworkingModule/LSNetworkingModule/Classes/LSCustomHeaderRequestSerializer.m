//
//  LSCustomHeaderRequestSerializer.m
//  Pods
//
//  Created by ouhuowang on 2017/8/4.
//
//

#import "LSCustomHeaderRequestSerializer.h"

@interface LSCustomHeaderRequestSerializer ()
@property(nonatomic, strong)NSDictionary<NSString *, NSString *> *customHeader;
@end

@implementation LSCustomHeaderRequestSerializer

-(void)setupCustomHeader:(NSDictionary *)header {
    if (!header || ![header isKindOfClass:[NSDictionary class]] || [header count]<=0) {
        return;
    }
    
    _customHeader = [NSDictionary dictionaryWithDictionary:header];
    
}

-(void)removeCustomHeader {
    _customHeader = nil;
}

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(request);
    
    NSURLRequest *spRequest = [super requestBySerializingRequest:request
                                                  withParameters:parameters
                                                           error:error];
    
    NSMutableURLRequest *mutableRequest = [spRequest mutableCopy];
    
    [self.customHeader enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    return mutableRequest;
}

@end
