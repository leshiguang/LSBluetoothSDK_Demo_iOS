//
//  ServerCommunicationManager.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "AFNetworking.h"
#import "HttpErrcode.h"
#import <Foundation/NSJSONSerialization.h>
#import "BaseNetworkError.h"
#import "ServerComunicationManagerInternal.h"
#import "RequestMap.h"
#import "LSBaseRequest.h"
#import "ProtocolSimulator.h"
#import "ErrorObject.h"
#import "LSNetwokingURLCache.h"

#import "LSCustomHeaderRequestSerializer.h"
//#import "AFNetworkReachabilityManager.h"

#define _ServerCommunicationManager_isolation_Begin             \
__weak typeof(self) weakSelf = self; \
[self asyncBlock :^{__strong ServerCommunicationManager *sself = weakSelf;           \
if (sself) {

#define _ServerCommunicationManager_isolation_End \
}                      \
}];

static NSString *const LSDCCAppDidTokenExpiredNotification = @"LSDCCAppDidTokenExpiredNotification";

@interface ServerCommunicationManager()
{
    NSMutableArray* _requestArray;
    
    BOOL _isProtocolSimulatorAvailable;
    
    //Log
    NSMutableArray <NSDictionary *>* _requestLog;
    NSMutableArray <NSDictionary *>* _requestErrorLog;
    
}

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *customSessionManager;
@property (nonatomic, strong) AFURLSessionManager *uploadFileSessionManager;

@property (nonatomic, strong) NSDateFormatter *requestDateForatter;

@property (nonatomic, assign)BOOL isProtocolSimulatorAvailable;

@property (nonatomic,retain) ProtocolSimulator *protoctolSimulator;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSURLSessionTask *> *sendedTaskDict;
@end

@implementation  ServerCommunicationManager

#pragma mark ServerCommunicationManagerProtocol

+(id<ServerCommunicationProtocol>)GetServerCommunication
{
    static __strong ServerCommunicationManager *serverCommunicationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serverCommunicationManager = [[ServerCommunicationManager alloc] init];
        serverCommunicationManager.httpSessionManager = [AFHTTPSessionManager manager];
        serverCommunicationManager.httpSessionManager.completionQueue = serverCommunicationManager.callbackQueue;
        
        AFJSONResponseSerializer *serializerResponse = [AFJSONResponseSerializer serializer];
        serializerResponse.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        serverCommunicationManager.httpSessionManager.responseSerializer = serializerResponse;
        AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
        //[serializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        serializer.timeoutInterval = 30.0f;
        serverCommunicationManager.httpSessionManager.requestSerializer = serializer;
        
        //customManager------------------------
        serverCommunicationManager.customSessionManager = [AFHTTPSessionManager manager];
        serverCommunicationManager.customSessionManager.completionQueue = serverCommunicationManager.callbackQueue;
        
        AFHTTPRequestSerializer *customRequestSerializer = [AFHTTPRequestSerializer serializer];
        customRequestSerializer.timeoutInterval = 30.0f;
        serverCommunicationManager.customSessionManager.requestSerializer = customRequestSerializer;
        
    });
    return serverCommunicationManager;
}

-(NSArray*)getRequestLog {
    return _requestLog.copy;
}

-(NSArray*)getErrorRequestLog {
    return _requestErrorLog.copy;
}

#pragma mark private

-(id)init
{
    self = [super init];
    if (self) {
        _requestArray = [NSMutableArray array];
        _requestErrorLog = [NSMutableArray array];
        _requestLog = [NSMutableArray array];
        _requestArray = [NSMutableArray array];
        _isProtocolSimulatorAvailable = NO;
        _isolationQueueLabel = @"com.ServerCommunicationManager.isolationQueue";
        _isolationQueue = dispatch_queue_create([_isolationQueueLabel UTF8String], DISPATCH_QUEUE_SERIAL);
        _callbackQueue = dispatch_get_main_queue();
        _sendedTaskDict = [[NSMutableDictionary alloc] init];
        
        _isProtocolSimulatorAvailable = NO;
        [self addNetworkingStatusChange];
    }
    return self;
}

-(NSMutableDictionary*)_generateParamsDict:(LSBaseRequest*)request
{
    NSMutableDictionary* ret = request.dataDict;
    return ret;
}

- (AFURLSessionManager *)uploadFileSessionManager {
    if (_uploadFileSessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _uploadFileSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        _uploadFileSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        AFJSONResponseSerializer *serializerResponse = [AFJSONResponseSerializer serializer];
        serializerResponse.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        _uploadFileSessionManager.responseSerializer = serializerResponse;
        _uploadFileSessionManager.completionQueue = self.callbackQueue;
    }
    return _uploadFileSessionManager;
}

- (NSDateFormatter *)requestDateForatter {
    if (_requestDateForatter == nil) {
        _requestDateForatter = [[NSDateFormatter alloc] init];
        _requestDateForatter.dateFormat = @"yyyyMMddHHmmss";
    }
    return _requestDateForatter;
}

