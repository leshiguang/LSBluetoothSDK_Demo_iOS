//
//  DeviceTableViewCell.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UILabel *deviceNameLabel;
@property(nonatomic,weak)IBOutlet UILabel *userNumberLabel;
@property(nonatomic,weak)IBOutlet UILabel *protocolTypeLabel;
@property(nonatomic,weak)IBOutlet UILabel *connectStateLabel;


@property(nonatomic,weak)IBOutlet UIImageView  *deviceImageView;

@property(nonatomic,strong)UILabel *recordLabel;
@property (strong, nonatomic)UILabel *recordTipLabel;



@end
