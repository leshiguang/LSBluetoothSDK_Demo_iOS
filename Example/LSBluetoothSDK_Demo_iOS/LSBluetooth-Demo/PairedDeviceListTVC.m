//
//  PairedDeviceListTVC.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/18.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "PairedDeviceListTVC.h"
#import "DeviceTableViewCell.h"
#import "SearchDeviceTVC.h"
#import "LSDatabaseManager.h"
#import "BleDevice+Handler.h"
#import "DataFormatConverter.h"
#import "DatabaseManagerDelegate.h"
#import "DeviceUser+Handler.h"
#import "DeviceUser.h"
#import "DeviceUserProfiles+Handler.h"
#import "DeviceAlarmClock+Handler.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CALayer.h>
#import "ScanFilter+Handler.h"
#import "DeviceViewController.h"
//test message
static NSString *AppVersionName = @"V1.4.3 build1";
static NSString *KSyncingDataTips=@"Syncing Data.";
static NSString *KNoDeviceTips=@"No Device";
static NSString *kConnectedSuccess=@"Connected Success";
static NSString *kConnectedFailed=@"Connected Failed";
static NSString *kDisConnected=@"Disconnect";
static NSString *kWeightData=@"WeightData";
static NSString *kWeightAppendData=@"WeightAppendData";

@interface PairedDeviceListTVC ()<DatabaseManagerDelegate,LSDeviceDataDelegate,LSDebugMessageDelegate>

@property(nonatomic,strong)LSBluetoothManager *bleManager;
@property(nonatomic,strong)NSMutableArray *pairedDeviceArray;
@property(nonatomic,strong)NSArray<LSDeviceInfo *> *measureDevices;
@property(nonatomic,strong)DeviceTableViewCell *deviceTableViewCell;
@property(nonatomic,strong)LSDatabaseManager *databaseManager;
@property(nonatomic,strong)DeviceUser *currentUser;
@property(nonatomic,strong)NSMutableDictionary *indexPathMap;
@property(nonatomic,strong)UILabel *syncingTipsTitle;
@property(nonatomic,strong)UIActivityIndicatorView  *syncingIndicatorView;
@property(nonatomic,strong)NSTimer *updateTextValueTimer;
@property(nonatomic,strong)UILabel *noDeviceTipsTitle;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)NSMutableDictionary *deviceDataMap;
@property (nonatomic,strong) CATransition *animation;
@property (nonatomic,strong)UISwitch *syncDataSwitch;
@property(nonatomic,strong)NSString *currentConnectedProtocol;

@property(nonatomic,strong)LSDeviceInfo *upgradeDevice;

@property(nonatomic,strong)NSDateFormatter *measureDateFormatter;

@end

#define TEST_SERVER_URI @"ws://192.168.228.86:9999"

@implementation PairedDeviceListTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexPathMap=[[NSMutableDictionary alloc] init];
    self.pairedDeviceArray=[[NSMutableArray alloc] init];
    self.databaseManager=[LSDatabaseManager defaultManager];
    self.databaseManager.databaseDelegate=self;
    self.measureDateFormatter=[[NSDateFormatter alloc] init];
    self.measureDateFormatter.dateFormat=@"hh24miss";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"HHmmss";
    
    NSLog(@"my test date formatter :%@, otherFormat:%@",[self.measureDateFormatter stringFromDate:date],[dateFormatter stringFromDate:date]);

}

-(void)viewWillAppear:(BOOL)animated
{
    [self loadDataFromDatabase];
    self.deviceDataMap=[[NSMutableDictionary alloc] init];

}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(managedContextChanged:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:self.databaseManager.managedContext];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:NSManagedObjectContextDidSaveNotification
                    object:self.databaseManager.managedContext];
    [super viewDidDisappear:animated];
}

#pragma mark - object init

