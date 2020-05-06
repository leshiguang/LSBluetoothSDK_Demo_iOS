//
//  UserNameTableViewCell.h
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/9/2.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNameTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (strong,nonatomic) UILabel *userNameLabel;

@end
