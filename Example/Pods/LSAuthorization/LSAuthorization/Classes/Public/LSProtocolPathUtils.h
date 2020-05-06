//
//  LSProtocolPathUtils.h
//  AFNetworking
//
//  Created by alex.wu on 2020/4/1.
//

#import <Foundation/Foundation.h>

 

NS_ASSUME_NONNULL_BEGIN
static NSString * getProtocolPath(NSObject *classLoader ,NSString *bundleName, NSString *relativePath) {
    NSBundle *bundle = [NSBundle bundleForClass:classLoader.class];
    NSString *protocolPath = nil;
    
    /* 作为一个app的时候 直接从资源里面获取 */
    if ([bundle.bundlePath hasSuffix:@".app"]) {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
        
        NSBundle *dlmBundle = [NSBundle bundleWithPath:bundlePath];
        protocolPath = [dlmBundle pathForResource:relativePath ofType:@"plist"];
        
    }
    if (!protocolPath) {
        // 这里加个循环，如果找不到路径，则一直往下找
        do {
            NSURL *rootBundlePath = [bundle URLForResource:bundleName withExtension:@"bundle"];
            NSBundle *dlmBundle = [NSBundle bundleWithURL:rootBundlePath];
            protocolPath = [dlmBundle pathForResource:relativePath ofType:@"plist"];
            bundle = dlmBundle;
        } while (protocolPath == nil);
            
    }
    return protocolPath;
}

NS_ASSUME_NONNULL_END