-(UILabel *)noDeviceTipsTitle
{
    if(!_noDeviceTipsTitle)
    {
        _noDeviceTipsTitle=[[UILabel alloc] init];
        [_noDeviceTipsTitle setFrame:CGRectMake(15, 8, 100, 12)];
        [_noDeviceTipsTitle setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _noDeviceTipsTitle.textColor=[UIColor lightGrayColor];
        [_noDeviceTipsTitle setFont:[UIFont boldSystemFontOfSize:13]];
    }
    return _noDeviceTipsTitle;
}

-(CATransition *)animation
{
    if(!_animation)
    {
        _animation=[CATransition animation];
        _animation.duration=1.0;
        _animation.type=kCATransitionReveal;//kCATransitionFade|
        _animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    return _animation;
}

-(UILabel *)syncingTipsTitle
{
    if(!_syncingTipsTitle)
    {
        _syncingTipsTitle=[[UILabel alloc] init];
        [_syncingTipsTitle setFrame:CGRectMake(15+20+5, 7, 100, 14)];
        [_syncingTipsTitle setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _syncingTipsTitle.textColor=[UIColor lightGrayColor];
        [_syncingTipsTitle setFont:[UIFont boldSystemFontOfSize:13]];
    }
    return _syncingTipsTitle;
}

-(DeviceTableViewCell *)deviceTableViewCell
{
    if(!_deviceTableViewCell)
    {
        _deviceTableViewCell=[self.tableView dequeueReusableCellWithIdentifier:@"DeviceTableViewCell"];
    }
    return _deviceTableViewCell;
}

-(LSBluetoothManager *)bleManager
{
    if (!_bleManager)
    {
        _bleManager=[LSBluetoothManager defaultManager];
    }
    return _bleManager;
}

-(NSArray<LSDeviceInfo *>*)measureDevices
{
    if(!self.pairedDeviceArray.count)
    {
        return  nil;
    }
    NSMutableArray *devices=[[NSMutableArray alloc] initWithCapacity:self.pairedDeviceArray.count];
    for(BleDevice *device in self.pairedDeviceArray)
    {
        LSDeviceInfo *lsDevice=[DataFormatConverter convertedToLSDeviceInfo:device];
        [devices addObject:lsDevice];
    }
    return devices;
}


-(NSMutableArray *)getDeviceMeasureDatas:(NSString *)broadcastId
{
  
    if([self.deviceDataMap objectForKey:broadcastId.uppercaseString])
    {
        return [self.deviceDataMap objectForKey:broadcastId.uppercaseString];
    }
    else
    {
        return [[NSMutableArray alloc] init];
    }
}

-(DeviceUser *)currentUser
{
    if(!_currentUser)
    {
        _currentUser=(DeviceUser *)[self.databaseManager objectForEntityForName:@"DeviceUser"
                                                                          predicate:nil];
    }
    return _currentUser;
}

#pragma mark - Action 

- (IBAction)autoSyncData:(UISwitch *)sender
{
    if(sender.isOn)
    {
        if(!self.pairedDeviceArray.count)
        {
            return;
        }
        NSLog(@"start auto sync data");
        [self showSyncingTipsInSectionTitle];
        //clear all old measure device
        //add new measure device
        for(LSDeviceInfo *lsDevice in self.measureDevices)
        {
            [self.bleManager addMeasureDevice:@"" andDevice:lsDevice result:^(NSUInteger result) {
                if(lsDevice.deviceType==LSDeviceTypePedometer
                   && [lsDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame)
                {
                    [self setupPedometerUserInfoOnSyncMode:lsDevice.deviceId];
                }
                else if (lsDevice.deviceType==LSDeviceTypeFatScale)
                {
                    [self setupProductUserInfoOnSyncMode:lsDevice.deviceId
                                              userNumber:lsDevice.deviceUserNumber];
                }
            }];
            
            
        }
        //start data sync service
        [self.bleManager startDataReceiveService:self];
    }
    else
    {
        [self removeSyncingTips];
        [self.bleManager stopDataReceiveService];
        
    }
}

#pragma mark - Device Setting Info

/**
 * 在数据同步模式中，设置秤的用户信息
 */
-(void)setupProductUserInfoOnSyncMode:(NSString *)deviceId userNumber:(NSUInteger)userNumber
{
    if (!deviceId.length)
    {
        return;
    }
    LSProductUserInfo *userInfo=[DataFormatConverter getProductUserInfo:self.currentUser];
    userInfo.deviceId=deviceId;
    userInfo.userNumber=userNumber;
    NSLog(@"set product user info on sync mode %@",[DataFormatConverter parseObjectDetailInDictionary:userInfo]);
    
    [self.bleManager setProductUserInfo:userInfo forDevice:deviceId];
}

/**
 * 在数据同步模式中，设置闹钟信息
 */
-(void)setupPedometerUserInfoOnSyncMode:(NSString *)deviceId
{
    if (!deviceId.length)
    {
        return ;
    }
    DeviceAlarmClock *deviceAlarmClock=self.currentUser.userprofiles.deviceAlarmClock;
    //set pedometer alarm clock in data syncing mode
    LSPedometerAlarmClock *alarmClock=[DataFormatConverter getPedometerAlarmClock:deviceAlarmClock];
    alarmClock.deviceId=deviceId;
    [self.bleManager setPedometerAlarmClock:alarmClock forDevice:deviceId];
    
    //set pedometer user info in data syncing mode
    LSPedometerUserInfo *pedometerUserInfo=[DataFormatConverter getPedometerUserInfo:self.currentUser];
    pedometerUserInfo.deviceId=deviceId;
    [self.bleManager setPedometerUserInfo:pedometerUserInfo forDevice:deviceId];
}

#pragma mark - private methods

/**
 * 从数据库查询已绑定的设备列表
 */
-(void)loadDataFromDatabase
{
    [self.pairedDeviceArray removeAllObjects];
    NSArray *deviceArray=[self.databaseManager allObjectForEntityForName:@"BleDevice" predicate:nil];
    if(![deviceArray count])
    {
        return ;
    }
    for (BleDevice *device in deviceArray)
    {
        [self.pairedDeviceArray addObject:device];
    }
    [self.tableView reloadData];
}

/**
 * 从数据库更新通知
 */
-(void)managedContextChanged:(NSNotification *)notification
{
    NSDictionary *userInfo=notification.userInfo;
    if(userInfo && [userInfo count])
    {
//        NSLog(@"insert value %@",[userInfo valueForKeyPath:NSInsertedObjectsKey]);
//        NSLog(@"update value %@",[userInfo valueForKeyPath:NSUpdatedObjectsKey]);
//        NSLog(@"delete value %@",[userInfo valueForKeyPath:NSDeletedObjectsKey]);
    }
}

/**
 * 更新设备的连接状态
 */
-(void)updateGattConnectStatus:(NSString *)broadcastId
                        status:(LSDeviceConnectState)connectState
{
    if(!self.pairedDeviceArray.count)
    {
        return ;
    }
    NSIndexPath *indexPath=[self.indexPathMap valueForKey:broadcastId];
    DeviceTableViewCell *cell=(DeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    BleDevice *deviceItem=[self.pairedDeviceArray objectAtIndex:indexPath.row];
    self.currentConnectedProtocol=deviceItem.protocolType;
    if(connectState==LSDeviceStateConnectSuccess)
    {
        cell.connectStateLabel.text=kConnectedSuccess;
        cell.connectStateLabel.textColor=[[UIColor alloc] initWithRed:0 green:100/255.0f blue:0 alpha:1];
        cell.connectStateLabel.font=[UIFont boldSystemFontOfSize:14];
    }
    else if(connectState==LSDeviceStateConnectFailure)
    {
        cell.connectStateLabel.text=kConnectedFailed;
        cell.connectStateLabel.textColor=[UIColor brownColor];
    }
    else
    {
        cell.connectStateLabel.text=kDisConnected;
        cell.connectStateLabel.textColor=[UIColor redColor];
    }
    [self setTextAnimation:cell.connectStateLabel key:@"3"];
}

/**
 * 设置文本显示的动画
 */
-(void)setTextAnimation:(UILabel *)label key:(NSString *)key
{
    if([self.animation isRemovedOnCompletion]){
        [label.layer addAnimation:self.animation forKey:key];
    }
}

/**
 * 更新测量数据记录
 */
-(void)updateRecordNumber:(NSString *)broadcastId
                    count:(NSUInteger)count text:(NSString *)textValue unit:(NSString *)unit
{
    NSIndexPath *indexPath=[self.indexPathMap valueForKey:broadcastId];
    DeviceTableViewCell *cell=(DeviceTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(count>0)
    {
        [self setTextAnimation:cell.recordTipLabel key:@"changeTextTransition2"];
        cell.recordTipLabel.clipsToBounds=YES;
        cell.recordTipLabel.layer.cornerRadius=5;
        cell.recordTipLabel.layer.borderWidth=1.0f;
        cell.recordTipLabel.layer.backgroundColor=[UIColor redColor].CGColor;
        cell.recordTipLabel.layer.borderColor=[UIColor redColor].CGColor;
        cell.recordTipLabel.text=@"";
        [self setTextAnimation:cell.recordLabel key:@"changeTextTransition1"];
        cell.recordLabel.text=[NSString stringWithFormat:@"%ld Record",(unsigned long)count];
    }
    else
    {
        UIScreen *mainScreenRect=[UIScreen mainScreen];
        CGFloat screenWidth=mainScreenRect.bounds.size.width;
        //for kitchen scale
        cell.recordTipLabel.frame=CGRectMake(screenWidth-50-15, 10, 50, 21);
        cell.recordTipLabel.textAlignment=NSTextAlignmentRight;
        cell.recordTipLabel.textColor=[UIColor grayColor];
        cell.recordTipLabel.font=[UIFont systemFontOfSize:13];
     
        if(![cell.recordTipLabel.text isEqualToString:unit])
        {
            [self setTextAnimation:cell.recordTipLabel key:@"unit text change"];
        }
        cell.recordTipLabel.text=unit;
        cell.recordLabel.frame=CGRectMake(screenWidth-200-10, 30, 200, 21);
        cell.recordLabel.textAlignment=NSTextAlignmentRight;
        cell.recordLabel.text=[NSString stringWithFormat:@"%@",textValue];
    }
}



-(void)updateLabelTextValue:(NSTimer *)timer
{
    UILabel *label= timer.userInfo;
    NSMutableString *textValue=[[NSMutableString alloc] initWithString:label.text];
    
    int tempCount=rand()%5;
    if(tempCount<4)
    {
        [textValue appendString:@"."];
        label.text=textValue;
    }
    else if(tempCount==4)
    {
        label.text=KSyncingDataTips;
    }
}

-(void)showSyncingTipsInSectionTitle
{
    [self.headerView addSubview:self.syncingIndicatorView];
    [self.headerView addSubview:self.syncingTipsTitle];
    [self.syncingIndicatorView startAnimating];
    self.syncingTipsTitle.text=KSyncingDataTips;
    self.updateTextValueTimer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(updateLabelTextValue:) userInfo:self.syncingTipsTitle repeats:YES];
}

-(void)removeSyncingTips
{
    [self.syncingIndicatorView stopAnimating];
     self.syncingTipsTitle.text=@"";
    if(self.updateTextValueTimer)
    {
        [self.updateTextValueTimer invalidate];
    }
    self.updateTextValueTimer=nil;
    [self.syncingTipsTitle removeFromSuperview];
    [self.syncingIndicatorView removeFromSuperview];
}


#pragma mark -showInsertCellAnimation

-(void)showInsertCellAnimation:(UITableViewCell *)cell tableView:(UITableView *)tableView forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect mRect=[tableView rectForRowAtIndexPath:indexPath];
    //instead of 320,choose the origin of your animation
    cell.frame=CGRectMake(cell.frame.origin.x-320, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.1 *indexPath.row
                                 options:UIViewAnimationOptionCurveEaseInOut
                              animations:^{
                                  //instead of -30,choose how much you want the cell to get "under" the cell above
                                  cell.frame=CGRectMake(mRect.origin.x, mRect.origin.y-30, mRect.size.width, mRect.size.height);
                              }
                              completion:^(BOOL finished) {
                                  [UIView animateWithDuration:0.5 animations:^{
                                      cell.frame=mRect;
                                  }];
                              }];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    if(section==0)
    {
        return 2;
    }
    if(section==1)
    {
        rowCount=[self.pairedDeviceArray count];
    }
    return rowCount;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        return 70;
    }
    else
    {
        return [super tableView:tableView  heightForRowAtIndexPath:indexPath];
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 15)];
    [self.headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    if (section==1 )
    {
        if([self.pairedDeviceArray count]==0)
        {
            self.noDeviceTipsTitle.text=KNoDeviceTips;
            [self.headerView addSubview:self.noDeviceTipsTitle];
        }
        else
        {
            self.headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
            [self.headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
            self.syncingIndicatorView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            self.syncingIndicatorView.color=[UIColor lightGrayColor];
            self.syncingIndicatorView.frame=CGRectMake(15, 8, 20, 12);
            self.syncingTipsTitle.text=@"";
        }
    }
    return self.headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=nil;
    if(indexPath.section==0)
    {
       
        if(indexPath.row==0)
        {
            UITableViewCell *cellView=nil;
            cellIdentifier=@"appVersionCell";
            cellView =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if(!cellView)
            {
                cellView=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdentifier];
            }
            cellView.accessoryType=UITableViewCellAccessoryNone;
            cellView.selectionStyle=UITableViewCellSelectionStyleNone;
            cellView.detailTextLabel.text=AppVersionName;
            return cellView;
        }
        else
        {
            UITableViewCell *autoSyncCell=nil;
            cellIdentifier=@"AutoSyncDataCell";
            autoSyncCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            autoSyncCell.textLabel.text=@"Auto Sync Data";
            autoSyncCell.selectionStyle=UITableViewCellSelectionStyleNone;
            self.syncDataSwitch=[[UISwitch alloc] initWithFrame:CGRectZero];
            autoSyncCell.accessoryView=self.syncDataSwitch;
            [self.syncDataSwitch setOn:NO animated:YES];
            [self.syncDataSwitch addTarget:self action:@selector(autoSyncData:) forControlEvents:UIControlEventValueChanged];
            return autoSyncCell;
        }
    }
    
    else 
    {
        DeviceTableViewCell *cellView=nil;
        cellIdentifier=@"DeviceTableViewCell";
        cellView =(DeviceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"DeviceCell" owner:self options:nil];
        cellView=[nib objectAtIndex:0];
        
        //get the item object
        BleDevice *device=[self.pairedDeviceArray objectAtIndex:indexPath.row];
        //set the item content
        cellView.recordLabel.text=@"";
        cellView.recordTipLabel.text=@"";
        cellView.userNumberLabel.text=[NSString stringWithFormat:@"UserNumber:%@",device.deviceUserNumber];
        cellView.protocolTypeLabel.text=device.protocolType;
        cellView.deviceImageView.image=[DataFormatConverter getDeviceImageViewWithType:[DataFormatConverter stringToDeviceType:device.deviceType]];
        //设置设备显示的名称
        NSString *deviceName=[DataFormatConverter getDeviceNameForNormalBroadcasting:device.deviceName];
        if(device.password.length)
        {
             cellView.deviceNameLabel.text=[NSString stringWithFormat:@"%@:%@",deviceName,device.broadcastID];
        }
        else
        {
            cellView.deviceNameLabel.text=[NSString stringWithFormat:@"%@:%@",device.deviceName,device.broadcastID];
        }
        [cellView.deviceNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.indexPathMap setValue:indexPath forKey:device.broadcastID];
        return cellView;
    }
   }

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        [self showInsertCellAnimation:cell tableView:tableView forRowAtIndexPath:indexPath];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
         return YES;
    }
    else return NO;
   
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        [tableView beginUpdates];

         NSArray *position=@[[NSIndexPath indexPathForRow:indexPath.row inSection:1]];
        BleDevice *deleteItem=(BleDevice *)self.pairedDeviceArray[indexPath.row];
        [self.bleManager deleteMeasureDevice:deleteItem.broadcastID];
        [self.indexPathMap removeObjectForKey:deleteItem.broadcastID];
        [self.pairedDeviceArray removeObject:deleteItem];
        [self.databaseManager.managedContext deleteObject:deleteItem];
        [self.databaseManager manuallySave];
        
        [tableView deleteRowsAtIndexPaths:position withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if(!self.pairedDeviceArray.count)
        {
            //no device
            [self removeSyncingTips];
             self.noDeviceTipsTitle.text=KNoDeviceTips;
            [self.headerView addSubview:self.noDeviceTipsTitle];
        }
        [tableView endUpdates];
    }
}

#pragma mark -UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
         [self performSegueWithIdentifier:@"ShowDeviceInfoIdentifier" sender:self];
    }
}


