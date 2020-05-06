//
//  ConfigFileCenter.m
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "ConfigFileCenter.h"

@implementation ConfigFileCenter

@synthesize defaultConfigDir = _defaultConfigDir;
@synthesize configDir = _configDir;


#pragma mark - Object Life-cycle

- (id)init
{
    self = [super init];
    if (self) {
        self.defaultConfigDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:kConfigFileDirectoryDefault];
        self.configDir = [NSHomeDirectory() stringByAppendingString:kConfigFileDirectoryUser];
    }
    return self;
}

- (void)dealloc
{
    _configDir = nil;
    _defaultConfigDir = nil;
}

#pragma mark - <ConfigFileCenterProtocol>

-(NSString*) readDefaultConfigWithName:(NSString*)name
{
    NSString* path = nil;
    if ([self.defaultConfigDir length] > 0)
    {
        path = [self.defaultConfigDir stringByAppendingFormat:@"/%@.json",name];
        return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return nil;
}

-(NSString*) readUserConfigWithName:(NSString*)name
{
    NSString* path = nil;
    NSString* ret = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",name];
        ret = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return ret;
}

-(NSString*) readConfigWithName:(NSString*)name
{
    NSString* ret = nil;
    ret = [self readUserConfigWithName:name];
    
    if (ret == nil)
    {
        ret = [self readDefaultConfigWithName:name];
    }
    return ret;
}

//读取默认路径中的配置，返回文本内容(参数：子目录/文件名)
-(NSString*) readDefaultConfigWithSubPath:(NSString*)subPath
{
    NSString* path = nil;
    if ([self.defaultConfigDir length] > 0)
    {
        path = [self.defaultConfigDir stringByAppendingFormat:@"/%@.json",subPath];
        return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return nil;
}
//读取默认路径中的配置，返回文本内容(参数：子目录/文件名)
-(NSString*) readUserConfigWithSubPath:(NSString*)subPath
{
    NSString* path = nil;
    NSString* ret = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",subPath];
        ret = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return ret;
}
//读取配置文件，优先读取用户配置文件路径的配置；如果失败会继续读取默认配置文件(参数：子目录/文件名)
-(NSString*) readConfigWithSubPath:(NSString*)subPath
{
    NSString* ret = nil;
    ret = [self readUserConfigWithSubPath:subPath];
    
    if (ret == nil)
    {
        ret = [self readDefaultConfigWithSubPath:subPath];
    }
    return ret;
}

//读取全路径下的配置
-(NSString*) readConfigWithFullPath:(NSString*)fullPath
{
    if (fullPath)
    {
        NSString* path = nil;
        path = [fullPath stringByAppendingFormat:@"/%@.json",fullPath];
        return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    }
    return nil;
}

-(BOOL) writeUserConfig:(NSString*)config withName:(NSString*)name
{
    NSString* path = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",name];
        
        // 判断是否存在该文件,没有则创建一文件目录
        if (![self isUserConfigExist:name])
        {
            BOOL isSucceed = [self _createConfigDirWihtPath:path];
            if (isSucceed)
            {
                return [config writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return [config writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return NO;
}

-(BOOL) writeUserConfig:(NSString*)config withSubPath:(NSString*)subPath
{
    NSString* path = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",subPath];
        
        // 判断是否存在该文件,没有则创建一文件目录
        if (![self isUserConfigExist:subPath])
        {
            BOOL isSucceed = [self _createConfigDirWihtPath:path];
            if (isSucceed)
            {
                return [config writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return [config writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    return NO;
}

-(void)deleteConfigWithName:(NSString*)name
{
    NSString* path = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",name];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
}

-(BOOL)isDefaultConfigExist:(NSString*)name
{
    NSString* path = nil;
    if ([self.defaultConfigDir length] > 0)
    {
        path = [self.defaultConfigDir stringByAppendingFormat:@"/%@.json",name];
        return [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    return NO;
}
-(BOOL)isUserConfigExist:(NSString*)name
{
    NSString* path = nil;
    if ([self.configDir length] > 0)
    {
        path = [self.configDir stringByAppendingFormat:@"/%@.json",name];
        return [[NSFileManager defaultManager] fileExistsAtPath:path];
    }
    return NO;
}

-(BOOL)isConfigExist:(NSString*)name
{
    return [self isUserConfigExist:name] || [self isDefaultConfigExist:name];
}


#pragma mark - other userful functions
-(NSInteger)countOfConfig
{
    if ([self.configDir length] > 0)
    {
        return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.configDir error:nil] count];
    }
    return 0;
}

-(NSString*)getConfigNameAtIndex:(NSInteger)index
{
    if ([self.configDir length] > 0 && index < [self countOfConfig])
    {
        return [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.configDir error:nil] objectAtIndex:index];
    }
    return nil;
}

#pragma mark - Private
// 接受配置文件路径 包含文件名.json
- (BOOL)_createConfigDirWihtPath:(NSString *)path
{
    if (path)
    {
        // json文件所在目录
        NSString * jsonDir = nil;
        
        // 是否以.json结尾的
        if ([path hasSuffix:@".json"])
        {
            NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
            
            jsonDir = [path substringToIndex:range.location];
        
            if (jsonDir)
            {
                // 创建文件目录
                return [[NSFileManager defaultManager] createDirectoryAtPath:jsonDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return NO;
}

@end
