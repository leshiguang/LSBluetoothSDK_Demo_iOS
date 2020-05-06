//
//  AlertViewUtils.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/15.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "AlertViewUtils.h"

@implementation AlertViewUtils


+(void)showAlertView:(NSString *)title
             message:(NSString *)msg
           cancelBtn:(BOOL)enable
          controller:(UIViewController *)viewController
             handler:(void (^ __nullable)(UIAlertAction *action))handler

{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:handler];
    if(enable){
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alert addAction:cancel];
    }
    [alert addAction:ok];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)showConfirmAlertView:(NSString *)title
                    message:(NSString *)msg
                 controller:(UIViewController *)viewController
                    handler:(void (^ __nullable)(UIAlertAction *action))handler


{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:handler];
    [alert addAction:ok];
    [viewController presentViewController:alert animated:YES completion:nil];
}

+(void)showIndicatorView:(UIActivityIndicatorView *)view
                 message:(NSString *)msg
              controller:(UIViewController *)viewController
                 handler:(void (^ __nullable)(void))completion
{
    UIAlertController *pending = [UIAlertController alertControllerWithTitle:nil
                                                                     message:msg
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [pending.view addSubview:view];
    NSDictionary * views = @{@"pending" : pending.view, @"indicator" : view};
    NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
    NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
    NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
    [pending.view addConstraints:constraints];
    [view startAnimating];
    [viewController presentViewController:pending animated:YES completion:completion];
}
@end
