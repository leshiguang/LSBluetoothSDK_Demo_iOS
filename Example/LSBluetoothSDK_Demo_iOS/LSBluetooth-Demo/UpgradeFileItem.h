//
//  UpgradeFileItem.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/14.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpgradeFileItem : NSObject

@property (nonatomic,readonly)NSString *fileName;
@property (nonatomic,readonly)NSString *filePath;
@property (nonatomic,readonly)NSString *firmwareVersion;

-(instancetype)initWithName:(NSString *)name;


+(NSArray <UpgradeFileItem *>*)localUpgradeFiles:(NSString *)modelNumber;

@end
