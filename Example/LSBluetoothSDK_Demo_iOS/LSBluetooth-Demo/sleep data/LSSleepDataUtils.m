//
//  LSSleepDataUtils.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 Lifesense. All rights reserved.
//

#import "LSSleepDataUtils.h"

@implementation LSSleepDataUtils


+(NSString *)formatSleepStatus:(NSArray<NSNumber *> *)status{
    if(!status.count){
        return nil;
    }
    NSMutableString *buffer=[[NSMutableString alloc] initWithCapacity:status.count*2];
    for(int i=0;i<status.count;i++){
        NSNumber *num=status[i];
        [buffer appendFormat:@"%02lX",num.unsignedIntegerValue];
    }
    return buffer.copy;
}

/**
 * Format Sleep Status With HexString
 */
+(NSString *)formatSleepItem:(NSArray <LSSleepItem *> *)datas{
    if(!datas.count){
        return nil;
    }
    NSMutableString *buffer=[[NSMutableString alloc] initWithCapacity:datas.count*2];
    for(int i=0;i<datas.count;i++){
        LSSleepItem *item=datas[i];
        [buffer appendFormat:@"%02lX",item.value];
    }
    return buffer.copy;
}

//parse sleep value from source data
+(NSArray<LSSleepItem *> *)toSleepStatus:(LSSleepData *)data
{
    if(!data){
        return nil;
    }
    NSMutableArray *items=[[NSMutableArray alloc] initWithCapacity:data.status.count];
    long startUtc=data.utc;
    int timeOffset=data.timeOffset;
    //to sleep status list
    for(int i=0;i<data.status.count;i++){
        long utc=startUtc+i*timeOffset;
        int item=data.status[i].unsignedIntValue;
        LSSleepItem *obj=[[LSSleepItem alloc] init];
        obj.utc=utc;
        obj.value=item;
        [items addObject:obj];
    }
    return items;
}


/**
 * format the sleep state according to the number of days
 */
+(NSArray <LSDaySleepStatus *> *)toDaySleepStatus:(NSArray <LSSleepItem *> *)sleepItems
{
    if(!sleepItems.count){
        return nil;
    }
    NSMutableArray <LSDaySleepStatus *> *daySleepStatus=[[NSMutableArray alloc] initWithCapacity:7];
    //对数据进行排序
    NSArray <LSSleepItem *> *sortedArray=[sleepItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        LSSleepItem *item1=(LSSleepItem *)obj1;
        LSSleepItem *item2=(LSSleepItem *)obj2;
        //升序排列
        return [item1.date compare:item2.date];
        //降序排列
        //return [item2.date compare:item1.date];
    }].copy;
    //统计睡眠数据对应的天数
    NSArray <NSDate *> *sameDays=[LSTimeUtils countSameDay:sleepItems];//countSameDay(statuses);
    for(int i=0;i<sameDays.count;i++){
        NSDate *dayDate=sameDays[i];
        //set end time of sleep
        //SleepDataUtils.dayDateFormat.format(dayDate)+" 13:59:59";
        NSString *endDate=[NSString stringWithFormat:@"%@ 13:59:59",[LSTimeUtils toDayFormatString:dayDate]];
        if(i == sameDays.count-1){
            NSDate *lastDay=sortedArray[sortedArray.count-1].date;
            //statuses.get(statuses.size()-1).getDate();
            endDate=[LSTimeUtils toTimeFormatString:lastDay];
            //SleepDataUtils.dateFormat.format(lastDay);
        }
        long endUtc=[LSTimeUtils toUtc:endDate];
        //SleepDataUtils.toUtc(endDate);
        //count start time of sleep
        long startUtc=endUtc-18*60*60;
        
        //filter sleep status with start utc and end utc
        NSArray<LSSleepItem *> *dayDatas=[self filterSleepStatusWithTime:startUtc
                                                                 endTime:endUtc item:sortedArray];
        //filterSleepStatusWithTime(startUtc,endUtc,sortedArray);
        //get complete sleep status between startUtc and endUtc
        dayDatas=[self getCompleteSleepStatus:startUtc endTime:endUtc items:dayDatas timeOffset:300];
        //getCompleteSleepStatus(startUtc,endUtc,dayDatas,300);
        
        //to day sleep status
        LSDaySleepStatus *daySleep=[[LSDaySleepStatus alloc] init];
        daySleep.startUtc=startUtc;
        daySleep.endUtc=endUtc;
        daySleep.hexSleepData=[self formatSleepItem:dayDatas];
        daySleep.dayDate=dayDate;
        daySleep.datas=dayDatas;
        
        //add it to list
        [daySleepStatus addObject:daySleep];
    }
    return daySleepStatus;
}