//if NO,disable perform segue
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if([identifier isEqualToString:@"SearchDeviceIdentifier"])
    {
        //禁止界面跳转
        return YES;
    }
    else return NO;
}



#pragma mark - Navigation Methods

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"ShowDeviceInfoIdentifier"])
    {
        if([segue.destinationViewController isKindOfClass:[DeviceViewController class]])
        {
            self.syncDataSwitch.on=NO;
            NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
             BleDevice *bleDevice=(BleDevice *)[self.pairedDeviceArray objectAtIndex:indexPath.row];
            DeviceViewController *deviceView=(DeviceViewController *)segue.destinationViewController;
            deviceView.currentDevice=[DataFormatConverter convertedToLSDeviceInfo:bleDevice];
            deviceView.measureDatas=[self.deviceDataMap objectForKey:bleDevice.broadcastID.uppercaseString];
            
        }
    }
    else if([segue.identifier isEqualToString:@"SearchDeviceIdentifier"])
    {
        if([segue.destinationViewController isKindOfClass:[SearchDeviceTVC class]])
        {
            [self.bleManager stopDataReceiveService];
            self.syncDataSwitch.on=NO;
        }
    }
}

#pragma mark - DatabaseManagerDelegate

-(void)databaseManagerDidCreatedManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSPredicate *queryPredicate=[NSPredicate predicateWithFormat:@"userID = %@",DEFAULT_USER_ID];
    NSArray *deviceUser=[self.databaseManager allObjectForEntityForName:@"DeviceUser"
                                                              predicate:queryPredicate];
    
    if([deviceUser count])
    {
        self.currentUser=[deviceUser lastObject];
        NSLog(@"my user info %@",[self.currentUser description]);
    }
    else
    {
        NSLog(@"no device user and user profiles,create.......");
        NSMutableDictionary *userInfo=[[NSMutableDictionary alloc] init];
        [userInfo setValue:DEFAULT_USER_ID forKeyPath:DEVICE_USER_KEY_ID];
        [userInfo setValue:@"sky" forKeyPath:DEVICE_USER_KEY_NAME];
        //1 for male,2 for female
        [userInfo setValue:@"Male" forKeyPath:DEVICE_USER_KEY_GENDER];
        [userInfo setValue:@"1.75" forKeyPath:DEVICE_USER_KEY_HEIGHT];
        [userInfo setValue:@"62" forKeyPath:DEVICE_USER_KEY_WEIGHT];
        [userInfo setValue:@"2" forKeyPath:DEVICE_USER_KEY_ATHLETELEVEL];
        [userInfo setValue:@"1989-09-01" forKeyPath:DEVICE_USER_KEY_BIRTHDAY];
        
        self.currentUser=[DeviceUser createDeviceUserWithUserInfo:userInfo
                                       inManagedObjectContext:managedObjectContext];
        
        NSMutableDictionary *userProfiles=[[NSMutableDictionary alloc] init];
        [userProfiles setValue:DEFAULT_USER_ID forKeyPath:KEY_USER_PROFILES_ID];
        [userProfiles setValue:@"Kg" forKeyPath:KEY_USER_PROFILES_WEIGHT_UNIT];
        //1 for male,2 for female
        [userProfiles setValue:@"65" forKeyPath:KEY_USER_PROFILES_WEIGHT_TARGET];
        [userProfiles setValue:@"Sunday" forKeyPath:KEY_USER_PROFILES_WEEK_START];
        [userProfiles setValue:@"24" forKeyPath:KEY_USER_PROFILES_HOUR_FORMAT];
        [userProfiles setValue:@"Kilometer" forKeyPath:KEY_USER_PROFILES_DISTANCE_UNIT];
        [userProfiles setValue:@"10000" forKeyPath:KEY_USER_PROFILES_WEEK_TARGET_STEPS];
        
        [userProfiles setValue:@"1" forKeyPath:KEY_USER_PROFILES_ALARM_CLOCK_ID];
        [userProfiles setValue:@"1" forKeyPath:KEY_USER_PROFILES_SCAN_FILTER_ID];
        
        [DeviceUserProfiles createUserProfilesWithInfo:userProfiles inManagedObjectContext:managedObjectContext];
        
        NSMutableDictionary *alarmClock=[[NSMutableDictionary alloc] init];
        [alarmClock setValue:@"1" forKeyPath:KEY_ALARM_CLOCK_ID];
        [alarmClock setValue:[NSDate date] forKeyPath:KEY_ALARM_CLOCK_TIME];
        [alarmClock setValue:@"127" forKeyPath:KEY_ALARM_CLOCK_DAY];//for all day
        
        NSNumber *defaultValue=[NSNumber numberWithBool:YES];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_MONDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_TUESDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_WEDNESDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_THURSDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_FRIDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_SATURDAY];
        [alarmClock setValue:defaultValue forKeyPath:KEY_ALARM_CLOCK_SUNDAY];
        
        [DeviceAlarmClock createAlarmClockWithInfo:alarmClock inManagedObjectContext:managedObjectContext];
        
        NSMutableDictionary *scanFilterInfo=[[NSMutableDictionary alloc] init];
        [scanFilterInfo setValue:@"1" forKeyPath:KEY_SCAN_FILTER_ID];
        [scanFilterInfo setValue:@"All" forKeyPath:KEY_SCAN_FILTER_BROADCAST];
        
        NSNumber *enable=[NSNumber numberWithBool:YES];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_FAT_SCALE];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_HEIGHT];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_KITCHEN];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_WEIGHT_SCALE];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_PEDOMETER];
        [scanFilterInfo setValue:enable forKeyPath:KEY_SCAN_FILTER_BLOOD_PRESSURE];
        
        [ScanFilter createScanFilterWithInfo:scanFilterInfo inManagedObjectContext:managedObjectContext];
        
    }
    
    [self loadDataFromDatabase];
}


