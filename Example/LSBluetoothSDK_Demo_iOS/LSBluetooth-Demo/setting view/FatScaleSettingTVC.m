//
//  FatScaleSettingTVC.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "FatScaleSettingTVC.h"
#import "DeviceUser.h"
#import "LSDatabaseManager.h"
#import "DataFormatConverter.h"
#import "DeviceUserProfiles.h"

@interface FatScaleSettingTVC ()<UIActionSheetDelegate,UITextFieldDelegate>

@property (nonatomic,strong)UITableViewCell *currentSelectCell;
@property (nonatomic,strong)DeviceUserProfiles *currentUserProfiles;

@end

@implementation FatScaleSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    LSDatabaseManager *databaseManager=[LSDatabaseManager defaultManager];
    DeviceUser * deviceUser=[[databaseManager allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    self.currentUserProfiles=deviceUser.userprofiles;
    
    
    
}

-(BOOL)shouldAutorotate
{
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(NSArray *)weightUnitArray
{
    return @[@"Kg",@"Lb",@"St"];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[super tableView:tableView  cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.detailTextLabel.text=self.currentUserProfiles.weightUnit;
                break;
            case 1:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.currentUserProfiles.weightTarget];
                break;
           
            default:
                break;
        }
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [self showWeightUnitSelectView];
            }
            break;
            case 1:
            {
                [self showNumberInputAlertView:@"Weight Target" message:@"Enter your weight target value(unit for 'kg')"];
            }break;
           default:
                break;
        }
    }
}

-(void)showNumberInputAlertView:(NSString *)title message:(NSString *)msg
{
    
    UIAlertView *userNameAlertView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    userNameAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *userNameTextField=[userNameAlertView textFieldAtIndex:0];
    userNameTextField.delegate=self;
    userNameTextField.keyboardType=UIKeyboardTypeDecimalPad;
    [userNameAlertView show];
}

-(void)showWeightUnitSelectView
{
    
    NSUInteger maxUserNumber=[[self weightUnitArray] count];
    if(maxUserNumber)
    {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Weight Unit"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
        
        
        NSString *title=nil;
        
        for(int i=0;i<maxUserNumber;i++)
        {
            title=[NSString stringWithFormat:@"Unit : %@",[[self weightUnitArray] objectAtIndex:i]];
            [actionSheet addButtonWithTitle:title];
        }
        
        actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *selectValue=[[self weightUnitArray] objectAtIndex:buttonIndex];
    
    NSLog(@"current select level,index =%@",selectValue);
    self.currentSelectCell.detailTextLabel.text=selectValue;
    self.currentUserProfiles.weightUnit=selectValue;
   
}

#pragma mark -UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *value=[textField text];
    self.currentSelectCell.detailTextLabel.text=value;
    self.currentUserProfiles.weightTarget=[NSNumber numberWithDouble:[value doubleValue]];
}


@end
