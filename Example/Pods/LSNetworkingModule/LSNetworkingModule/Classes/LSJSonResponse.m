//
//  LSJSonResponse.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "LSJSonResponse.h"
#import "LSBaseRequest.h"

static NSString *const AppTokenInvalidName = @"AppTokenInvalidKey";

@implementation LSJSonResponse
@synthesize datadict = _datadict;
-(id)init
{
    self = [super init];
    if (self) {
        _datadict = [[NSDictionary alloc] init];
        _msg = @"no message";
    }
    return self;
}

-(void)dealloc
{
    _datadict = nil;
}

- (void)parse
{
    [super parse];
    
    if (self.data) {
        NSDictionary* origindict = (NSDictionary*)self.data;
        self.datadict = (NSDictionary *)[origindict objectForKey:@"data"];
        
        //int ret = LSGetDictionaryInt(origindict, PROTOCOL_JSON_KEY_RET, RET_DEFAULT_ERROR);
        int ret = [[origindict objectForKey:PROTOCOL_JSON_KEY_RET] intValue];
        [self setStatusCode:ret];
        [self setRet:(ret != RET_SUCCESS)?RET_DEFAULT_ERROR:RET_SUCCESS];
        
        NSString *msgStr = [origindict objectForKey:PROTOCOL_JSON_KEY_MSG];
        if (![msgStr isKindOfClass:[NSString class]]) {
            msgStr = @"";
        }
        
        [self setMsg:msgStr];
        
        
//        //这里会根据code转换为具体语言的MSG
//        NSString *codeKey = [NSString stringWithFormat:@"ResponseStatusCode%ld",self.statusCode];
//        [self setMsg:LSLocalizedString(codeKey, nil)];
        
        if (self.ret == RET_DEFAULT_ERROR) {
            NSLog(@"URLERRORMESSAGE  url:%@ error:%ld msg:%@",self.request.requestUrl,(long)self.errcode,self.msg);
            
            //        //如果返回 401
            if (self.statusCode == RET_TOKEN_OVERTIME) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AppTokenInvalidName object:self.msg];
            }
            //
        }
    }
    return;
    
}

@end
