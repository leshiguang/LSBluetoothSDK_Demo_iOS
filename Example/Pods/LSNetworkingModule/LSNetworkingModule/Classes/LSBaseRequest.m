//
//  LSBaseRequest.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "LSBaseRequest.h"
#import <CommonCrypto/CommonDigest.h>

static const NSString *klsRequestSecretKey = @"2a6bfL45*2219cZi44c7f78231e3cF80ensea13072eSb672_!";
@interface LSBaseRequest ()
@property(nonatomic,strong)NSMutableDictionary<NSString *, NSString *> *customHeaders;
@end


@implementation LSBaseRequest

-(id)init
{
    if (self = [super init]) {
        _dataDict = [[NSMutableDictionary alloc] init];
        _binaryDataArray = [[NSMutableArray alloc] init];
        _fileDataArray = [[NSMutableArray alloc] init];
        _method = HTTP_GET;
        _baseRequestType = LSBaseRequestTypeNormal;
        
        self.requestId = -1;
        self.urlAppendingString = @"";
        _customHeaders = [[NSMutableDictionary alloc] init];
        _accountNeedToLogin = NO;
        _needToPublicParameters = NO;
    }
    return self;
}

-(void)dealloc{
    
}

#pragma mark - getter
- (NSString *)requestUrl
{
    NSString * url = [[RequestMap shareInstance] getRequestV2UrlByName:self.requestName];
    return url;
}

- (NSString *)responseName
{
    NSString * repName = [[RequestMap shareInstance] getResponseV2ByName:self.requestName];
    return repName;
}

- (NSDictionary *)requestCookieDict
{
    return nil;
}

-(NSDictionary<NSString *, NSString *> *)httpHeader {
    return [_customHeaders copy];
}

#pragma mark - Public
-(void)setRequestProtocolName:(NSString*)protocolname
{
    _requestName = protocolname;
}

-(void)setRequestHttpGet
{
    _method = HTTP_GET;
}

-(void)setRequestHttpPost
{
    _method = HTTP_POST;
}

-(void)addStringValue:(NSString*)value forKey:(NSString*)key
{
    if(value==nil || key==nil)
    return;
    [_dataDict setObject:value forKey:key];
}

-(void)addDictionaryValue:(NSDictionary*)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    NSArray *keys = [dict allKeys];
    for (int i=0; i<[keys count]; i++)
    {
        NSString *key = [keys objectAtIndex:i];
        NSString *object = [dict objectForKey:key];
        [self addStringValue:object forKey:key];
    }
}

