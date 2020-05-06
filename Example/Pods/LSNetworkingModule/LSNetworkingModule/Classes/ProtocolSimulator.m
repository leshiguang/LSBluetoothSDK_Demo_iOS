//
//  ProtocolSimulator.m
//  LSWearable
//
//  Created by rolandxu on 15/12/27.
//  Copyright © 2015年 lifesense. All rights reserved.
//

#import "ProtocolSimulator.h"
#import "ConfigFileCenter.h"
#import "ServerCommunicationManager.h"
#import "ServerComunicationManagerInternal.h"

@interface ProtocolSimulator()
{
    ConfigFileCenter* _fileCenter;
}
@end

#define PROTOCOL_SIMULATOR_FILE_PATH @"protocol/protocolSimulator"
#define FILE_KEY_PROTOCOL_INFO_RESPONSE  @"response"

@interface ProtocolSimulator ()
{
    NSMutableDictionary * _responseDataDic;
}

@property (nonatomic, retain) NSMutableDictionary * responseDataDic;

@end

@implementation ProtocolSimulator

#pragma mark - NSObject
- (id)init
{
    self  = [super init];
    if (self)
    {
        self.responseDataDic = [[NSMutableDictionary alloc] init] ;
        _fileCenter = [[ConfigFileCenter alloc] init];
        
        [self prepareResoponseData];
    }
    return  self;
}

- (void)dealloc
{
    self.responseDataDic = nil;
    _fileCenter = nil;
}

#pragma mark - Public

- (BOOL)sendRequest:(LSBaseRequest *)request;
{
    NSString * requestName = request.requestName;
    
    NSString * responseData = [self.responseDataDic objectForKey:requestName];
    
    if ([responseData length] > 0)
    {
        //开个线程去跑
        dispatch_queue_t concurrentQueue = dispatch_get_main_queue();//dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(concurrentQueue, ^{
            [self handleRequest:request responseData:responseData];
        });
        //        //增加一个5秒内的随机返回和延迟
        //        unsigned long long second = rand() %3;
        //        dispatch_time_t time = dispatch_time ( DISPATCH_TIME_NOW , second * NSEC_PER_SEC ) ;
        //        dispatch_after(time,concurrentQueue, ^{
        //            [self handleRequest:request responseData:responseData];
        //        });
        
        return true;
    }
    return false;
}

#pragma mark - Private
- (void)prepareResoponseData
{
    ConfigFileCenter * fileCenter = _fileCenter;
    
    NSString * fakeDataJson = [fileCenter readConfigWithSubPath:PROTOCOL_SIMULATOR_FILE_PATH];
    
    NSDictionary * fakeDataJsonDic = nil;

    NSData* data = [fakeDataJson dataUsingEncoding:NSUTF8StringEncoding];
    fakeDataJsonDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if (fakeDataJsonDic)
    {
        NSDictionary * resoponseDic = [fakeDataJsonDic objectForKey:FILE_KEY_PROTOCOL_INFO_RESPONSE];
        NSArray * responseKeysArr = [resoponseDic allKeys];
        
        for (NSInteger i=0; i<[responseKeysArr count]; i++)
        {
            NSString * responseKey = [responseKeysArr objectAtIndex:i];
            NSError* error = nil;
            NSData* data = [NSJSONSerialization dataWithJSONObject:[resoponseDic objectForKey:responseKey] options:NSJSONWritingPrettyPrinted error:&error];
            if (error == nil) {
                NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                [self.responseDataDic setValue:responseString forKey:responseKey];
            }
        }
    }
}

- (void)handleRequest:(LSBaseRequest *)request responseData:(NSString *)resopnseData
{
    LSBaseResponse* response = [(ServerCommunicationManager *)[ServerCommunicationManager GetServerCommunication] responseFromRequest:request ResponseData:[resopnseData dataUsingEncoding:NSUTF8StringEncoding]];
    response.request = request;
    
    [response parse];
    
    if(response.ret==RET_SUCCESS)
    {
        response.error = nil;
        
        [request.delegate onRequestSuccess:response];
    }else
    {
        [request.delegate onRequestFail:response];
    }
}


- (void)setResponseUTF8String:(NSString*)data forRequestName:(NSString*)requestName;
{
    [self.responseDataDic setObject:data forKey:requestName];
}

-(void)removeResponseUTF8StringForRequestName:(NSString*)requestName
{
    [self.responseDataDic removeObjectForKey:requestName];
}
@end
