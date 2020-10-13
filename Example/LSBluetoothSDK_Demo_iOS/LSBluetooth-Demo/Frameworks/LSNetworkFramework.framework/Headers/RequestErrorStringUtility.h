//
//  RequestErrorStringUtility.h
//  LSWearable
//
//  Created by malai on 16/8/18.
//  Copyright © 2016年 lifesense. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestErrorStringUtility : NSObject

+ (NSString *)errorStringWithError:(NSError *)error;

@end