#pragma mark - Request by wangwang
- (NSURLSessionDataTask *)requestWithMethod:(NSString *)method
                         requestSessionType:(LSBaseRequestType)requestType
                                  URLString:(NSString *)URLString
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure  {
    
    // Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        success(task, responseObject);
    };
    
    
    NSURLSessionDataTask *task = nil;
    NSString *methodStr = [method uppercaseString];
    AFHTTPSessionManager *sessionManager = self.httpSessionManager;
    
    if (requestType == LSBaseRequestTypeCustom) {
        sessionManager = self.customSessionManager;
    }
    
    
    if ([methodStr isEqualToString:@"GET"]) {
        
        task = [sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
    }
    else if ([methodStr isEqualToString:@"POST"]) {
        
        [sessionManager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(task,error);
        }];
        
    }
    else if ([methodStr isEqualToString:@"PUT"]) {
        task = [sessionManager PUT:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(task,error);
        }];
    }
    else if ([methodStr isEqualToString:@"DELETE"]) {
        task = [sessionManager DELETE:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            failure(task,error);
        }];
    }
    
    return task;
}

- (NSString *)sendRequest:(LSBaseRequest *)request
                  success:(void (^)(NSURLSessionDataTask * _Nullable task, id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    return [self sendRequest:request
        completeWithResponse:^(NSURLSessionDataTask *task, LSBaseResponse *response) {
            success == nil ?: success(task, response.data);
        }
         failureWithResponse:^(NSURLSessionDataTask *task, LSBaseResponse *response) {
             failure == nil ?: failure(response.nsError);
         }];
}

- (NSString *)sendRequest:(LSBaseRequest *)request
                 complete:(void (^)(NSInteger code, NSString *message, id responseData))completeBlock
                  failure:(void (^)(NSError *error))failureBlock {
    
    return [self sendRequest:request
        completeWithResponse:^(NSURLSessionDataTask * _Nullable task, LSBaseResponse *response) {
            completeBlock == nil ?: completeBlock([[response.data objectForKey:@"code"] integerValue], [response.data objectForKey:@"msg"], [response.data objectForKey:@"data"]);
        } failureWithResponse:^(NSURLSessionDataTask *task, LSBaseResponse *response) {
            failureBlock == nil ?: failureBlock(response.nsError);
        }];;
}



- (NSString *)sendRequest:(LSBaseRequest *)request
     completeWithResponse:(void (^)( NSURLSessionDataTask * _Nullable task, LSBaseResponse *response))completeBlock
                  failureWithResponse:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))failureBlock {
    NSString *requestId = [self generateRequestId];
    [request generateRequestToken];
    _ServerCommunicationManager_isolation_Begin
    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(serverCommunicationManager:shouldSendRequest:)]) {
        BOOL sendFlag = [self.eventsDelegate serverCommunicationManager:(id)self shouldSendRequest:request];
        if (!sendFlag) {
            return;
        }
    }
    if ([request.requestUrl length] <= 0) {
        failureBlock == nil ?: failureBlock(nil, nil);
        return ;
    }
    NSString *urlString = [request mergeUrlParameters];
    NSURLSessionDataTask *task = nil;
    NSDictionary *params = [self _generateParamsDict:request];
    //自定义的头需要重新设置
    if ([request.httpHeader count] > 0) {
        [self clearCustomRequestHeader];
        [self setCustomRequestHeader:request.httpHeader];
        request.baseRequestType = LSBaseRequestTypeCustom;
    }
    
    task = [self requestWithMethod:request.method
                requestSessionType:request.baseRequestType
                         URLString:urlString
                        parameters:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               LSBaseResponse *response = [self responseFromRequest:request ResponseData:responseObject];
                               [self tryParseResponseData:response];
                               
                               if (response.ret == RET_SUCCESS) {
                                   if ([response checkParsingVadility]) {
                                       //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                                       if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                                           [self.eventsDelegate communicationManager:(id)self
                                                                  sendRequestSucceed:request
                                                                  didReceiveResponse:response];
                                       }
                                       
                                       completeBlock == nil ?: completeBlock(task, response);
                                   } else {
                                       NSString *dataExpeStr = @"数据异常";
                                       response.ret = RESPONSE_DATA_INVALID;
                                       response.statusCode = -1;
                                       response.msg = dataExpeStr;
                                       response.nsError = [NSError errorWithDomain:@"com.lifesense.LSNetworking"
                                                                              code:-1
                                                                          userInfo:@{
                                                                                     @"msg" : dataExpeStr
                                                                                     }];
                                       
                                       if ([self.eventsDelegate respondsToSelector:@selector(communicationManager:didReceiveInvalidDataResponse:)]) {
                                           [self.eventsDelegate communicationManager:(id)self
                                                       didReceiveInvalidDataResponse:response];
                                       }
                                       
                                       if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                                           [self.eventsDelegate communicationManager:(id)self
                                                                   sendRequestFailed:request
                                                                            response:response];
                                       }
                                       failureBlock == nil ?: failureBlock(task, response);
                                   }
                               } else {
                                   //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                                   if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                                       [self.eventsDelegate communicationManager:(id)self
                                                              sendRequestSucceed:request
                                                              didReceiveResponse:response];
                                   }
                                   completeBlock == nil ?: completeBlock(task, response);
                               }
                               if (request.needsCacheResponse && responseObject && responseObject[@"code"]) {
                                   if ([responseObject[@"code"] intValue] == 200) {
                                       @try {
                                           [[LSNetwokingURLCache shareInstance] cacheResourcesFromThisURL:urlString resource:responseObject];
                                       } @catch (NSException *exception) {
                                           NSLog(@"缓存数据失败%@",exception.description);
                                       } @finally {
                                           
                                       }
                                       
                                   }
                               }
                               
                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               LSBaseResponse *response = [self responseFromRequest:request ResponseData:nil];
                               [self setUpErrorMessageToResponse:response responseStatusCode:error.code withError:error];
                               
                               if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                                   [self.eventsDelegate communicationManager:(id)self
                                                           sendRequestFailed:request
                                                                    response:response];
                               }
                               failureBlock == nil ?: failureBlock(task, response);
                           }];
    [self cacheTask:task requestId:requestId];
    _ServerCommunicationManager_isolation_End
    
    if (request.needsCacheResponse) {
        [[LSNetwokingURLCache shareInstance] resourceOfThisURL:request.requestUrl completeHandler:^(LSNetwokingURLResource * _Nonnull urlResource) {
            LSBaseResponse *response = [self responseFromRequest:request ResponseData:urlResource.resource];
            [self tryParseResponseData:response];
            if (urlResource.resource && completeBlock) {
                completeBlock(nil,response);
            }
        }];
    }
    return requestId;
}


