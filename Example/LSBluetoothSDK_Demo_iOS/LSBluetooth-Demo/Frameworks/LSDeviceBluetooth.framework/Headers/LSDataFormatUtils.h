//
//  LSDataFormatUtils.h
//  LSDeviceBluetooth-Library
//
//  Created by caichixiang on 2017/2/9.
//  Copyright © 2017年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSDataType) {
    DataType_uint8 = 0,
    DataType_utf8s,
    DataType_uint16,
    DataType_uint24,
    DataType_uint32,
    DataType_uint40,
    DataType_SFLOAT,
    DataType_FLOAT,
    DataType_SFLOAT_BIG,
    DataType_FLOAT_BIG,
    DataType_uint32_BIG,
    DataType_uint24_BIG,
    DataType_uint16_BIG,
};

@interface LSDataFormatUtils : NSObject


/**
 * 将NSData根据数据长度，转换成NSData 数组
 */
+(NSArray *)formatData:(NSData *)sourceData length:(NSUInteger)packetlength;

/**
 * 格式化macAddress
 */
+(NSString *)formatMacAddress:(NSString *)dataStr;

/**
 * 将CBUUID转换成uint16_t;
 */
+(uint16_t)formatDataWithUint16_t:(NSData* )uuidData;

/**
 * 将16进制的字符串，转换成符号的数字;
 */
+(NSUInteger)formatHexStringWithUnsignedInteger:(NSString*)hexString;


/*!
 * 将NSData转换成NString,删除前后的<>字符
 */
+(NSString *)formatDataWithString:(NSData *)data;

/**
 * 将字符串转换成uint32_t;
 */
+(uint32_t)formatHexStringWithUint32_t:(NSString*)str;

/**
 * 将16进制字符串转成NSData;
 */
+(NSData *)formatHexStringWithData:(NSString *)string;

/**
 * 根据命令字，命令内容格式化成NSData;
 */
+(NSData *)formatCommand:(NSUInteger)cmd data:(NSString *)sourceStr;

/**
 * 把32为无符号整数转换成16进制的字符串;
 */
+(NSString *)formatUint32WithHexString:(uint32_t)value;


/**
 * 将NSData按字节为单位，反序输出
 */
+(NSData *)formatDataWithReverseOrder:(NSData *)sourceData;


/**
 * 将Integer格式的utc时间转换成字符串形式;
 */
+(NSString *)formatUtcWithString:(NSUInteger)utc;

/**
 * 将NSData转换成utf-8编码的字符串形式;
 */
+(NSString *)formatDataWithUTF8StringEncoding:(NSData *)sourceData;

/**
 * uint16_t data转成Double类型;
 */
+(double)translateToSFloat:(uint16_t)data;

/**
 * uint16_t data转成Double类型;
 */
+(double)translateSFLOAT:(uint16_t)value;

/**
 * uint32_t data转成Double类型;
 */
+(double)translateFLOAT:(uint32_t)value;

/**
 * 将Number对象，转换成指定数据类型的NSData;
 */
+(NSData *)formatNumber:(NSNumber *)number withDataType:(LSDataType)type;

/**
 * 将NSData,根据索引位置转换成相应格式的数值
 */
+(double)formatDataWithType:(LSDataType)type index:(NSInteger)begin fromData:(NSData*)sourceData;

/*
 * 格式化回包内容，每个帧前加入命令字和帧序号
 */
+(NSArray *)formatResponsePackets:(NSArray *)datas command:(int)cmd;


/**
 * 16进制字符串转long
 */
+(unsigned long long)hexString2Long:(NSString *)hexStr;

/**
 * 根据小数位保留字段，将float类型转成对应的4字节Bytes
 * 如 60.0 转 FF000258
 */
+(NSData *)float2DataWithBig:(float)value decimalPlaces:(NSUInteger)places;

/**
 * 基准时间转当前时间
 */
+(long)toVendorUtc:(NSUInteger)utc;
@end