-(NSString*)getStringValueForKey:(NSString*)key
{
    if(key==nil)
    return @"";
    //return [_dataDict objectStringForKey:key defaultValue:@""];
    id result = [_dataDict objectForKey:key];
    if ([result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",result];
    }
    
    if (![result isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    NSString *str = (NSString *)result;
    return str;
}

-(void)addBinaryValue:(NSData*)value forKey:(NSString*)key withFileName:(NSString*)filename withMIMEtype:(NSString*)mimetype
{
    if([value length]<=0 || [key length]<=0)
    return;
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:key forKey:DATA_KEY];
    [dict setObject:value forKey:BIANRY_DATA_KEY];
    
    if([filename length]>0){
        [dict setObject:filename forKey:FILENAME_KEY];
    }
    
    if(mimetype!=nil)
    {
        [dict setObject:mimetype forKey:MIME_KEY];
    }
    [_binaryDataArray addObject:dict];
}

-(void)addFilePathValue:(NSString*)value forKey:(NSString*)key withFileName:(NSString*)filename withMIMEtype:(NSString*)mimetype
{
    if(value==nil || key==nil)
    return;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:key forKey:DATA_KEY];
    [dict setObject:value forKey:FILE_PATH_KEY];
    if(filename!=nil)
    {
        [dict setObject:filename forKey:FILENAME_KEY];
    }
    if(mimetype!=nil)
    {
        [dict setObject:mimetype forKey:MIME_KEY];
    }
    [_fileDataArray addObject:dict];
}

/**
 添加上传的二进制文件,简单版本
 */
-(void)addBinaryData:(NSData *)updata withFileName:(NSString *)upfilename {
    if ([updata length]<=0 || [upfilename length]<=0) {
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setObject:updata forKey:BIANRY_DATA_KEY];
    
    if([upfilename length]>0){
        [dict setObject:upfilename forKey:FILENAME_KEY];
    }
    
    [_fileDataArray addObject:dict];
}

//设置customHttpHeader
-(void)addStrValue:(NSString *)value forHttpHeaderField:(NSString *)key {
    if ([value length]<=0 || [key length]<=0) {
        return;
    }
    
    [_customHeaders setObject:value forKey:key];
}

-(void)setHttpHeader:(NSDictionary<NSString *,NSString *> *)httpHeader {
    NSArray *allkeys = [httpHeader allKeys];
    for (NSString *k in allkeys) {
        NSString *v = [httpHeader objectForKey:k];
        [_customHeaders setObject:v forKey:k];
    }
}

/**
 添加stringValue,然后encode
 **/
-(void)addEncode:(NSString *)value forKey:(NSString *)key {
    if ([value length]<=0 || [key length]<=0) {
        return;
    }
    
    NSString *encodeVal = [self encodeStringForURL:value];
    NSString *encodeKey = [self encodeStringForURL:key];
    
    [_dataDict setObject:encodeVal forKey:encodeKey];
}

-(NSString*)encodeStringForURL:(NSString *)string
{
    CFStringRef str = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *newString = (NSString *)CFBridgingRelease(str);
    if (newString) {
        return newString;
    }
    
    return string;
}


///  生成请求token
- (void)generateRequestToken {
    //生成时间戳
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSString *uuid = [[NSUUID UUID] UUIDString];
    //生成8位校验码
    NSString *rnd = [uuid substringFromIndex:(uuid.length - 8)];
    NSString *unencriptToken =[NSString stringWithFormat:@"%@%@%@", rnd, klsRequestSecretKey, @((int)ts)];
    NSString *encriptToken = [self md5HexDigest:unencriptToken];
    if (!self.urlAppendingString) {
        self.urlAppendingString = @"";
    }
    NSString *prefix = [self.urlAppendingString containsString:@"?"] ? ([self.urlAppendingString containsString:@"="] ? @"&": @"") : @"?";
    self.urlAppendingString = [self.urlAppendingString stringByAppendingString:[NSString stringWithFormat:@"%@requestToken=%@&rnd=%@&ts=%@",prefix, encriptToken, rnd, @((int)ts)]];
    
}

- (NSString *)md5HexDigest:(NSString*)password
{
    const char *original_str = [password UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        /*
         %02X是格式控制符：‘x’表示以16进制输出，‘02’表示不足两位，前面补0；
         */
        [hash appendFormat:@"%02X", result[i]];
    }
    return  [hash uppercaseString];
}


- (NSString *)mergeUrlParameters {
    NSString* urlString = self.requestUrl;
    NSString *paramstr = self.urlAppendingString;
    

    //生成请求token， 用于加密校验， 防止黄牛刷
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
    return urlString;
    
}
-(void)printRequest
{
    NSObject* key;
    NSUInteger dictcount;
    NSEnumerator *dataEnumerator;
    
    NSLog(@"-------start printRequest");
    NSLog(@"requestName:%@",_requestName);
    NSLog(@"requestMethod:%@",_method);
    
    dictcount = [_dataDict count];
    NSLog(@"DictValues has %zd values:",dictcount);
    dataEnumerator = [_dataDict keyEnumerator];
    while ((key = [dataEnumerator nextObject])) {
        NSLog(@"\tkey:%@\t\tvalue:%@",key,[_dataDict objectForKey:key]);
    }
    
    dictcount = [_binaryDataArray count];
    NSLog(@"BianryValues has %zd values:",dictcount);
    for(NSDictionary* dict in _binaryDataArray)
    {
        NSLog(@"\tkey:%@\t\tfilename:%@\t\tmimetype:%@",[dict objectForKey:DATA_KEY],[dict objectForKey:FILENAME_KEY],[dict objectForKey:MIME_KEY]);
    }
    
    dictcount = [_fileDataArray count];
    NSLog(@"FileValues has %zd values:",dictcount);
    for(NSDictionary* dict in _fileDataArray)
    {
        NSLog(@"\tkey:%@\t\tfilename:%@\t\tmimetype:%@",[dict objectForKey:DATA_KEY],[dict objectForKey:FILENAME_KEY],[dict objectForKey:MIME_KEY]);
    }
    
    NSLog(@"-------end printRequest");
}

#pragma mark - function by WangWang
#pragma mark - create uuid, 这个uuid就算删除了重新安装app也会保持同一个
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

+ (id)getUUIDWithKey:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            //NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
    CFRelease(keyData);
    return ret;
}

+ (void)deleteKeyData:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

#pragma mark - 公共参数, add by huowang, 20170215
/**
 随机数
 
 @return 字符串
 */
+ (NSString *)udid {
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString * strUUID = (NSString *)[self getUUIDWithKey:identifier];
    
    //首次执行该方法时，uuid为空
    if ([strUUID length]<=0 || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [self save:identifier data:strUUID];
    }
    return strUUID;
}


/**
 当前app版本号
 
 @return 字符串
 */
+ (NSString *)appVersion {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *nowVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return nowVersion;
}


/**
 当前屏幕宽度
 
 @return 字符串
 */
+ (NSString *)screenWidth {
    return [NSString stringWithFormat:@"%.0f",CGRectGetWidth([UIScreen mainScreen].bounds)];
}


/**
 当前屏幕高度
 
 @return 字符串
 */
+ (NSString *)screenHeight {
    return [NSString stringWithFormat:@"%.0f",CGRectGetHeight([UIScreen mainScreen].bounds)];
}

/**
 当前系统, iOS的值为2
 
 @return 字符串
 */
+ (NSString *)systemType {
    NSString *systemtype = @"2";
    return systemtype;
}


@end
