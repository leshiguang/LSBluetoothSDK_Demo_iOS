//
//  PedometerSettingTVC.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "PedometerSettingTVC.h"
#import "DeviceUserProfiles.h"
#import "DeviceUser.h"
#import "LSDatabaseManager.h"
#import "DeviceAlarmClock.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "LSDeviceSettingProfiles.h"
#import "PedometerAlarmClockTVC.h"
#import "LSDeviceSettingItem.h"
#import "CustomTableView.h"
#import "BaseSettingItemTVC.h"


@interface PedometerSettingTVC ()<LSSettingItemDelegate>

@property (nonatomic,strong)UITableViewCell *currentSelectCell;
@property (nonatomic,strong)DeviceUserProfiles *currentUserProfiles;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong)LSDDisplayPage *customPages;
@end

@implementation PedometerSettingTVC

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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(UIActivityIndicatorView *)indicatorView
{
    if(!_indicatorView){
        _indicatorView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    _indicatorView.color = [UIColor brownColor];
    _indicatorView.translatesAutoresizingMaskIntoConstraints=NO;
    _indicatorView.userInteractionEnabled=NO;
    return _indicatorView;
}

-(LSDDisplayPage *)customPages
{
    if(!_customPages){
        _customPages=[[LSDDisplayPage alloc] init];
    }
    return _customPages;
}


#pragma mark - UITableView

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[super tableView:tableView  cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.detailTextLabel.text=self.currentUserProfiles.weekStart;
                break;
            case 5:
            case 1:
            {
                NSDate *alarmClockTime=self.currentUserProfiles.deviceAlarmClock.alarmClockTime;
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"HH:mm"];
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:alarmClockTime]];
            } break;
            case 2:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.currentUserProfiles.hourFormat];
                break;
            case 3:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.currentUserProfiles.distanceUnit];
                break;
            case 4:
                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.currentUserProfiles.weekTargetSteps];
                break;
            default:
                cell.detailTextLabel.text=@"---";
                break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    LSDeviceSettingCategory settingCategory=(LSDeviceSettingCategory)indexPath.row;
    if(settingCategory == DSCategoryAlarmClock
       || settingCategory == DSCategoryEventClock
       || settingCategory == DSCategoryNightMode
       || settingCategory == DSCategorySedentaryRemind
       || settingCategory == DSCategoryMessageRemind
       || settingCategory == DSCategoryBehaviorRemind
       || settingCategory == DSCategoryHeartRateWarning
       || settingCategory == DSCategoryWeatherRemind
       || settingCategory == DSCategorySportsInfo
       || settingCategory == DSMoodRecordRemind
       || settingCategory == DSAppointmentRemind
       || settingCategory == DSSimpleRemind
       || settingCategory == DSMessageRemind
       || settingCategory == DSWakeupRemind
       || settingCategory == DSCategoryQuietMode)
    {
        return ;
    }
    else if(settingCategory == DSCategoryCustomPages){
        [self showCustomPagesSetting];
        return ;
    }
    LSDeviceSettingItem *settingItem=[[LSDeviceSettingItem alloc] initWithCategory:settingCategory];
    [self showDeviceSettingItem:settingItem];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Alert View

