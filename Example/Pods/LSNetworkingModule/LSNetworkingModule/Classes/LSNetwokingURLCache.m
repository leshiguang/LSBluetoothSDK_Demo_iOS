//
//  LSNetwokingURLCache.m
//
//  Created by ShunQing Cao on 2019/9/25.
//

static NSString *const LSNetwokingURLCacheResourcesKey = @"NetworkResources";

#import "LSNetwokingURLCache.h"
#import <CommonCrypto/CommonDigest.h>

@implementation LSNetwokingURLResource

@end

@interface LSNetwokingURLCache ()
@property (nonatomic) NSMutableDictionary *memoryCaches;
@property (nonatomic, copy) NSString *diskPath;
@property (nonatomic) dispatch_queue_t ioQueue;
@property (nonatomic) NSFileManager *fileManager;
@end

@implementation LSNetwokingURLCache

+ (instancetype)shareInstance{
    static id shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc]init];
    });
    return shareInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.memoryCaches = [NSMutableDictionary dictionary];
        self.ioQueue = dispatch_queue_create("com.lsw.LSNetwokingURLCache", DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(_ioQueue, ^{
            self.fileManager = [NSFileManager new];
        });
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearMemory)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Cache Method
- (void)cacheResourcesFromThisURL:(NSString *)url resource:(id)resource{
    NSParameterAssert(url);
    NSParameterAssert(resource);
    
    if (![url isKindOfClass:[NSString class]] || url.length == 0)
    {
        return;
    }
    
    dispatch_async(self.ioQueue, ^{
        @autoreleasepool {
            if (![self.fileManager fileExistsAtPath:self.diskPath]) {
                [self.fileManager createDirectoryAtPath:self.diskPath withIntermediateDirectories:YES attributes:nil error:NULL];
            }
            
            NSURL *surl = [NSURL URLWithString:url];
            
            NSMutableString *pureURL = [[NSMutableString alloc]init];
            if ([surl scheme] && [surl scheme].length > 0) {
                [pureURL appendString:[surl scheme]];
                [pureURL appendString:@"://"];
            }
            [pureURL appendString:[surl host]];
            [pureURL appendString:[surl path]];
            
            NSString *filename = [self cachedFileNameForKey:pureURL];
            
            LSNetwokingURLResource *urlResource = [self.memoryCaches objectForKey:filename];
            if (!urlResource) {
                urlResource = [[LSNetwokingURLResource alloc]init];
            }
            urlResource.resource = resource;
            urlResource.used = YES;
   
            [self.memoryCaches setObject:urlResource forKey:filename];
            
            NSData *content;
            @try {
               content = [NSJSONSerialization dataWithJSONObject:resource options:0 error:nil];
            } @catch (NSException *exception) {
                NSLog(@"网络缓存添加失败:%@",exception.description);
                return ;
            } @finally {
                
            }

            NSString *cachePathForKey = [self.diskPath stringByAppendingPathComponent:filename];
            [self.fileManager createFileAtPath:cachePathForKey contents:content attributes:nil];
            
            NSURL *fileURL = [NSURL fileURLWithPath:cachePathForKey];
            [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
        }
    });
}

#pragma mark - Read Method
- (void)resourceOfThisURL:(NSString *)url completeHandler:(void (^)(LSNetwokingURLResource *urlResource))completeHandler
{
    NSParameterAssert(url);
    
    if (!url) {
        return;
    }
    
    NSString *filename = [self cachedFileNameForKey:url];
    
    LSNetwokingURLResource *urlResource = [self.memoryCaches objectForKey:filename];
    if (urlResource && urlResource.used) {
        return;
    }
    else if (!urlResource){
        urlResource = [[LSNetwokingURLResource alloc]init];
    }
    else if (!urlResource.used){
        if (completeHandler) {
            completeHandler(urlResource);
        }
        urlResource.used = YES;
        return;
    }
    
    NSString *cachePathForKey = [self.diskPath stringByAppendingPathComponent:filename];
    NSData *responseData = [NSData dataWithContentsOfFile:cachePathForKey options:NSDataReadingMappedIfSafe error:nil];
    
    if (!responseData) {
        return;
    }
    
    id responseObject = [self parseObject:responseData];
    if (!responseObject) {
        return;
    }
    
    urlResource.resource = responseObject;
    [self.memoryCaches setObject:urlResource forKey:filename];
    
    if (completeHandler) {
        completeHandler(urlResource);
    }
    
    urlResource.used = YES;
}

- (id)queryResourceFromThisURL:(NSString *)url{
    NSString *filename = [self cachedFileNameForKey:url];
    LSNetwokingURLResource *memoryResource = self.memoryCaches[filename];
    if (memoryResource) {
        return memoryResource.resource;
    }
    NSString *cachePathForKey = [self.diskPath stringByAppendingPathComponent:filename];
    NSData *responseData = [NSData dataWithContentsOfFile:cachePathForKey options:NSDataReadingMappedIfSafe error:nil];
    
    if (!responseData) {
        return nil;
    }
    
    return [self parseObject:responseData];
}


- (id)parseObject:(id)object{
    NSError *error;
    id responseObject;
    @try {
        responseObject = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:&error];
    } @catch (NSException *exception) {
        NSLog(@"网络缓存解析失败:%@",exception.description);
        return nil;
    }
    if (error) {
        NSLog(@"网络缓存解析失败:%@",error.localizedDescription);
        return nil;
    }
    return responseObject;
}

#pragma mark - Cache clean
- (void)clearMemory{
    [self.memoryCaches removeAllObjects];
}

#pragma mark - encode
- (nullable NSString *)cachedFileNameForKey:(nullable NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSURL *keyURL = [NSURL URLWithString:key];
    NSString *ext = keyURL ? keyURL.pathExtension : key.pathExtension;
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], ext.length == 0 ? @"" : [NSString stringWithFormat:@".%@", ext]];
    return filename;
}

#pragma mark - Strings
- (NSString *)diskPath{
    _diskPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"%@%@",LSNetwokingURLCacheResourcesKey,self.resourcesIdentifier ? self.resourcesIdentifier : @""]];
    return _diskPath;
}

- (void)setResourcesIdentifier:(NSString *)resourcesIdentifier{
    dispatch_async(self.ioQueue, ^{
        if (!resourcesIdentifier || resourcesIdentifier == self->_resourcesIdentifier || ![resourcesIdentifier isKindOfClass:[NSString class]] || resourcesIdentifier.length == 0) {
            return;
        }
        self->_resourcesIdentifier = resourcesIdentifier;
        [self clearMemory];
    });
}

@end
