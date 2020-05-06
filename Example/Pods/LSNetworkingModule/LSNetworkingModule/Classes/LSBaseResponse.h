//
//  LSBaseResponse.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNetworkError.h"

@class LSBaseRequest;
@interface LSBaseResponse : NSObject
{
    id _data;
    LSBaseRequest* _request;
    BaseNetworkError* _error;
    NSError *_nsError;
    NSString *_msg;
    NSInteger _errcode;
}
@property (nonatomic, assign) ServerReturnValue ret;
@property (nonatomic, retain) NSString* msg;
@property (nonatomic, assign) NSInteger errcode;
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, retain) BaseNetworkError* error;
@property (nonatomic, retain) NSError *nsError;
@property (nonatomic, retain) id data;
@property (nonatomic, retain) LSBaseRequest* request;

-(void)parse;


/**
 检查解析的数据是否合法
 
 @return 数据是否合法, 默认YES
 */
- (BOOL)checkParsingVadility;
@end