//upload file
- (NSString *)uploadFileWithUrl:(NSString *)urlString
                      withParam:(NSDictionary *)params
                   uploadedData:(NSData *)updata
           upLoadedSaveFileName:(NSString *)filename
                       progress:(void (^)(double progress))progress
                        success:(void (^)(NSInteger code, NSString *msg, id responseData))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
    
    
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.completionQueue = self.callbackQueue;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    NSURLSessionDataTask *sessionTask = [mgr POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString *upFileName = filename;
        if ([upFileName length]<=0) {
            NSString *str = [self.requestDateForatter stringFromDate:[NSDate date]];
            NSString *randStr = [self randomStringForUrl:4];
            upFileName = [str stringByAppendingString:randStr];
        }
        
        [formData appendPartWithFileData:updata name:@"file" fileName:upFileName mimeType:@"multipart/form-data"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        if (progress) {
            double p = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            progress(p);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSString *responseMsg = [responseDict objectForKey:@"msg"];
            NSInteger responseCode = [[responseDict objectForKey:@"code"] integerValue];
            id resultData = [responseDict objectForKey:@"data"];
            if (success) {
                success(responseCode, responseMsg, resultData);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            NSString *netExceptionStr = @"网络异常,请稍后再试";
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:netExceptionStr                                                                      forKey:NSLocalizedDescriptionKey];
            NSError *redefineError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            failureBlock(task, redefineError);
        }
    }];
    
    [sself cacheTask:sessionTask requestId:requestId];
    _ServerCommunicationManager_isolation_End
    return requestId;
}

- (NSString *)uploadFileWithRequest:(LSBaseRequest *)request
                                     uploadedData:(NSData *)updata
                             upLoadedSaveFileName:(NSString *)filename
                                         progress:(void (^)(double progress))progress
                                          success:(void (^)(NSInteger code, NSString *msg, id responseData))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
    
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(serverCommunicationManager:shouldSendRequest:)]) {
        BOOL sendFlag = [self.eventsDelegate serverCommunicationManager:(id)self shouldSendRequest:request];
        if (!sendFlag) {
            return;
        }
    }
    
    NSString* urlString = request.requestUrl;
    
    NSString *paramstr = request.urlAppendingString;
    
    NSString *qmakrstr = @"?";
    NSRange qmarkRang = [urlString rangeOfString:qmakrstr];
    NSRange pmarkRang = [paramstr rangeOfString:qmakrstr];
    if (qmarkRang.location != NSNotFound && pmarkRang.location != NSNotFound) {
        paramstr = [paramstr stringByReplacingOccurrencesOfString:qmakrstr withString:@"&"];
        urlString = [urlString stringByAppendingString:paramstr];
    }
    else {
        urlString = [urlString stringByAppendingString:paramstr];
    }
    
    NSDictionary *params = [self _generateParamsDict:request];
    
    NSMutableURLRequest *fileRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:urlString
                                                                                                 parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                                     [formData appendPartWithFileData:updata
                                                                                                                                 name:@"file"
                                                                                                                             fileName:filename
                                                                                                                             mimeType:@"multipart/form-data"];
                                                                                                 } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self.uploadFileSessionManager uploadTaskWithStreamedRequest:fileRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        if (progress) {
            double p = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            progress(p);
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull urlResponse, id  _Nullable responseObject, NSError * _Nullable error) {
        
        LSBaseResponse *response = [self responseFromRequest:request ResponseData:responseObject];
        if (error) {
            [self setUpErrorMessageToResponse:response responseStatusCode:error.code withError:error];
        } else {
            [self tryParseResponseData:response];
        }
        
        if (error) {
            if (failureBlock){
                if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                    [self.eventsDelegate communicationManager:(id)self sendRequestFailed:request response:response];
                }
                failureBlock(nil, response.nsError);
            }
        } else {
            
            if (response.ret == RET_SUCCESS) {
                if ([response checkParsingVadility]) {
                    //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                               sendRequestSucceed:request
                                               didReceiveResponse:response];
                    }
                    
                    if (success) {
                        success([[response.data objectForKey:@"code"] integerValue], [response.data objectForKey:@"msg"], [response.data objectForKey:@"data"]);
                    }
                    
                } else {
                    response.ret = RESPONSE_DATA_INVALID;
                    response.statusCode = -1;
                    response.msg = @"数据异常";
                    
                    if ([self.eventsDelegate respondsToSelector:@selector(communicationManager:didReceiveInvalidDataResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                    didReceiveInvalidDataResponse:response];
                    }
                    
                    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                                sendRequestFailed:request
                                                         response:response];
                    }
                    failureBlock == nil ?: failureBlock(nil, response.nsError);
                }
            } else {
                //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                    [self.eventsDelegate communicationManager:(id)self
                                           sendRequestSucceed:request
                                           didReceiveResponse:response];
                }
                
                if (success) {
                    success([[response.data objectForKey:@"code"] integerValue], [response.data objectForKey:@"msg"], [response.data objectForKey:@"data"]);
                }
            }
        }
    }];
    
    [uploadTask resume];
    [sself cacheTask:uploadTask requestId:requestId];
    _ServerCommunicationManager_isolation_End;
    return requestId;
}

