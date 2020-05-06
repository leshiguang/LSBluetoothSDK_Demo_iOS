//
//  UserNameTableViewCell.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/9/2.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "UserNameTableViewCell.h"

@implementation UserNameTableViewCell

- (void)awakeFromNib {
    UIScreen *mainScreenRect=[UIScreen mainScreen];
    CGFloat screenWidth=mainScreenRect.bounds.size.width;
    self.userNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-35-200, 12, 200, 19)];
    self.userNameLabel.textAlignment=NSTextAlignmentRight;
    self.userNameLabel.textColor=[UIColor lightGrayColor];
    
    [self.contentView addSubview: self.userNameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
