//
//  ErrorObjectHandleDelegate.h
//  LSWearable
//
//  Created by rolandxu on 12/18/15.
//  Copyright © 2015 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ErrorObject;

@protocol ErrorObjectHandleDelegate <NSObject>

@optional
- (void)onErrorHasTriggered:(ErrorObject*)error withUserParameter:(id)param;

@end
