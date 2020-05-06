//
//  ScanResultsTableViewCell.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/26.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "ScanResultsTableViewCell.h"

@implementation ScanResultsTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIScreen *mainScreenRect=[UIScreen mainScreen];
    CGFloat screenWidth=mainScreenRect.bounds.size.width;
    
    self.statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(screenWidth-54-15, 24, 54, 21)];
    self.statusLabel.text=@"";
    self.statusLabel.textAlignment=NSTextAlignmentRight;
    self.statusLabel.font=[UIFont systemFontOfSize:13];
    [self.contentView addSubview:self.statusLabel];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
