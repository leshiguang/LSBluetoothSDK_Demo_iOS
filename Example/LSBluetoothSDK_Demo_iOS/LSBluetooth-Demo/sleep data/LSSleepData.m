//
//  LSSleepData.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import "LSSleepData.h"
#import "LSSleepDataUtils.h"

@implementation LSSleepData

-(instancetype)initWithData:(LSUSleepData *)data
{
    if(self=[super init]){
        if(data){
            self.deviceMac = data.broadcastId;
            self.utc=data.utc;
            self.timeOffset=data.collectTime;
            self.srcData=[LSSleepDataUtils formatSleepStatus:data.statusList];
            self.status=data.statusList;
        }
    }
    return self;
}


@end
