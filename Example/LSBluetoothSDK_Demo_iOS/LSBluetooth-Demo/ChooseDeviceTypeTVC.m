//
//  ChooseDeviceTypeTVC.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/26.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "ChooseDeviceTypeTVC.h"
#import "DeviceUser.h"
#import "LSDatabaseManager.h"
#import "DeviceUserProfiles.h"
#import "ScanFilter.h"

#define kDeviceTypeTitleKey  @"title"   // key for obtaining the data source item's title
#define kDeviceTypeValueKey  @"checkValue" // key for obtaining the data source item's date value


@interface ChooseDeviceTypeTVC ()
@property(nonatomic,strong)ScanFilter *currentScanFilter;
@end

@implementation ChooseDeviceTypeTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setMultipleTouchEnabled:YES];
    LSDatabaseManager *databaseManager=[LSDatabaseManager defaultManager];
    DeviceUser *deviceUser=[[databaseManager allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    
    self.currentScanFilter=deviceUser.userprofiles.hasScanFilter;

    
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    BOOL isCheck=NO;
    switch (indexPath.row)
    {
        case 0:
        {
            isCheck=[self.currentScanFilter.enablePedometer boolValue];
        } break;
        case 1:
        {
            isCheck=[self.currentScanFilter.enableWeightScale boolValue];
        } break;
        case 2:
        {
            isCheck=[self.currentScanFilter.enableFatScale boolValue];
        } break;
        case 3:
        {
            isCheck=[self.currentScanFilter.enableKitchenScale boolValue];
        } break;
        case 4:
        {
            isCheck=[self.currentScanFilter.enableBloodPressure boolValue];
        } break;
        case 5:
        {
            isCheck=[self.currentScanFilter.enableHeightMeter boolValue];
        } break;
        case 6:
        {
            isCheck=[self.currentScanFilter.enableAllDevice boolValue];
        }break;
        default:
            break;
    }
   
    if(isCheck)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        BOOL isCheck=NO;
        switch (indexPath.row)
        {
            case 0:
            {
                isCheck=[self.currentScanFilter.enablePedometer boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enablePedometer=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                     self.currentScanFilter.enablePedometer=[NSNumber numberWithBool:YES];
                }
            } break;
            case 1:
            {
                isCheck=[self.currentScanFilter.enableWeightScale boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableWeightScale=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                     self.currentScanFilter.enableWeightScale=[NSNumber numberWithBool:YES];
                }
            } break;
            case 2:
            {
                isCheck=[self.currentScanFilter.enableFatScale boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableFatScale=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                     self.currentScanFilter.enableFatScale=[NSNumber numberWithBool:YES];
                }
            } break;
            case 3:
            {
                isCheck=[self.currentScanFilter.enableKitchenScale boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableKitchenScale=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                    self.currentScanFilter.enableKitchenScale=[NSNumber numberWithBool:YES];
                }
            } break;
            case 4:
            {
                isCheck=[self.currentScanFilter.enableBloodPressure boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableBloodPressure=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                    self.currentScanFilter.enableBloodPressure=[NSNumber numberWithBool:YES];
                }
            } break;
            case 5:
            {
                isCheck=[self.currentScanFilter.enableHeightMeter boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableHeightMeter=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                    self.currentScanFilter.enableHeightMeter=[NSNumber numberWithBool:YES];
                }
            } break;
            case 6:
            {
                isCheck=[self.currentScanFilter.enableAllDevice boolValue];
                if(isCheck)
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
                    //set no
                    self.currentScanFilter.enableAllDevice=[NSNumber numberWithBool:NO];
                }
                else
                {
                    currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
                    //set yes
                    self.currentScanFilter.enableAllDevice=[NSNumber numberWithBool:YES];
                }
            }break;
            default:
                break;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
