//
//  DeviceTableViewCell.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell


- (void)awakeFromNib {
    // Initialization code
    
    UIScreen *mainScreenRect=[UIScreen mainScreen];
    CGFloat screenWidth=mainScreenRect.bounds.size.width;
   
    
    self.recordTipLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-10-44, 25, 10, 10)];
    self.recordLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-83-5, 40, 83, 21)];
    
    [self.contentView addSubview:self.recordLabel];
    [self.contentView addSubview:self.recordTipLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
