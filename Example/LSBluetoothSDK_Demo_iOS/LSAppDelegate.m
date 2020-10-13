//
//  AppDelegate.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "LSAppDelegate.h"
#import "LSDatabaseManager.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "DataFormatConverter.h"
#import "NSDate+Utils.h"

@interface LSAppDelegate ()
@property(nonatomic,strong)LSDatabaseManager *databaseManager;
@property(nonatomic,strong)LSBluetoothManager *lsBleManager;
@end

@implementation LSAppDelegate



/**
 * define log file path
 */
-(NSString *)logFilePath
{
    NSArray *files = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [files objectAtIndex:0];
    
    NSString *logDirPath = [NSString stringWithFormat:@"%@/LS-BLE", document];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logDirPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:logDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"my log file path :%@",logDirPath);
    return  logDirPath;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@" did Finish Launching With Options");
    self.databaseManager=[LSDatabaseManager defaultManager];
    [self.databaseManager createManagedObjectContextWithDocumentName:@"LifesenseBleDatabase"];
    UIPageControl *pageControl=[UIPageControl appearance];
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
    pageControl.backgroundColor=[UIColor whiteColor];
    
    //init LSBluetoothManager with dispatch queue
    dispatch_queue_t dispatchQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [[LSBluetoothManager defaultManager] initManagerWithDispatch:dispatchQueue];
    NSLog(@"LSBluetooth SDK Version :%@",[LSBluetoothManager defaultManager]);

    //get sdk version
    NSLog(@"LSBluetooth SDK Version :%@",[[LSBluetoothManager defaultManager] versionName]);
    //save log message in file if need
    [[LSBluetoothManager defaultManager] saveDebugMessage:YES forFileDirectory:[self logFilePath]];


    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //close websocket client
}



@end
