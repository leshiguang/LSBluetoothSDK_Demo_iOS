//
//  RequestInfo.h
//  BaseNetworkDemo
//
//  Created by boluobill on 16/1/23.
//  Copyright © 2016年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ReqeustMethod) {
    ReqeustMethodGet = 0,
    ReqeustMethodPost
};



@interface RequestInfo : NSObject

@property(nonatomic,assign)ReqeustMethod method;  //请求方法 get或post
@property(nonatomic,strong)NSString *requestName; //网络命令如登录传个 @"login"命令进来
@property(nonatomic,strong)NSDictionary *parameters;//网络请求参数
@property(nonatomic,assign)BOOL isNeedAccessToken;//是否需要
@property(nonatomic,assign)BOOL isNeedClientId;



@end
