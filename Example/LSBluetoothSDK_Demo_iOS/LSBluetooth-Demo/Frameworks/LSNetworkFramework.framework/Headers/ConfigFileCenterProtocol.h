//
//  ConfigFileCenterProtocol.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  访问配置文件的接口文件
 *  目前在实现时，内部会在name后增加.json后缀，所以请打包文件时注意是name.json
 */
@protocol ConfigFileCenterProtocol <NSObject>

//默认存储位置（应该为安装包Bundle中的路径）
@property (nonatomic,retain) NSString* defaultConfigDir;
//用户路径（应该为Document等可读写的路径）
@property (nonatomic,retain) NSString* configDir;

#pragma mark - 读
//读取默认路径中的配置，返回文本内容(参数name：文件名)
-(NSString*) readDefaultConfigWithName:(NSString*)name;
//读取默认路径中的配置，返回文本内容(参数name：文件名)
-(NSString*) readUserConfigWithName:(NSString*)name;
//读取配置文件，优先读取用户配置文件路径的配置；如果失败会继续读取默认配置文件(参数name：文件名)
-(NSString*) readConfigWithName:(NSString*)name;

//读取默认路径中的配置，返回文本内容(参数subPath：子目录/文件名)
-(NSString*) readDefaultConfigWithSubPath:(NSString*)subPath;
//读取默认路径中的配置，返回文本内容(参数subPath：子目录/文件名)
-(NSString*) readUserConfigWithSubPath:(NSString*)subPath;
//读取配置文件，优先读取用户配置文件路径的配置；如果失败会继续读取默认配置文件(参数subPath：子目录/文件名)
-(NSString*) readConfigWithSubPath:(NSString*)subPath;

//读取全路径下的配置
-(NSString*) readConfigWithFullPath:(NSString*)fullPath;

#pragma mark - 写、删
//写入配置到用户配置文件路径(参数name：文件名)
-(BOOL) writeUserConfig:(NSString*)config withName:(NSString*)name;
//写入配置到用户配置文件路径(参数subPath：子目录/文件名)
-(BOOL) writeUserConfig:(NSString*)config withSubPath:(NSString*)subPath;

//删除用户配置文件下的配置
-(void)deleteConfigWithName:(NSString*)name;

#pragma mark - 检测
//判断默认路径配置文件是否存在
-(BOOL)isDefaultConfigExist:(NSString*)name;
//判断用户路径配置文件是否存在
-(BOOL)isUserConfigExist:(NSString*)name;
//判断配置文件是否存在;User或Default任意存在则表示存在
-(BOOL)isConfigExist:(NSString*)name;

@end
