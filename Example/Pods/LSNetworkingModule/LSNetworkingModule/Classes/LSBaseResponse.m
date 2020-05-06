//
//  LSBaseResponse.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "LSBaseResponse.h"

@implementation LSBaseResponse
@synthesize ret = _ret;
@synthesize msg = _msg;
@synthesize data = _data;
@synthesize request = _request;
@synthesize statusCode = _statusCode;
@synthesize error = _error;
@synthesize errcode = _errcode;
@synthesize nsError = _nsError;

-(id)init
{
    self = [super init];
    if (self) {
        self.ret = RET_DEFAULT_ERROR;
        _errcode = 0;
    }
    return self;
}

-(void)dealloc
{
    _data = nil;
    _request = nil;
    _msg = nil;
    _error = nil;
}

-(void)parse
{
    
}

- (BOOL)checkParsingVadility {
    return YES;
}

@end