- (NSString *)downloadWithUrl:(NSString *)urlStr
                 saveFilePath:(NSString *)savePath
                     progress:(void (^)(double progress))progress
                      success:(void (^)(NSURL *url))success
                      failure:(void (^)(NSError *error))fail {
    
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.completionQueue = self.callbackQueue;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                         if (progress) {
                                                                             double p = 100.0f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                                                                             progress(p);
                                                                         }
                                                                     } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                         //如果没有指定  默认到存cache中
                                                                         if (savePath == nil) {
                                                                             NSString * cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                                                                             NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                                                                             
                                                                             return [NSURL fileURLWithPath:path];
                                                                         }
                                                                         else{
                                                                             
                                                                             return [NSURL fileURLWithPath:savePath];
                                                                         }
                                                                     } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                         if (!error) {
                                                                             //下载完成
                                                                             if (success) {
                                                                                 success(filePath);
                                                                             }
                                                                         }
                                                                         else{
                                                                             
                                                                             //下载失败
                                                                             //NSLog(@"%@",error);
                                                                             //NSString *netExceptionStr = @"网络异常,请稍后再试";
                                                                             NSString *netExceptionStr = @"网络异常,请稍后再试";
                                                                             NSDictionary *userInfo = [NSDictionary dictionaryWithObject:netExceptionStr                                                                      forKey:NSLocalizedDescriptionKey];
                                                                             NSError *redefineError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
                                                                             if (fail) {
                                                                                 fail(redefineError);
                                                                             }
                                                                         }
                                                                     }];
    
    [downloadTask resume];
    [sself cacheTask:downloadTask requestId:requestId];
    _ServerCommunicationManager_isolation_End
    return requestId;
}

#pragma mark - 新的上传和下载，使用 LSBaseRequest 和 LSBaseResponse, 20170726
/**
 *  上传文件
 *  参数：request 为上传地址url的封装，和 普通的 LSBaseRequest 一样，其中，二进制文件保存在 LSBaseRequest.binaryDataArray  里面
 *  LSBaseRequest.binaryDataArray 里面保存的每个对象都是NSDictionary,
 *  具体用法请仔细阅读和查看 addBinaryData:(NSData *)updata withFileName:(NSString *)upfilename 函数
 *  注意：progress(double progress) 进度条回调block, double progress是进度 注意，这个数值 已经 乘以 100
 
 */
