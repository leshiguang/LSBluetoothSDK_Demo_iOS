//
//  NSDate+Utils.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/11/22.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(NSDate *) toLocalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime
{
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}
@end