#pragma mark LSDeviceDataDelegate

/**
 * 设备连接状态改变
 */
-(void)bleDevice:(LSDeviceInfo *)device didConnectStateChange:(LSDeviceConnectState)connectState
{
    [self updateGattConnectStatus:device.broadcastId status:connectState];
}

/**
 * 秤的体重测量数据
 */
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeight:(LSWeightData *)weightData
{
    if(!weightData)
    {
        return;
    }
    if([self.currentConnectedProtocol isEqualToString:@"GENERIC_FAT"])
    {
        NSString *value=nil;
        NSString *weightValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:weightData.weight];
        
        if([weightData.measureUnits isEqualToString:@"LB"])
        {
            value=[NSString stringWithFormat:@"%f",weightData.lbWeightValue];
        }
        else
        {
            value=weightValue;
        }
        
        [self updateRecordNumber:weightData.broadcastId count:0 text:value unit:weightData.measureUnits];
    }
    else
    {
        NSMutableArray *datalist=[self getDeviceMeasureDatas:weightData.broadcastId];
        NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:weightData];
        [datalist addObject:dataStr];
        [self.deviceDataMap setObject:datalist forKey:device.broadcastId.uppercaseString];
    
        [self updateRecordNumber:weightData.broadcastId count:datalist.count text:nil unit:nil];
    }
}

