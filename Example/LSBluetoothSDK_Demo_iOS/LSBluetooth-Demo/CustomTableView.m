//
//  CustomTableView.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/10.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView

- (id)initWithFrame:(CGRect)frame dataSource:(NSArray *)arrays delegate:(id<LSSettingItemDelegate>)delegate
{
    if (self = [super initWithFrame:frame])
    {
        itemDelegate=delegate;
        dataSource = arrays;
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 272, 300)];
        table.dataSource = self;
        table.delegate = self;
        table.tag=12;
        table.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [table setAllowsSelection:YES];
        table.showsVerticalScrollIndicator = YES;
//        [table setUserInteractionEnabled:YES];
        [self addSubview:table];
    }
    return self;
}

-(LSDeviceSettingItem *)itemWithIndexPath:(NSIndexPath *)indexPath
{
    return (LSDeviceSettingItem *)[dataSource objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    LSDeviceSettingItem *item=[self itemWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        if(item.itemType == LSSettingItemFile){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.textLabel.textColor=[UIColor redColor];
            cell.detailTextLabel.text = (NSString *)item.itemValue;
            cell.detailTextLabel.font=[UIFont systemFontOfSize:11];
        }
        else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
    }
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.text = item.title;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next" size:16];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LSDeviceSettingItem *item=[self itemWithIndexPath:indexPath];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"select indexPath:%@,itemType=%@,title=%@",@(indexPath.row),@(item.itemType),item.title);
    if(item.itemType == LSSettingItemMultiChoice){
        BOOL isChecked=NO;
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            cell.accessoryType=UITableViewCellAccessoryNone;
            isChecked=NO;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
            isChecked=YES;
        }
        //callback
        if([itemDelegate respondsToSelector:@selector(deviceSettingItem:didSelectionValue:)]){
            [itemDelegate deviceSettingItem:item didSelectionValue:[NSNumber numberWithBool:isChecked].unsignedIntegerValue];
        }
    }
    else {
        //callback
        if([itemDelegate respondsToSelector:@selector(deviceSettingItem:didSelectionValue:)]){
            [itemDelegate deviceSettingItem:item didSelectionValue:0];
        }
    }
}

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated)
    {
        [self fadeIn];
    }
}


@end
