//
//  LSSleepStatus.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import "LSSleepItem.h"

@implementation LSSleepItem



-(void)setUtc:(long long)utc{
    if(utc > 0){
        self.date=[NSDate dateWithTimeIntervalSince1970:utc];
    }
    _utc=utc;
}

@end
