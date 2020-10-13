//
//  ConfigFileCenter.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import "ConfigFileCenterProtocol.h"


#define kConfigFileDirectoryDefault @"/config"
#define kConfigFileDirectoryUser @"/Library/Caches/UserConfig"

@interface ConfigFileCenter : NSObject <ConfigFileCenterProtocol>
{
    NSString* _defaultConfigDir;
    NSString* _configDir;
}

@end
