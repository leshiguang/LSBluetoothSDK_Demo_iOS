//
//  AlertViewUtils.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/15.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlertViewUtils : NSObject


+(void)showAlertView:(NSString *_Nullable)title
             message:(NSString *_Nullable)msg
           cancelBtn:(BOOL)enable
          controller:(UIViewController *_Nonnull)viewController
             handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

+(void)showConfirmAlertView:(NSString *_Nullable)title
                    message:(NSString *_Nullable)msg
                 controller:(UIViewController *_Nonnull)viewController
                    handler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

+(void)showIndicatorView:(UIActivityIndicatorView *_Nullable)view
                 message:(NSString *_Nullable)msg
              controller:(UIViewController *_Nonnull)viewController
                 handler:(void (^ __nullable)(void))completion;

@end
