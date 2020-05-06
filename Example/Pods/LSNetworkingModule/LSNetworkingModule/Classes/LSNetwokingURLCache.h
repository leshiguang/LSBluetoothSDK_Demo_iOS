//
//  LSNetwokingURLCache.h
//
//  Created by ShunQing Cao on 2019/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSNetwokingURLResource : NSObject

@property (nonatomic, assign) BOOL used;
@property (nonatomic) id resource;

@end

@interface LSNetwokingURLCache : NSObject

@property (nonatomic, copy, nullable) NSString *resourcesIdentifier; //缓存分区标识

+ (instancetype)shareInstance;

- (void)cacheResourcesFromThisURL:(NSString *)url resource:(id)resource;
- (void)resourceOfThisURL:(NSString *)url completeHandler:(void (^)(LSNetwokingURLResource *urlResource))completeHandler;

- (id)queryResourceFromThisURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