- (NSString *)uploadWithRequest:(LSBaseRequest *)request
                       progress:(void (^)(double progress))progress
                      completed:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))completeBlock {
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(serverCommunicationManager:shouldSendRequest:)]) {
        BOOL sendFlag = [self.eventsDelegate serverCommunicationManager:(id)self shouldSendRequest:request];
        if (!sendFlag) {
            return;
        }
    }
    
    NSString* urlString = request.requestUrl;
    
    NSString *paramstr = request.urlAppendingString;
    
    NSString *qmakrstr = @"?";
    NSRange qmarkRang = [urlString rangeOfString:qmakrstr];
    NSRange pmarkRang = [paramstr rangeOfString:qmakrstr];
    if (qmarkRang.location != NSNotFound && pmarkRang.location != NSNotFound) {
        paramstr = [paramstr stringByReplacingOccurrencesOfString:qmakrstr withString:@"&"];
        urlString = [urlString stringByAppendingString:paramstr];
    }
    else {
        urlString = [urlString stringByAppendingString:paramstr];
    }
    
    NSDictionary *params = [self _generateParamsDict:request];
    
    if ([request.binaryDataArray count]<=0) {
        NSLog(@"上传的内容为空~~！！！");
        return;
    }
    
    NSDictionary *upfileInfoDict = [request.binaryDataArray objectAtIndex:0];
    if (![upfileInfoDict isKindOfClass:[NSDictionary class]]) {
        NSLog(@"上传的数据设置格式不正确~~！！！");
        return;
    }
    
    NSData *updata = [upfileInfoDict objectForKey:BIANRY_DATA_KEY];
    NSString *filename = [upfileInfoDict objectForKey:FILENAME_KEY];
    
    NSMutableURLRequest *fileRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:urlString
                                                                                                 parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                                     [formData appendPartWithFileData:updata
                                                                                                                                 name:@"file"
                                                                                                                             fileName:filename
                                                                                                                             mimeType:@"multipart/form-data"];
                                                                                                 } error:nil];
    
    NSURLSessionUploadTask *uploadTask = [self.uploadFileSessionManager uploadTaskWithStreamedRequest:fileRequest progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印上传进度
        if (progress) {
            double p = 100.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
            progress(p);
        }
        
    } completionHandler:^(NSURLResponse * _Nonnull urlResponse, id  _Nullable responseObject, NSError * _Nullable error) {
        
        LSBaseResponse *resultResponse = [self responseFromRequest:request ResponseData:responseObject];
        
        if (error) {
            [self setUpErrorMessageToResponse:resultResponse responseStatusCode:error.code withError:error];
            
            if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                [self.eventsDelegate communicationManager:(id)self sendRequestFailed:request response:resultResponse];
            }
            
            if (completeBlock) {
                completeBlock(nil, resultResponse);
            }
            
        } else {    //TODO:上传成功
            [self tryParseResponseData:resultResponse];
        
            if (resultResponse.ret == RET_SUCCESS) {
                if ([resultResponse checkParsingVadility]) {
                    //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                               sendRequestSucceed:request
                                               didReceiveResponse:resultResponse];
                    }
                    
                    if (completeBlock) {
                        completeBlock(nil, resultResponse);
                    }
                    
                } else {
                    NSString *dataExpStr = @"数据异常";
                    resultResponse.ret = RESPONSE_DATA_INVALID;
                    resultResponse.statusCode = -1;
                    resultResponse.msg = dataExpStr;
                    
                    if ([self.eventsDelegate respondsToSelector:@selector(communicationManager:didReceiveInvalidDataResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                    didReceiveInvalidDataResponse:resultResponse];
                    }
                    
                    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                                sendRequestFailed:request
                                                         response:resultResponse];
                    }
                    if (completeBlock) {
                        completeBlock(nil, resultResponse);
                    }
                }
            } else {
                //退出登录或者token失效检测在 onRequestCompleteWithReposeCode 处理。自己实现
                if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                    [self.eventsDelegate communicationManager:(id)self
                                           sendRequestSucceed:request
                                           didReceiveResponse:resultResponse];
                }
                
                if (completeBlock) {
                    completeBlock(nil, resultResponse);
                }
            }
        }
    }];
    
    [uploadTask resume];
    [sself cacheTask:uploadTask requestId:requestId];
    _ServerCommunicationManager_isolation_End;
    return requestId;
}

/**
 *  下载文件
 *  参数：request 为上传地址url的封装，和 普通的 LSBaseRequest 一样。
 *  参数：saveFilePath, 保存路径.没有找到 saveFilePath的保存路径或者属性。暂时多加一个参数
 *  参数：下载保存成功返回的路径（saveFilePath），以id data的形式返回保存的路径,LSBaseResponse.data to NSString
 *  注意：progress(double progress) 进度条回调block, double progress是进度 注意，这个数值 已经 乘以 100
 */
- (NSString *)downloadWithRequest:(LSBaseRequest *)request
                     saveFilePath:(NSString *)savePath
                         progress:(void (^)(double progress))progress
                        completed:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))completeBlock {
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.completionQueue = self.callbackQueue;
    
    NSString* urlString = request.requestUrl;
    
    NSString *paramstr = request.urlAppendingString;
    
    NSString *qmakrstr = @"?";
    NSRange qmarkRang = [urlString rangeOfString:qmakrstr];
    NSRange pmarkRang = [paramstr rangeOfString:qmakrstr];
    if (qmarkRang.location != NSNotFound && pmarkRang.location != NSNotFound) {
        paramstr = [paramstr stringByReplacingOccurrencesOfString:qmakrstr withString:@"&"];
        urlString = [urlString stringByAppendingString:paramstr];
    }
    else {
        urlString = [urlString stringByAppendingString:paramstr];
    }
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]
                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
                                                                         if (progress) {
                                                                             double p = 100.0f * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
                                                                             progress(p);
                                                                         }
                                                                     } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                         //如果没有指定  默认到存cache中
                                                                         if (savePath == nil) {
                                                                             NSString * cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                                                                             NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
                                                                             
                                                                             return [NSURL fileURLWithPath:path];
                                                                         }
                                                                         else{
                                                                             
                                                                             return [NSURL fileURLWithPath:savePath];
                                                                         }
                                                                     } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                         
                                                                         LSBaseResponse *resultResponse = [[LSBaseResponse alloc] init];
                                                                         if (error) {//Download failed
                                                                             NSString *downFaildStr = @"下载失败";
                                                                             resultResponse.ret = RESPONSE_DATA_INVALID;
                                                                             resultResponse.statusCode = -1;
                                                                             resultResponse.msg = downFaildStr;
                                                                         }
                                                                         else { //Download Successfully
                                                                             NSString *downSuccStr = @"下载成功";
                                                                             resultResponse.ret = RET_SUCCESS;
                                                                             resultResponse.statusCode = 200;
                                                                             resultResponse.msg = downSuccStr;
                                                                             
                                                                             NSString *tempSavePath = [filePath absoluteString];
                                                                             NSData *savepathData = [tempSavePath dataUsingEncoding:NSUTF8StringEncoding];
                                                                             resultResponse.data = savepathData;
                                                                         }
                                                                         
                                                                         completeBlock(nil, resultResponse);
                                                                         
                                                                     }];
    
    [downloadTask resume];
    [sself cacheTask:downloadTask requestId:requestId];
    _ServerCommunicationManager_isolation_End
    return requestId;
}


