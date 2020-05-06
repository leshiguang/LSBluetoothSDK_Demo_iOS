//
//  ScanResultsTableViewCell.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/26.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanResultsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *deviceImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *protocolLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceLabel;

@end