-(void)showIndicatorView:(NSString *)msg
                 handler:(void (^ __nullable)(void))completion
{
    UIAlertController *pending = [UIAlertController alertControllerWithTitle:nil
                                                                     message:msg
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [pending.view addSubview:self.indicatorView];
    NSDictionary * views = @{@"pending" : pending.view, @"indicator" : self.indicatorView};
    NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
    NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
    NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
    [pending.view addConstraints:constraints];
    [self.indicatorView startAnimating];
    [self presentViewController:pending animated:YES completion:completion];
}

-(void)showToastView:(NSString *)message
{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil
                                                                 message:message
                                                          preferredStyle:UIAlertControllerStyleAlert];
    alert.view.alpha = 0.6 ;
    alert.view.layer.cornerRadius = 15;
    alert.view.backgroundColor = UIColor.blackColor;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:message attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:15.0]}];
    
    [alert setValue:atrStr forKey:@"attributedMessage"];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 1; // duration in seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)showTableView:(UIView *)tableView title:(NSString *)title item:(LSDeviceSettingItem *)item
{
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect = CGRectMake(0, 0, 272, 300);
    [controller setPreferredContentSize:rect.size];
    [controller.view addSubview:tableView];
    [controller.view bringSubviewToFront:tableView];
    [controller.view setUserInteractionEnabled:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showIndicatorView:prompt_setting handler:^{
            [self handleDeviceSettingItem:item valueKey:action.title];
        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Navigation prepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"clockSettingIdentifier"])
    {
        if([segue.destinationViewController isKindOfClass:[PedometerAlarmClockTVC class]])
        {
            NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
            PedometerAlarmClockTVC *view=( PedometerAlarmClockTVC *)segue.destinationViewController;
            view.settingCategory=(LSDeviceSettingCategory)indexPath.row;
            view.activeDevice=self.activeDevice;
        }
    }
    else if([segue.identifier isEqualToString:@"baseSettingIdentifier"])
    {
        NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
        BaseSettingItemTVC *view=( BaseSettingItemTVC *)segue.destinationViewController;
        view.activeDevice=self.activeDevice;
        LSDeviceSettingCategory category=(LSDeviceSettingCategory)indexPath.row;
        view.dataSources=[LSDeviceSettingItem settingItemWithCagetory:category];
        view.itemDelegate=self;
        view.item=[[LSDeviceSettingItem alloc] initWithCategory:category];

    }
}

#pragma mark - Setting Results

-(void)deviceSetingCategory:(LSDeviceSettingCategory)category
           didSettingReults:(BOOL)status
                  errorCode:(NSUInteger)code
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if(status){
                //setting success
                [self showToastView:prompt_setting_success];
            }
            else{
                //setting failure
                NSString *errorMsg=[NSString stringWithFormat:@"%@%@",prompt_setting_failure,@(code)];
                [self showToastView:errorMsg];
            }
        }];
    });
   
}

#pragma mark - Show DeviceSetting Item

-(void)showCustomPagesSetting
{
    NSMutableArray *pageItems=[NSMutableArray arrayWithCapacity:10];
    for(NSString *pageTitle in [LSDeviceSettingItem customDevicePages]){
        LSDeviceSettingItem *item=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryCustomPages];
        item.itemType=LSSettingItemMultiChoice;
        item.title=pageTitle;
        [pageItems addObject:item];
    }
    CustomTableView *tableView=[[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, 272, 300)
                                                           dataSource:pageItems
                                                             delegate:self];
    [self showTableView:tableView title:title_custom_pages item:pageItems.lastObject];
}


-(void)showDeviceSettingItem:(LSDeviceSettingItem *)item
{
    if(DSCategoryWeekTarget == item.type){
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:item.title
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Week Target Step";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.keyboardType=UIKeyboardTypeNumberPad;
        }];
        [alertView addAction:[UIAlertAction actionWithTitle:@"OK"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
            NSArray * textfields = alertView.textFields;
            UITextField *textField = textfields[0];
            NSString *textValue=textField.text;
            self.currentSelectCell.detailTextLabel.text=textValue;
            self.currentUserProfiles.weekTargetSteps=@(textValue.integerValue);
            [self showIndicatorView:prompt_setting handler:^{
                [self handleDeviceSettingItem:item valueKey:textValue];
            }];
        }]];
        // present alert view.
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else if(item.values.count){
        UIAlertController *alertView=[UIAlertController alertControllerWithTitle:item.title
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action)
                              {
                                  // Cancel button tappped.
                                  [self dismissViewControllerAnimated:YES completion:^{}];
                              }]];
        for(NSString *value in item.values) {
            [alertView addAction:[UIAlertAction actionWithTitle:value
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action)
        {
            self.currentSelectCell.detailTextLabel.text=action.title;
            [self showIndicatorView:prompt_setting handler:^{
                [self handleDeviceSettingItem:item valueKey:action.title];
            }];
        }]];
        }
        // Present action sheet.
        [self presentViewController:alertView animated:YES completion:nil];
    }
    else{
        //no action
        [self showIndicatorView:prompt_setting handler:^{
            [self handleDeviceSettingItem:item valueKey:item.title];
        }];
    }
}