#pragma mark - 非Block请求
- (NSString *)sendRequest:(LSBaseRequest*)request {
    if (!request) {
        return nil;
    }
    
    NSString *requestId = [self generateRequestId];
    
    _ServerCommunicationManager_isolation_Begin
    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(serverCommunicationManager:shouldSendRequest:)]) {
        BOOL sendFlag = [self.eventsDelegate serverCommunicationManager:(id)self shouldSendRequest:request];
        if (!sendFlag) {
            return ;
        }
    }
    
    
    NSString* url = request.requestUrl;
    if ([url length]<=0) {
        NSLog(@"%@%@%@",NSStringFromClass(self.class),@"!!!从配置文件获取requestName为:%@的requestUrl获取失败", request.requestName);
        return;
    }
    
    if (self.isProtocolSimulatorAvailable)
    {
        if ([self.protoctolSimulator sendRequest:request])
        {
            //request.requestId = rid;
            return;
        }
    }
    
    NSString *paramstr = request.urlAppendingString;
    
    NSString *qmakrstr = @"?";
    NSRange qmarkRang = [url rangeOfString:qmakrstr];
    NSRange pmarkRang = [paramstr rangeOfString:qmakrstr];
    if (qmarkRang.location != NSNotFound && pmarkRang.location != NSNotFound) {
        paramstr = [paramstr stringByReplacingOccurrencesOfString:qmakrstr withString:@"&"];
        url = [url stringByAppendingString:paramstr];
    }
    else {
        url = [url stringByAppendingString:paramstr];
    }
    
    NSURLSessionDataTask *task = nil;
    NSDictionary *params = [self _generateParamsDict:request];
    
    if ([request.httpHeader count] > 0) {
        [self clearCustomRequestHeader];
        
        [self setCustomRequestHeader:request.httpHeader];
        request.baseRequestType = LSBaseRequestTypeCustom;
    }
    
    task = [self requestWithMethod:request.method
                requestSessionType:request.baseRequestType
                         URLString:url
                        parameters:params
                           success:^(NSURLSessionDataTask *task, id responseObject) {
                               [self onRequestFinish:request data:responseObject];
                           } failure:^(NSURLSessionDataTask *task, NSError *error) {
                               [self onRequestFail:request responseStatusCode:error.code withError:error];
                           }];
    [sself cacheTask:task requestId:requestId];
    _ServerCommunicationManager_isolation_End
    return requestId;
}

- (void)cancelRequestWithRequestId:(NSString *)requestId {
    
    _ServerCommunicationManager_isolation_Begin
    NSURLSessionTask *task = [self removeTaskForRequestId:requestId];
    if (task) {
        [task cancel];
    }
    _ServerCommunicationManager_isolation_End
}

- (void)setProtocolSimulatorAvailable:(BOOL)available {
    _isProtocolSimulatorAvailable = available;
}

- (BOOL)isProtocolSimulatorAvailable {
    return _isProtocolSimulatorAvailable;
}

-(ProtocolSimulator *)protoctolSimulator{
    if (!_protoctolSimulator) {
        _protoctolSimulator = [[ProtocolSimulator alloc] init];
    }
    return _protoctolSimulator;
}

- (ProtocolSimulator *)getProtocolSimulator {
    if (!_protoctolSimulator) {
        _protoctolSimulator = [[ProtocolSimulator alloc] init];
    }
    return _protoctolSimulator;
}

#pragma mark - func
#pragma mark - 处理请求成功失败

