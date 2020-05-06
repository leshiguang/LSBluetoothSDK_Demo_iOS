//
//  CustomTableView.h
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/10.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSettinItemDelegate.h"

@interface CustomTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSArray *dataSource;
    id<LSSettingItemDelegate> itemDelegate;
}

- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)arrays delegate:(id<LSSettingItemDelegate>)delegate;

@end
