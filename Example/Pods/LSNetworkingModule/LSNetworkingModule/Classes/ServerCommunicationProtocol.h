//
//  ServerCommunicationProtocol.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSBaseRequest.h"
#import "ServerCommunicationDelegate.h"
#import "ServerCommunicationEventsDelegate.h"
#import "ProtocolSimulator.h"
#import "AFNetworkReachabilityManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ServerCommunicationProtocol <NSObject>


/**
 *  发送请求，线程安全
 *
 *  参数：request 请求对象
 *
 *  返回：请求Id
 */
- (NSString *)sendRequest:(LSBaseRequest*)request;

/*
 发送请求, block
 */
-(NSString *)sendRequest:(LSBaseRequest *)request
                             success:(void (^)(NSURLSessionDataTask * _Nullable task, id responseObject))success
                             failure:(void (^)(NSError *error))failure;

- (NSString *)sendRequest:(LSBaseRequest *)request
                             complete:(void (^)(NSInteger code, NSString *message, id responseData))completeBlock
                              failure:(void (^)(NSError *error))failureBlock;


- (NSString *)sendRequest:(LSBaseRequest *)request
                 completeWithResponse:(void (^)(NSURLSessionDataTask * _Nullable task, LSBaseResponse *response))completeBlock
                  failureWithResponse:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))failureBlock;


#pragma mark - 文件上传和下载，为了兼容，暂时保留
//文件上传， 统一为POST
/**
 *  上传文件
 *  参数：urlString 为上传地址，
 *  参数：body参数，可以为空
 *  参数：updata, 上传的二进制文件
 *  参数：filename   文件名
    注意：progress(double progress) 进度条回调block, double progress是进度百分比, 注意，这个数值 已经 乘以 100.
 */
- (NSString *)uploadFileWithUrl:(NSString *)urlString
                                  withParam:(NSDictionary *)params
                               uploadedData:(NSData *)updata
                       upLoadedSaveFileName:(NSString *)filename
                                   progress:(void (^)(double progress))progress
                                    success:(void (^)(NSInteger code, NSString *msg, id responseData))success
                                    failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

/**
 *  上传文件
 *  参数：request 为上传地址url的封装，和 普通的 LSBaseRequest 一样，
 *  参数：updata, 上传的二进制文件
 *  参数：filename   文件名
 *  注意：progress(double progress) 进度条回调block, double progress是进度 注意，这个数值 已经 乘以 100
 */
- (NSString *)uploadFileWithRequest:(LSBaseRequest *)request
                                     uploadedData:(NSData *)updata
                             upLoadedSaveFileName:(NSString *)filename
                                         progress:(void (^)(double progress))progress
                                          success:(void (^)(NSInteger code, NSString *msg, id responseData))success
                                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock ;

/**
 *  下载文件
 *  参数：urlString, 下载文件的地址
 *  参数：saveFilePath, 保存路径
 *  参数：url, 下载保存成功返回的路径（saveFilePath），以rul的形式返回
 *  注意：progress(double progress) 进度条回调block, double progress是进度 注意，这个数值 已经 乘以 100
 */
- (NSString *)downloadWithUrl:(NSString *)urlStr
                                 saveFilePath:(NSString *)savePath
                                     progress:(void (^)(double progress))progress
                                      success:(void (^)(NSURL *url))success
                                      failure:(void (^)(NSError *error))fail;

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
                      completed:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))completeBlock;

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
                        completed:(void (^)(NSURLSessionDataTask *task, LSBaseResponse *response))completeBlock;


#pragma mark - ==========================
/**
 *  取消请求，线程安全
 *  参数：requestId 请求Id
 */
- (void)cancelRequestWithRequestId:(NSString *)requestId;


#pragma mark - 协议模拟
/**
 *  是否启动协议模拟，尚未实现
 *  参数：available YES启动，NO不启动
 */
- (void)setProtocolSimulatorAvailable:(BOOL)available;

/**
 *  是否支持协议模拟，尚未实现
 *  返回：YES表示支持，NO不支持
 */
- (BOOL)isProtocolSimulatorAvailable;

/**
 *  获取协议模拟器，尚未实现
 *  协议模拟器
 */
- (ProtocolSimulator*)getProtocolSimulator;

#pragma mark - 添加自定义的http header
/**
 *  添加自定义的http header,
 *  注意：header NSDictionary<NSString *, NSString *> *header
 */
-(void)setCustomRequestHeader:(NSDictionary<NSString *, NSString *> *)header;
-(void)clearCustomRequestHeader;


@property (nonatomic, weak) id<ServerCommunicationEventsDelegate> eventsDelegate;
@end

NS_ASSUME_NONNULL_END