- (void)onRequestFinish:(LSBaseRequest *)request data:(NSData*)data
{
    dispatch_async(self.isolationQueue, ^{
        
        //ADD BY ROLAND
        LSBaseResponse* response = [self responseFromRequest:request ResponseData:data];
        [self tryParseResponseData:response];
    
        
        if(response.ret == RET_SUCCESS) {
            
            if (![response checkParsingVadility]) {
                response.ret = RESPONSE_DATA_INVALID;
                response.statusCode = -1;
                response.msg = @"数据异常";
            } else {
                response.error = nil;
                dispatch_async(self.callbackQueue, ^{
                    if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestSucceed:didReceiveResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                               sendRequestSucceed:request
                                               didReceiveResponse:response];
                    }
                    [request.delegate onRequestSuccess:response];
                });
            }
        }
        
        if (response.ret != RET_SUCCESS) {
            if (![self shouldIgnoreResponseError:response])
            {
                if (response.error == nil)
                {
                    response.error = [BaseNetworkError errorWithHttpStatusCode:response.statusCode serverReturnValue:response.ret serverErrorCode:response.errcode serverErrorType:RESPONSE_PARSE_RET_ERROR serverErrorMsg:response.msg];
                }
                else
                {
                    response.error.serverErrorType = RESPONSE_PARSE_RET_ERROR;
                }
            }
            
            if (response.ret == RESPONSE_DATA_INVALID) {
                
                dispatch_async(self.callbackQueue, ^{
                    if ([self.eventsDelegate respondsToSelector:@selector(communicationManager:didReceiveInvalidDataResponse:)]) {
                        [self.eventsDelegate communicationManager:(id)self
                                    didReceiveInvalidDataResponse:response];
                    }
                });
            }
            
            dispatch_async(self.callbackQueue, ^{
                if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                    [self.eventsDelegate communicationManager:(id)self
                                            sendRequestFailed:request
                                                     response:response];
                }
                [request.delegate onRequestFail:response];
            });
        }
        
        [self removeSendRequestInfo:request];
        //从数组中删除
    });
}

- (void)onRequestFail:(LSBaseRequest *)request responseStatusCode:(NSInteger)statuscode withError:(NSError *)error
{
    dispatch_async(self.isolationQueue, ^{
        //返回错误
        
        //ADD BY WenZhneg Zhang
        LSBaseResponse* response = [self responseFromRequest:request ResponseData:nil];
        [self setUpErrorMessageToResponse:response responseStatusCode:statuscode withError:error];
        
        if(request.delegate) {
            dispatch_async(self.callbackQueue, ^{
                if (self.eventsDelegate && [self.eventsDelegate respondsToSelector:@selector(communicationManager:sendRequestFailed:response:)]) {
                    [self.eventsDelegate communicationManager:(id)self
                                            sendRequestFailed:request
                                                     response:response];
                }
                [request.delegate onRequestFail:response];
            });
        }
        //从数组中删除
        [self removeSendRequestInfo:request];
    });
}
- (void)setUpErrorMessageToResponse:(LSBaseResponse *)response
                 responseStatusCode:(NSInteger)statuscode
                          withError:(NSError *)error {
    response.ret = RET_DEFAULT_ERROR;
    
    if (statuscode == kHttpStatusCodeRequstErrorRequestTimeout || statuscode == kHttpStatusCodeServerErrorGatewayTimeout || (error && [error code] == -1001)) {
        NSString *netTimeOutStr = @"网络链接超时";
        response.error = [BaseNetworkError errorWithHttpStatusCode:statuscode serverReturnValue:RET_DEFAULT_ERROR serverErrorCode:0 serverErrorType:REQUEST_TIMEOUT serverErrorMsg:netTimeOutStr];
        response.msg = netTimeOutStr;
    }
    else if (statuscode == kHttpStatusCodeRequstErrorNotFound || statuscode == kHttpStatusCodeRequstErrorForbidden || statuscode == kHttpStatusCodeServerErrorBadGateway) {
        NSString *netExceptionStr = @"网络异常,请稍后再试";
        response.error = [BaseNetworkError errorWithHttpStatusCode:statuscode serverReturnValue:RET_DEFAULT_ERROR serverErrorCode:0 serverErrorType:REQUEST_CONNECTION_FAILED serverErrorMsg: netExceptionStr];
        response.msg = netExceptionStr;
    }
    else {
        NSString *netExcpStr = @"网络异常,请稍后再试";
        response.error = [BaseNetworkError errorWithHttpStatusCode:statuscode serverReturnValue:RET_DEFAULT_ERROR serverErrorCode:0 serverErrorType:COMMON_NETWORK_ERROR serverErrorMsg:netExcpStr];
        response.msg = netExcpStr;
    }
    
    //        if (error) {
    //            response.error.nativeError = error;
    //        }
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey:response.msg};
    NSError *nError = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
    response.nsError = nError;
    response.statusCode = statuscode;
}

- (BOOL)shouldIgnoreResponseError:(LSBaseResponse*)response
{
    if (response.ret == RET_NO_NEW_SOFTWARE_VERSION)
    {
        return YES;
    }
    return NO;
}

- (LSBaseRequest*)findSendRequestInfoById:(NSUInteger)rid
{
#ifdef DEBUG
    NSAssert(dispatch_get_current_queue() == self.isolationQueue, @"只能在isolationQueue中调用此方法");
#endif
    
    for(int i=0;i<[_requestArray count];++i)
    {
        LSBaseRequest* info = (LSBaseRequest*)[_requestArray objectAtIndex:i];
        if(info.requestId == rid)
            return info;
    }
    return nil;
}