/**
 * filter sleep status with start time and end time
 */
+(NSArray <LSSleepItem *> *)filterSleepStatusWithTime:(long)startUtc
                                              endTime:(long)endUtc
                                                 item:(NSArray <LSSleepItem *> *)datas
{
    NSMutableArray <LSSleepItem *> *filters=[[NSMutableArray alloc] initWithCapacity:datas.count];
    for(LSSleepItem *item in datas){
        if(item.utc >= startUtc && item.utc<=endUtc){
            [filters addObject:item];
        }
    }
    return filters;
}

/**
 * Count incomplete sleep status based on start time and end time
 */
+(NSArray <LSSleepItem *> *)countIncompleteSleepStatus:(long)startUtc
                                               endTime:(long)endUtc
                                                 items:(NSArray <LSSleepItem *>*)datas
                                            timeOffset:(int)timeOffset
{
    if(!datas.count){
        return nil;
    }
    //calculate points based on time offset
    int pointCount=(int) ((endUtc-startUtc)/timeOffset);
    NSMutableArray <LSSleepItem *> * incompleteArrays=[[NSMutableArray alloc] initWithCapacity:7];
    for(int index=0;index<pointCount;index++){
        long compareUtc=startUtc+index*timeOffset;
        if(![self isValid:compareUtc items:datas]){
            //use 0xFF to replace these data
            LSSleepItem *fillItem=[[LSSleepItem alloc] init];
            fillItem.utc=compareUtc;
            fillItem.value=0xff;
            [incompleteArrays addObject:fillItem];
        }
    }
    return incompleteArrays.copy;
}

+(BOOL)isValid:(long)utc items:(NSArray <LSSleepItem *> *)datas
{
    for(LSSleepItem *item in datas){
        if(item.utc == utc){
            return true;
        }
    }
    return false;
}

/**
 * Get complete sleep status data based on start time and end time
 */
+(NSArray <LSSleepItem *> *)getCompleteSleepStatus:(long)startUtc
                                           endTime:(long)endUtc
                                             items:(NSArray <LSSleepItem *> *)datas
                                        timeOffset:(int)timeOffset
{
    NSArray <LSSleepItem *> *incompleteStatus=[self countIncompleteSleepStatus:startUtc endTime:endUtc items:datas timeOffset:timeOffset];
    //countIncompleteSleepStatus(startUtc, endUtc, datas, timeOffset);
    if(incompleteStatus.count >0){
        //merge Data
        NSMutableArray <LSSleepItem *> *mergeArrays=[NSMutableArray arrayWithCapacity:datas.count+incompleteStatus.count];
        //add incomplete status list
        [mergeArrays addObjectsFromArray:incompleteStatus];
        //add src statuc list
        [mergeArrays addObjectsFromArray:datas];
        //sort by time
        NSArray <LSSleepItem *> *sortedArray=[mergeArrays sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
            LSSleepItem *item1=(LSSleepItem *)obj1;
            LSSleepItem *item2=(LSSleepItem *)obj2;
            //升序排列
            return [item1.date compare:item2.date];
            //降序排列
            //return [item2.date compare:item1.date];
        }].copy;
        return sortedArray;
    }
    else{
        //is complete
        return datas;
    }
}

@end