-(void)handleDeviceSettingItem:(LSDeviceSettingItem *)item
                      valueKey:(NSString *)key
{
    NSNumber *value=[item valueOfKey:key];
    switch (item.type)
    {
        case DSCategoryTimeFormat:{
            //时间显示格式设置
            self.currentUserProfiles.hourFormat=key;
            LSDeviceTimeFormat timeFormat=(LSDeviceTimeFormat)value.unsignedIntegerValue;
            [[LSBluetoothManager defaultManager] updateTimeFormat:timeFormat
                                                        forDevice:self.activeDevice.broadcastId
                                                         andBlock:^(BOOL state, NSUInteger code)
            {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSCategoryDistanceUnit:{
            //距离显示单位设置，公制或英制
            LSDistanceUnit unit=(LSDistanceUnit)value.unsignedIntegerValue;
            self.currentUserProfiles.distanceUnit=key;
            [[LSBluetoothManager defaultManager] updateDistanceUnits:unit
                                                           forDevice:self.activeDevice.broadcastId
                                                            andBlock:^(BOOL state, NSUInteger code)
             {
                 [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
             }];
        }break;
        case DSCategoryScreenMode:{
            //屏幕显示方式设置
            LSScreenDisplayMode screenMode=(LSScreenDisplayMode)value.unsignedIntegerValue;
            [[LSBluetoothManager defaultManager] updateScreenMode:screenMode
                                                        forDevice:self.activeDevice.broadcastId
                                                         andBlock:^(BOOL state, NSUInteger code)
            {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSCategoryWearingMode:{
            //佩戴方式设置
            LSWearingStyle wearingMode=(LSWearingStyle)value.unsignedIntegerValue;
            [[LSBluetoothManager defaultManager] updateWearingStyles:wearingMode
                                                           forDevice:self.activeDevice.broadcastId
                                                            andBlock:^(BOOL state, NSUInteger code)
             {
                 [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
             }];
        }break;
        case DSCategoryHeartRateDetect:{
            //心率检测方式设置
            LSHRDetectionMode mode=(LSHRDetectionMode)value.unsignedIntegerValue;
            [[LSBluetoothManager defaultManager] updateHeartRateDetectionMode:mode
                                                                    forDevice:self.activeDevice.broadcastId
                                                                     andBlock:^(BOOL state, NSUInteger code)
             {
                 [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
             }];
        }break;
        case DSCategoryDialpaceMode:{
            //表盘样式设置
            LSDialPeaceStyle dialpeace=(LSDialPeaceStyle)value.unsignedIntegerValue;
            LSDeviceDialPeaceInfo *obj=[[LSDeviceDialPeaceInfo alloc] init];
            obj.dialStyle=dialpeace;
            [[LSBluetoothManager defaultManager] updateDialPeaceInfo:obj
                                                           forDevice:self.activeDevice.broadcastId
                                                            andBlock:^(BOOL state, NSUInteger code)
             {
                 [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
             }];
        
        }break;
        case DSCategoryAutoDiscern:{
            //运动模式自动识别设置
            LSAutomaticSportstype type=(LSAutomaticSportstype)value.unsignedIntegerValue;
            LSAutomaticSportstypeModel *obj=[[LSAutomaticSportstypeModel alloc] init];
            obj.type=type;
            [[LSBluetoothManager defaultManager] updateAutoRecognition:@[obj]
                                                             forDevice:self.activeDevice.broadcastId
                                                              andBlock:^(BOOL state, NSUInteger code)
            {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
         
        }break;
        case DSCategoryTakePictures:{
          //拍摄模式设置
            LSPhotographingInfo *obj=[[LSPhotographingInfo alloc] init];
            obj.status=value.unsignedIntegerValue;
            [[LSBluetoothManager defaultManager] pushDeviceMessage:obj
                                                         forDevice:self.activeDevice.broadcastId
                                                          andBlock:^(BOOL state, NSUInteger code)
            {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSCategoryWeekTarget:{
            //更新周目标步数
            int stepGoal=(int)key.intValue;
            [[LSBluetoothManager defaultManager] updateStepGoal:stepGoal
                                                       isEnable:YES
                                                      forDevice:self.activeDevice.broadcastId
                                                       andBlock:^(BOOL state, NSUInteger code)
            {
               [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSCategoryWeekStart:{
            //星期开始设置
            self.currentUserProfiles.weekStart=key;
            [self deviceSetingCategory:item.type didSettingReults:YES  errorCode:0];
        }break;
        case DSCategoryDevicePositioning:{
            //设备定位命令
            LSPositioningInfo *obj=[[LSPositioningInfo alloc] init];
            [[LSBluetoothManager defaultManager] pushDeviceMessage:obj
                                                         forDevice:self.activeDevice.broadcastId
                                                          andBlock:^(BOOL state, NSUInteger code)
            {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSCategoryCustomPages:{
            //设置自定义页面
            [[LSBluetoothManager defaultManager] updatePageSequence:self.customPages
                                                          forDevice:self.activeDevice.broadcastId
                                                           andBlock:^(BOOL state, NSUInteger code)
            {
                _customPages=nil;
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSAppointmentRemind:{
            //Kchiing Appointment reminder
            NSLog(@"add appoint reminder");
            KCIAppointmentReminder *appointReminder=[[KCIAppointmentReminder alloc] init];
            appointReminder.remindTime=1542814820+3600*4;
            appointReminder.status=YES;
            appointReminder.reminderIndex=2;
            appointReminder.vibrationLength=20;
//            appointReminder.repeatSetting=minuteRepeat;
            appointReminder.totalStatus=YES;
            appointReminder.location=@"where ?";
            appointReminder.appointTime=1542814820+3600*6;
            [[LSBluetoothManager defaultManager] pushDeviceMessage:appointReminder
                                                         forDevice:self.activeDevice.broadcastId
                                                          andBlock:^(BOOL state, NSUInteger code) {
                [self deviceSetingCategory:item.type didSettingReults:state errorCode:code];
            }];
        }break;
        case DSSimpleRemind:{
            //kchiing simple reminder
            NSLog(@"add simple reminder");

        }break;
        case DSMessageRemind:{
            //message reminder
            NSLog(@"add message reminder");

        }break;
        case DSWakeupRemind:{
            //wakeup reminder
            NSLog(@"add wakeup reminder");

        }break;
        default:{
            [self deviceSetingCategory:item.type didSettingReults:NO errorCode:0xff];//undefined
            NSLog(@"undefine setting item action %@ ; key:%@; value:%@",@(item.type),key,[item valueOfKey:key]);
        }break;
    }
}

-(void)deviceSettingItem:(LSDeviceSettingItem *)item didSelectionValue:(NSUInteger)value
{
    NSLog(@"onSettingItem:%@,status:%@",item.title,@(value));
    if(item.type == DSCategoryCustomPages){
        LSDevicePageType page=(LSDevicePageType)[item valueOfKey:item.title].unsignedIntegerValue;
        if(value ==1){
            //add
            [self.customPages addPage:page];
        }
        else{
            //remove
            [self.customPages removePage:page];
        }
    }
}

@end