-(LSBaseResponse*) responseFromRequest:(LSBaseRequest*)request  ResponseData:(NSData*)responseData
{
    LSBaseResponse *response = nil;
    NSString *responseName = request.responseName;
    
    if (responseName == nil || responseName.length <= 0)
    {
    }
    else
    {
        response = [self getResponseInstanceFromResponseName:responseName];
        response.data = responseData;
    }
    
    if (response == nil) {
        response = [[LSBaseResponse alloc] init];
        response.data = responseData;
        response.ret = RET_DEFAULT_ERROR;
        response.error = [BaseNetworkError errorWithHttpStatusCode:kHttpStatusCodeSucceedOK serverReturnValue:RET_DEFAULT_ERROR serverErrorCode:0 serverErrorType:RESPONSE_TYPE_NOFOUND serverErrorMsg:@""];
    }
    response.request = request;
    return response;
}

- (void)tryParseResponseData:(LSBaseResponse *)response {
    @try{
        [response parse];
    }
    @catch(NSException* e)
    {
        response.ret = RESPONSE_PARSE_ERROR;
        NSLog(@"Parse response %@",[NSString stringWithFormat:@"%@_%@",@"!!!json解析异常!!!/n",e.reason]);
    }
}

- (void)removeSendRequestInfo:(LSBaseRequest*)info
{
#ifdef DEBUG
    NSAssert(dispatch_get_current_queue() == self.isolationQueue, @"只能在isolationQueue中调用此方法");
#endif
    [_requestArray removeObject:info];
}

-(LSBaseResponse*) getResponseInstanceFromResponseName:(NSString *)responseName
{
    LSBaseResponse *response = nil;
    
    NSString *responseClassName = responseName;
    if (responseClassName)
    {
        response = [[NSClassFromString(responseClassName) alloc] init];
    }
    
    if(responseClassName==nil || response==nil)
    {
        NSLog(@"%@ %@",NSStringFromClass(self.class), @"responseClassName or response is nil");
    }
    
    return response;
}

-(void)setEventsDelegate:(id<ServerCommunicationEventsDelegate>)eventsDelegate {
    _eventsDelegate = eventsDelegate;
}

#pragma mark - randrom string
-(NSString *)randomStringForUrl:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSInteger letterCount = [letters length];
    u_int32_t letterLen = (u_int32_t)letterCount;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    
    for (int i=0; i<length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform(letterLen)]];
    }
    
    return randomString;
}

- (NSString *)generateRequestId {
    return [[NSUUID UUID] UUIDString];
}


- (void)asyncBlock:(void (^)(void))block {
    dispatch_async(self.isolationQueue, block);
}

#pragma mark - cache task
- (void)cacheTask:(NSURLSessionTask *)task requestId:(NSString *)requestId {
    if (task && requestId) {
        [self.sendedTaskDict setObject:task forKey:requestId];
    }
}

- (NSURLSessionTask *)removeTaskForRequestId:(NSString *)requestId {
    if (requestId == nil) return nil;
    NSURLSessionTask *task = [self.sendedTaskDict objectForKey:requestId];
    return task;
}

#pragma mark - temp bundle for Localize function
- (NSString *)bundleString:(NSString *)key{
    NSBundle *bundle =  [NSBundle bundleForClass:self.class];
    //NSError *bundleErr ;
    NSBundle *resourceBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"Resources" ofType:@"bundle"]];//Resources.bundle
    //[resourceBundle loadAndReturnError:&bundleErr];
    //NSLog(@"loadAndReturnError = %@", bundleErr);
    NSString *localizabileStr = key;
    
    if (resourceBundle) {
        localizabileStr = NSLocalizedStringFromTableInBundle(key, @"Localizable", resourceBundle, nil);
    }
    else {
        resourceBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"Resources.bundle/LSNetowrkingModule" ofType:@"bundle"]];
        localizabileStr = NSLocalizedStringFromTableInBundle(key, @"Localizable", resourceBundle, nil);
    }
    
    return localizabileStr;
    
}

#pragma mark - 添加自定义的http header
/**
 *  添加自定义的http header,
 *  参数：header NSDictionary<NSString *, NSString *> *header
 */
-(void)setCustomRequestHeader:(NSDictionary<NSString *, NSString *> *)header {
    NSArray *allkeys = [header allKeys];
    for (NSString *key in allkeys) {
        NSString *val = [header objectForKey:key];
        [self.customSessionManager.requestSerializer setValue:val forHTTPHeaderField:key];
    }
}

-(void)clearCustomRequestHeader {
    AFHTTPRequestSerializer *customRequestSerializer = [AFHTTPRequestSerializer serializer];
    customRequestSerializer.timeoutInterval = 30.0f;
    self.customSessionManager.requestSerializer = customRequestSerializer;
}

#pragma mark - Networking change Notification
-(void)addNetworkingStatusChange {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LSNetworkingStatusChangeNotification object:[NSNumber numberWithInteger:status]];
    }];
}

#pragma mark Networking Status
+(BOOL)isReachable {
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}

+(BOOL)isReachableViaWWAN {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWWAN];
}

+(BOOL)isReachableViaWiFi {
    return [[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi];
}

+(void)startNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

+(void)stopNetworkMonitoring {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

+(void)networkingStatusChange:(void (^)(AFNetworkReachabilityStatus status))changeBlock {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (changeBlock) {
            changeBlock(status);
        }
    }];
}
@end
