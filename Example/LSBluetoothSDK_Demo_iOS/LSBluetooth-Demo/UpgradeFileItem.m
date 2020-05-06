//
//  UpgradeFileItem.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/14.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "UpgradeFileItem.h"

@implementation UpgradeFileItem

-(instancetype)initWithName:(NSString *)name
{
    if(self=[super init])
    {
        _fileName=name;
        if(name.length){
            NSString *firmwareVersion=nil;
            NSRange location=[name rangeOfString:@"T"];
            if(location.location >0 && location.length >0 && (location.location+4)< name.length){
                firmwareVersion=[name substringWithRange:NSMakeRange(location.location, 4)];
            }
            NSString *preName=nil;
            NSString *type=nil;
            NSRange index=[name rangeOfString:@"."];
            if(index.length >0 ){
                type=[name substringFromIndex:index.location+1];
                preName=[name substringToIndex:index.location];
            }
            _firmwareVersion=firmwareVersion;
            _filePath=[[NSBundle mainBundle] pathForResource:preName ofType:type];
        }
        
    }
    return self;
}

+(NSArray <UpgradeFileItem *>*)localUpgradeFiles:(NSString *)modelNumber
{
    if(!modelNumber.length){
        return nil;
    }
    NSMutableArray <UpgradeFileItem *>* items=[[NSMutableArray alloc] initWithCapacity:10];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *fielPath=NSBundle.mainBundle.resourcePath;
    NSArray <NSString *>* files = [fileManager contentsOfDirectoryAtPath:fielPath error:nil];
    for(NSString *item in files)
    {
        NSString *type=nil;
        NSRange index=[item rangeOfString:@"."];
        if(index.length >0 && index.location >0)
        {
            type=[item substringFromIndex:index.location+1];
            if([type caseInsensitiveCompare:@"lsf"] == NSOrderedSame
               || [type caseInsensitiveCompare:@"hex"] == NSOrderedSame
               || [type caseInsensitiveCompare:@"bin"] == NSOrderedSame )
            {
                NSString *model=[item substringToIndex:modelNumber.length-1];
                NSLog(@"fileName:%@ >> modelNumber:%@",item,modelNumber);
                //根据型号过滤文件
                if([model hasPrefix:modelNumber]
                   || [model caseInsensitiveCompare:modelNumber] == NSOrderedSame
                   || [modelNumber hasPrefix:model]){
                    UpgradeFileItem *file=[[UpgradeFileItem alloc] initWithName:item];
                    [items addObject:file];
                }
            }
        }
    }
    return items.copy;
}


@end
