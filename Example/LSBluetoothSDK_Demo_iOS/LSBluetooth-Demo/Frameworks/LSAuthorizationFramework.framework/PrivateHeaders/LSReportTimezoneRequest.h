//
//  LSReportTimezoneRequest.h
//  LSAuthorization
//
//  Created by alex.wu on 2020/10/9.
//

#import <Foundation/Foundation.h>
#import <LSNetworkFramework/LSBaseRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSReportTimezoneRequest : LSBaseRequest


//业务的唯一ID，当serviceId代表连接时为设备唯一ID， 其它的情况待补充，必须
@property(nonatomic, strong) NSString *mac;
//设备型号
@property(nonatomic, strong) NSString *model;
//时间戳
@property (nonatomic) NSUInteger ts;
//时区ID
@property(nonatomic, strong) NSString *zone;


-(instancetype) init:(NSString *)mac andModel:(NSString *)model;

@end

NS_ASSUME_NONNULL_END