/**
 * 秤的脂肪测量数据
 */
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeightAppend:(LSWeightAppendData *)data
{
    if(!data)
    {
        return ;
    }
    NSMutableArray *datalist=[self getDeviceMeasureDatas:data.broadcastId];
    
    NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
    [datalist addObject:dataStr];
    [self.deviceDataMap setObject:datalist forKey:device.broadcastId.uppercaseString];
    
    [self updateRecordNumber:data.broadcastId count:datalist.count text:nil unit:nil];
}


/**
 * 血压测量数据
 */
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodPressure:(LSSphygmometerData *)data
{
    if (!data)
    {
        return ;
    }
    NSMutableArray *datalist=[self getDeviceMeasureDatas:data.broadcastId];
    NSArray *dataStr=[DataFormatConverter parseBloodPressureMeterMeasureData:data];
    [datalist addObject:dataStr];
    [self.deviceDataMap setObject:datalist forKey:device.broadcastId.uppercaseString];
    [self updateRecordNumber:data.broadcastId count:datalist.count text:nil unit:nil];
}

/**
 * 厨房秤测量数据
 */
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForKitchen:(LSKitchenScaleData *)kitchenData
{
    if(!kitchenData)
    {
        NSLog(@"Error,failed to get kitchen scale measured data");
        return;
    }
    NSString *value=nil;
    NSString *weightValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:kitchenData.weight];
    if([kitchenData.measureUnits isEqualToString:@"LB OZ"])
    {
        value=[NSString stringWithFormat:@"%ld:%@",(long)kitchenData.sectionWeight,weightValue];
    }
    else
    {
        value=weightValue;
    }
    [self updateRecordNumber:kitchenData.broadcastId count:0 text:value unit:kitchenData.measureUnits];
}

/**
 * 手环测量数据
 */
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForPedometer:(LSDeviceData *)data
{
    if(!data)
    {
        return ;
    }
    NSArray *dataStr=[DataFormatConverter parseDeviceMeasureData:data];
    NSMutableArray *datalist=[self getDeviceMeasureDatas:device.broadcastId];
    [datalist addObject:dataStr];
    [self.deviceDataMap setObject:datalist forKey:device.broadcastId.uppercaseString];

    [self updateRecordNumber:device.broadcastId count:datalist.count text:nil unit:nil];
}

-(void)bleDevice:(LSDeviceInfo *)device didProductUserInfoUpdate:(LSProductUserInfo *)userInfo
{
    NSLog(@"ui log:%@",[DataFormatConverter parseObjectDetailInDictionary:userInfo]);
}

-(void)bleDeviceDidInformationUpdate:(LSDeviceInfo *)device
{
    //update and save device firmware version
    NSString *userId=self.currentUser.userID;
    [BleDevice bindDeviceWithUserId:userId
                         deviceInfo:device
             inManagedObjectContext:self.databaseManager.managedContext];

}


@end
