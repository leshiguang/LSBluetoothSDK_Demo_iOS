//
//  BPMeasurementStatus.h
//  LSDeviceBluetooth
//
//  Created by caichixiang on 2019/1/28.
//  Copyright © 2019年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BPMeasurementStatus : NSObject

/**
 * 0=No body movement
 * 1=Body movement during measurement
 */
@property(nonatomic,assign)int bodyMovement;

/**
 * 0=Cuff fits properly
 * 1=Cuff too loose
 */
@property(nonatomic,assign)int cuffFit;

/**
 * 0=No irregular pulse detected
 * 1=Irregular pulse detected
 */
@property(nonatomic,assign)int irregularPulse;

/**
 * 0=Pulse rate is within the range
 * 1=Pulse rate exceeds upper limit
 * 2=Pulse rate is less than lower limit
 */
@property(nonatomic,assign)int pulseRateRange;

/**
 * 0=Proper measurement position
 * 1=Improper measurement position
 */
@property(nonatomic,assign)int measurementPosition;


@property(nonatomic,assign)int duplicateBind;

@property(nonatomic,assign)int statusOfHSD;

/**
 * source data
 */
@property(nonatomic,strong)NSData *data;


-(instancetype)initWithData:(NSData *)data;


+(BPMeasurementStatus *)parseA6Status:(NSUInteger)flags;
@end


