//
//  LSTimeUtils.m
//  TestApplication
//
//  Created by caichixiang on 2019/7/1.
//  Copyright © 2019年 sky. All rights reserved.
//

#import "LSTimeUtils.h"

@implementation LSTimeUtils

+(BOOL)isSameDay:(NSDate *)srcDate other:(NSDate *)descDate
{
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *srcComponents=[calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:srcDate];
    NSInteger year=[srcComponents year];
    NSInteger month=[srcComponents month];
    NSInteger day=[srcComponents day];
    
     NSDateComponents *descComponents=[calender components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:descDate];
    NSInteger descyear=[descComponents year];
    NSInteger descMonth=[descComponents month];
    NSInteger descDay=[descComponents day];

    return ((descyear == year) && (descMonth == month) && (descDay == day));
}

+(NSArray<NSDate *> *)countSameDay:(NSArray<LSSleepItem *> *)sleepItems
{
    if(!sleepItems.count){
        return nil;
    }
    //对数据进行排序
    NSArray <LSSleepItem *> *sortedArray=[sleepItems sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2){
        LSSleepItem *item1=(LSSleepItem *)obj1;
        LSSleepItem *item2=(LSSleepItem *)obj2;
        //升序排列
        return [item1.date compare:item2.date];
        //降序排列
        //return [item2.date compare:item1.date];
    }].copy;
    //获取数组第一个元素的时间
    NSDate *firstDate=sortedArray.firstObject.date;
    NSMutableArray <NSDate *> *targetDates=[[NSMutableArray alloc] initWithCapacity:7];
    //加入列表
    [targetDates addObject:firstDate];
    //统计时间不同的天数
    for(LSSleepItem *item in sortedArray){
        if(![self isSameDay:item.date other:firstDate]){
            firstDate=item.date;
            [targetDates addObject:firstDate];
        }
    }
    return targetDates;
}

+(NSString *)toDayFormatString:(NSDate *)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy/MM/dd";
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    return [formatter stringFromDate:date];
}


+(NSString *)toTimeFormatString:(NSDate *)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy/MM/dd HH:mm:ss";
//    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    return [formatter stringFromDate:date];
}

+(long)toUtc:(NSString *)time
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy/MM/dd HH:mm:ss";
    return [formatter dateFromString:time].timeIntervalSince1970;
}

+(NSString *)formatDateWithUTC:(long long)utc timeZone:(NSString *)timeZone
{

    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    int zone=timeZone.intValue;
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:zone*3600]];
    NSDate*date=[NSDate dateWithTimeIntervalSince1970:utc];
    return [formatter stringFromDate:date];
}

+(NSString *)formatDateWithUTC:(long long)utc
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate*date=[NSDate dateWithTimeIntervalSince1970:utc];
    return [formatter stringFromDate:date];
}


+(NSString *)toTimeString:(long)time
{
    if(time - 3600 >=0){
        return [NSString stringWithFormat:@"%@ hr %@ min ",@(time/(60*60)),@(time%(60*60)/60)];
    }
    else if(time >=60){
        return [NSString stringWithFormat:@" 0 hr %@ min ",@(time/60)];
    }
    else{
        return  [NSString stringWithFormat:@" 0 hr %@ min",@(time)];
    }
}

/**
 * 计算百分比
 */
+(NSString *)countPercent:(long)value forSum:(long)sum
{
    NSNumber *num = [NSNumber numberWithFloat:(float)value/(float)sum];
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    return [numberFormatter stringFromNumber:num];
}
@end
