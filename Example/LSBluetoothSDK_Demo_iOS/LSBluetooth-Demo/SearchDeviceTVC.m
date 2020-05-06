//
//  SearchDeviceTVC.m
//  LSBluetooth-Demo
//
//  Created by lifesense on 15/8/19.
//  Copyright (c) 2015年 Lifesense. All rights reserved.
//

#import "SearchDeviceTVC.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>
#import "ScanResultsTableViewCell.h"
#import "DataFormatConverter.h"
#import "DatabaseManagerDelegate.h"
#import "DeviceUser+Handler.h"
#import "DeviceUser.h"
#import "ScanFilter.h"
#import "LSDatabaseManager.h"
#import "DeviceUserProfiles.h"
#import "PairedDeviceListTVC.h"
#import <objc/runtime.h>
#import "BleDevice+Handler.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "DeviceViewController.h"
#import "AlertViewUtils.h"

typedef enum {
    WorkingStatusFree,
    WorkingStatusSearchDevice,
    WorkingStatusPairDevice,
    WorkingStatusSaveDevice,
    WorkingStatusConfigWifiPassword,
}WorkingStatus;


static NSString *kBroadcastAll=@"All";
static NSString *kBroadcastNormal=@"Normal";
static NSString *kBroadcastPair=@"Pair";
static NSString *kSearchingTitle=@"Searching,please wait.";
static NSString *kPairingTitle=@"Pairing,please wait.";
static NSString *KSearchingTips=@"Searching.";


//test wifi password
static NSString *kWifiSsid=@"Lifesense_Work";
static NSString *kWifiPassword=@"86358868";

#define title_scan_failed               @"Scan Failed"
#define msg_bluetooth_available         @"Bluetooth is not available."
#define title_pair_failed               @"Pair Failed"
#define title_pair_success              @"Pair Success"
#define msg_pair_failed                 @"failed to pairing with device,please try again."
#define title_device_info               @"Device Information"
#define title_scanning                  @"Scanning,please wait...\n\n"
#define title_pairing                   @"Pairing,please wait...\n\n"
#define title_device_users              @"Device Users"
#define title_device_rssi               @"Device Rssi"

#define filter_rssi_20                  @"-20"
#define filter_rssi_30                  @"-30"
#define filter_rssi_40                  @"-40"
#define filter_rssi_50                  @"-50"
#define filter_rssi_60                  @"-60"
#define filter_rssi_70                  @"-70"
#define filter_rssi_80                  @"-80"
#define filter_rssi_90                  @"-90"
#define filter_rssi_all                 @"< -90 "


@interface SearchDeviceTVC ()<LSDevicePairingDelegate,LSBluetoothStatusDelegate>

@property(nonatomic)BOOL isSearching;
@property(nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong)UITableViewCell *currentSelectCell;
@property(nonatomic,strong)NSMutableArray *scanResultsArray;
@property(nonatomic,strong)ScanFilter *currentScanFilter;
@property (nonatomic,strong)LSBluetoothManager *lsBleManager;
@property(nonatomic)NSUInteger searchTimeCount;
@property(nonatomic)WorkingStatus currentWorkingStatus;
@property(nonatomic,strong)LSDatabaseManager *databaseManager;
@property(nonatomic,strong)DeviceUser *currentDeviceUser;
@property(nonatomic,strong)NSMutableArray *deviceUserArray;
@property(nonatomic,strong)UILabel *searchingTipsTitle;
@property(nonatomic,strong)LSDeviceInfo *currentDevice;
@property(nonatomic,strong)NSMutableDictionary *indexPathMap;
@property(nonatomic,strong)UIBarButtonItem *startScanningItem;
@property(nonatomic,strong)UIBarButtonItem *stopScanningItem;
@property(nonatomic,strong)CATransition *animation;
@property(nonatomic,strong)NSNumber *filterRssi;
@property(nonatomic,strong)UIActivityIndicatorView  *scanningView;

@end

@implementation SearchDeviceTVC

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexPathMap=[[NSMutableDictionary alloc] init];
    self.lsBleManager=[LSBluetoothManager defaultManager];
    self.currentScanFilter=self.currentDeviceUser.userprofiles.hasScanFilter;
    self.scanResultsArray=[[NSMutableArray alloc] init];
    [self.lsBleManager checkingBluetoothStatus:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if(self.isSearching)
    {
        [self.lsBleManager stopSearch];
    }
    if( self.currentWorkingStatus==WorkingStatusPairDevice)
    {
        //cancel pairing process
        [self.lsBleManager cancelDevicePairing:self.currentDevice];
    }
   [super viewDidDisappear:animated];
}

-(void)dealloc{
    NSLog(@"sky-test on dealloc >>>>>>>>>>>>>>");
}

#pragma mark - Object init

-(NSNumber *)filterRssi
{
    if(!_filterRssi){
        _filterRssi=[NSNumber numberWithInt:-120];
    }
    return _filterRssi;
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

-(void)setTextAnimation:(UILabel *)label key:(NSString *)key
{
    if([self.animation isRemovedOnCompletion]){
        [label.layer addAnimation:self.animation forKey:key];
    }
}

-(UIBarButtonItem *)startScanningItem
{
    if(!_startScanningItem)
    {
        UIBarButtonSystemItem systemItem=UIBarButtonSystemItemSearch;
        _startScanningItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                        target:self
                                                                        action:@selector(searching:)];
    }
    return _startScanningItem;
}
-(UIBarButtonItem *)stopScanningItem
{
    if(!_stopScanningItem)
    {
        UIBarButtonSystemItem systemItem=UIBarButtonSystemItemStop;
        _stopScanningItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                         target:self
                                                                         action:@selector(searching:)];
    }
    return _stopScanningItem;
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

-(UILabel *)searchingTipsTitle
{
    if(!_searchingTipsTitle)
    {
        _searchingTipsTitle=[[UILabel alloc] init];
        [_searchingTipsTitle setFrame:CGRectMake(15+20+5+1, 5, 200, 16)];
        [_searchingTipsTitle setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _searchingTipsTitle.textColor=[UIColor lightGrayColor];
        [_searchingTipsTitle setFont:[UIFont boldSystemFontOfSize:13]];
        _searchingTipsTitle.text=@"";
    }
    return _searchingTipsTitle;
}

-(UIActivityIndicatorView *)scanningView
{
    if(!_scanningView)
    {
        _scanningView= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _scanningView.color=[UIColor lightGrayColor];
        _scanningView.frame=CGRectMake(15, 6, 20, 12);//CGRectMake(15, 6, 200, 16)];
    }
    return _scanningView;
}

-(LSDatabaseManager *)databaseManager
{
    if(!_databaseManager)
    {
        _databaseManager=[LSDatabaseManager defaultManager];
    }
    return _databaseManager;
}

-(DeviceUser *)currentDeviceUser
{
    if(!_currentDeviceUser)
    {
        _currentDeviceUser=[[self.databaseManager allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    }
    return _currentDeviceUser;
}


-(NSArray *)broadcastTypeArray
{
    return @[kBroadcastAll,kBroadcastPair,kBroadcastNormal];
}


-(NSArray *)getEnableScanDeviceTypes
{
    NSMutableArray *enableTypes=[[NSMutableArray alloc] init];
    
    if([self.currentScanFilter.enableBloodPressure boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypeBloodPressureMeter)];
    }
    if([self.currentScanFilter.enableFatScale boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypeFatScale)];
    }
    if([self.currentScanFilter.enableHeightMeter boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypeHeightMeter)];
    }
    if([self.currentScanFilter.enableKitchenScale boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypeKitchenScale)];
    }
    if([self.currentScanFilter.enablePedometer boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypePedometer)];
    }
    if([self.currentScanFilter.enableWeightScale boolValue])
    {
        [enableTypes addObject:@(LSDeviceTypeWeightScale)];
    }
    
    if([self.currentScanFilter.enableAllDevice boolValue])
    {
        //重置
        enableTypes=[[NSMutableArray alloc] init];
        //扫描所有类型
        [enableTypes addObject:@(LSDeviceTypeUnknown)];
    }
    
    return enableTypes;
}

-(BroadcastType)getEnableScanBroadcastType
{
    NSString *broadcast=self.currentScanFilter.broadcastType;
    if([broadcast isEqualToString:kBroadcastNormal])
    {
        return BroadcastTypeNormal;
    }
    else if([broadcast isEqualToString:kBroadcastPair])
    {
        return BroadcastTypePair;
    }
    
    else return BroadcastTypeAll;
}

-(NSArray *)enableScanAllDevice
{
    return  @[@(LSDeviceTypeKitchenScale),@(LSDeviceTypePedometer),
              @(LSDeviceTypeFatScale),@(LSDeviceTypeWeightScale),
              @(LSDeviceTypeBloodPressureMeter),@(LSDeviceTypeHeightMeter)];
}

-(LSPedometerAlarmClock *)getDeviceAlarmClock
{
    DeviceAlarmClock *deviceAlarmClock=self.currentDeviceUser.userprofiles.deviceAlarmClock;
    LSPedometerAlarmClock *alarmClock=[DataFormatConverter getPedometerAlarmClock:deviceAlarmClock];
    NSLog(@"set pedometer alarm clock on pairing  mode %@",[DataFormatConverter parseObjectDetailInDictionary:alarmClock]);
    return alarmClock;
}

-(LSPedometerUserInfo *)getPedometerUserInfo
{
    LSPedometerUserInfo *userInfo=[DataFormatConverter getPedometerUserInfo:self.currentDeviceUser];
    NSLog(@"set pedometer user info on pairing  mode %@",[DataFormatConverter parseObjectDetailInDictionary:userInfo]);
    return userInfo;
}

-(LSProductUserInfo *)getProductUserInfo
{
    LSProductUserInfo *userInfo=[DataFormatConverter getProductUserInfo:self.currentDeviceUser];
    NSLog(@"set product user info on pairing mode %@",[DataFormatConverter parseObjectDetailInDictionary:userInfo]);
    return userInfo;
}

-(NSString *)getCurrentWifiHotSpotName
{
    NSString *wifiName = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs)
    {
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info[@"SSID"])
        {
            wifiName = info[@"SSID"];
        }
    }
    return wifiName;
}

-(void)dismissIndicatorView:(void (^ __nullable)(void))handler
{
    if(self.indicatorView.isAnimating){
        [self.indicatorView stopAnimating];
        [self dismissViewControllerAnimated:YES completion:handler];
    }
}

#pragma mark - View Action

- (IBAction)searching:(UIBarButtonItem *)sender
{
    if(!self.isSearching)
    {
        if(!self.lsBleManager.isBluetoothPowerOn){
            [AlertViewUtils showConfirmAlertView:title_scan_failed
                                         message:msg_bluetooth_available
                                      controller:self                                          handler:nil];
            return ;
        }
        self.navigationController.navigationBar.topItem.rightBarButtonItem=self.stopScanningItem;
        self.searchingTipsTitle.frame=CGRectMake(15+20+5+1, 4, 200, 16);
        self.currentWorkingStatus=WorkingStatusSearchDevice;
        self.isSearching=YES;
        //show scanning view
        [AlertViewUtils showIndicatorView:self.indicatorView
                                  message:title_scanning
                               controller:self
                                  handler:^{
             [self searchBluetoothDevice];
        }];
    }
    else
    {
        if(self.lsBleManager.managerStatus == ManagerStatusScaning){
            [self dismissIndicatorView:nil];
        }
        [self stopSearching];
    }
}

-(void)stopSearching
{
    if(self.scanningView.isAnimating){
        [self.scanningView stopAnimating];
    }
    self.navigationController.navigationBar.topItem.rightBarButtonItem=self.startScanningItem;
    self.currentWorkingStatus=WorkingStatusFree;
    self.isSearching=NO;
    [self.lsBleManager stopSearch];
    [self updateScanResults:@"" animationType:kCATransitionFade];
    if(self.scanResultsArray.count)
    {
        self.searchingTipsTitle.frame=CGRectMake(15, 4, 200, 16);
        NSString *countStr=[NSString stringWithFormat:@"Scan Results: %@",@(self.scanResultsArray.count)];
        [self updateScanResults:countStr animationType:kCATransitionFromTop];
    }
}

-(void)updateScanResults:(NSString *)results animationType:(NSString *)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchingTipsTitle.text=results;
        self.searchingTipsTitle.textColor=[UIColor brownColor];
        CATransition *animation=[CATransition animation];
        animation.duration=1.0;
        animation.type=type;//kCATransitionFade|
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.searchingTipsTitle.layer addAnimation:animation forKey:KSearchingTips];
        
    });
}

-(void)showDeviceUsers:(NSDictionary *)deviceUsers
{
    int index=1;
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:title_device_users
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    for(int num=1;num <= deviceUsers.count;num++)
    {
        NSString *userItem=[NSString stringWithFormat:@"User %@:%@",@(num),[deviceUsers objectForKey:@(num)]];
        [alertView addAction:[UIAlertAction actionWithTitle:userItem
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
            [AlertViewUtils showIndicatorView:self.indicatorView
                                      message:title_pairing
                                   controller:self
                                      handler:^{
              [self.lsBleManager bindingDeviceUser:self.currentDevice userNumber:index  userName:@"sky"];
            }];
         }]];
        index++;
    }
    // Present action sheet.
    [self presentViewController:alertView animated:YES completion:nil];
}

-(void)showRssiFilter
{
    int index=1;
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:title_device_rssi
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    
    for(int i=2;i<11;i++)
    {
        NSString *rssiItem=[NSString stringWithFormat:@"Rssi: %@",@(i*10*-1)];
        [alertView addAction:[UIAlertAction actionWithTitle:rssiItem
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
             NSUInteger index=[action.title rangeOfString:@":"].location+1;
             NSString *rssi=[action.title substringFromIndex:index];
             NSLog(@"rssi item : %@",rssi);
             self.filterRssi=@(rssi.intValue);
             self.currentSelectCell.detailTextLabel.text=rssi;
             NSMutableArray *devices=[[NSMutableArray alloc] initWithCapacity:20];
             for(LSDeviceInfo *device in self.scanResultsArray){
                 int rssi=device.rssi.intValue;
                 if(rssi > self.filterRssi.intValue){
                     [devices addObject:device];
                 }
             }
            if(devices.count){
                [self.scanResultsArray removeAllObjects];
                self.scanResultsArray=[NSMutableArray arrayWithArray:devices];
                //reload table view
                [self.tableView reloadData];
            }
             NSIndexPath *indexPath=[self.tableView indexPathForCell:self.currentSelectCell];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

         }]];
        index++;
    }
    // Present action sheet.
    [self presentViewController:alertView animated:YES completion:nil];
}

/**
 * 更新设备的信号强度
 */
-(void)updateRssiValue:(NSNumber *)rssi forDevice:(LSDeviceInfo *)lsDevice
{
    if(!self.scanResultsArray.count || lsDevice.isInSystem || !lsDevice.rssi || lsDevice.preparePair)
    {
        return ;
    }
    NSIndexPath *indexPath=[self.indexPathMap valueForKey:lsDevice.broadcastId];
    if(indexPath)
    {
        ScanResultsTableViewCell *cellView=(ScanResultsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        cellView.deviceLabel.text=[NSString stringWithFormat:@"%@",lsDevice.deviceName];
        if(lsDevice.macAddress.length){
            cellView.protocolLabel.text=[NSString stringWithFormat:@"%@",lsDevice.macAddress];
        }
        cellView.statusLabel.text=[NSString stringWithFormat:@"%@",lsDevice.rssi];
        [self setTextAnimation:cellView.statusLabel key:lsDevice.broadcastId];
    }
}

-(void)handleScanResults:(LSDeviceInfo *)lsDevice
{
    [self dismissIndicatorView:^{
        [self.scanningView startAnimating];
    }];
    BOOL isExisted=NO;
    if(self.scanResultsArray.count){
        for(LSDeviceInfo *dev in self.scanResultsArray)
        {
            if([dev.deviceName caseInsensitiveCompare:lsDevice.deviceName]==NSOrderedSame
               &&
               [dev.peripheralIdentifier caseInsensitiveCompare:lsDevice.peripheralIdentifier]==NSOrderedSame
               && [dev.broadcastId caseInsensitiveCompare:lsDevice.broadcastId] == NSOrderedSame)
            {
                isExisted=YES;
                break;
            }
        }
    }
    if(!isExisted)
    {
        //判断过滤条件
        int rssi=lsDevice.rssi.intValue;
        if(!(rssi > self.filterRssi.intValue)){
            return ;
        }
        [self.scanResultsArray addObject:lsDevice];
        NSArray *position=@[[NSIndexPath indexPathForRow:[self.scanResultsArray indexOfObject:lsDevice] inSection:1]];
        [self.tableView insertRowsAtIndexPaths:position withRowAnimation:UITableViewRowAnimationLeft];
        
        NSString *countStr=[NSString stringWithFormat:@"Scanning: %@",@(self.scanResultsArray.count)];
        [self updateScanResults:countStr animationType:kCATransitionFromBottom];
    }
    else
    {
        //更新设备Rssi信号
        [self updateRssiValue:lsDevice.rssi forDevice:lsDevice];
    }
}

#pragma mark - SDK Sample Code


-(void)searchBluetoothDevice
{
    [self.lsBleManager stopDataReceiveService];
    [self.lsBleManager stopSearch];
    [self.scanResultsArray removeAllObjects];
    [self.tableView reloadData];

    //you can change the device type which one or all you want to scan
    NSArray *enableScanDeviceTypes=[self getEnableScanDeviceTypes];
    __weak SearchDeviceTVC *weakSelf=self;
    [self.lsBleManager searchDevice:enableScanDeviceTypes
                          broadcast:BroadcastTypeAll
                       resultsBlock:^(LSDeviceInfo *lsDevice)
     {
         if(lsDevice){
             [weakSelf handleScanResults:lsDevice];
         }
     }];
}


-(void)pairingDevice:(LSDeviceInfo *)lsDevice
{
    self.currentWorkingStatus=WorkingStatusPairDevice;
    //stop search
    [self.lsBleManager stopSearch];
    if(lsDevice.deviceType==LSDeviceTypePedometer
       && [lsDevice.protocolType isEqualToString:@"A2"])
    {
        //set device alarm clock for pedometer
        [self.lsBleManager setPedometerAlarmClock:[self getDeviceAlarmClock] forDevice:nil];
        //set device user info for pedometer
        [self.lsBleManager setPedometerUserInfo:[self getPedometerUserInfo] forDevice:nil];
    }
    else if (lsDevice.deviceType==LSDeviceTypeFatScale)
    {
        //set device info for scale
        [self.lsBleManager setProductUserInfo:[self getProductUserInfo] forDevice:nil];
    }
    //show pairing view
    [AlertViewUtils showIndicatorView:self.indicatorView
                              message:title_pairing
                           controller:self
                              handler:^{
         [self.lsBleManager pairingWithDevice:lsDevice delegate:self];
    }];
}


#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount=0;
    if(section==0)
    {
        rowCount=2;
    }
    else
    {
        return [self.scanResultsArray count];
    }
    return rowCount;
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
    UIView *headerView=nil;
    if (section==0)
    {
        headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 15)];
         [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        UILabel *title=[[UILabel alloc] init];
        [title setFrame:CGRectMake(15, 8, 100, 12)];
        [title setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        title.textColor=[UIColor lightGrayColor];
        title.text=@"Scan Filter";
        [title setFont:[UIFont boldSystemFontOfSize:13]];
        
        [headerView addSubview:title];
    }
    else if(section==1)
    {
        headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0,tableView.bounds.size.width, 42)];//40
        [headerView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [headerView addSubview:self.scanningView];
        [headerView addSubview:self.searchingTipsTitle];
        
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cellView=nil;
    static NSString *cellIdentifier=nil;
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            cellIdentifier=@"broadcastTypeCell";
            cellView =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            cellView.detailTextLabel.text=[NSString stringWithFormat:@"%@",self.filterRssi];//self.currentScanFilter.broadcastType;
        }
        else
        {
            cellIdentifier=@"deviceTypeCell";
            cellView =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        }
    }
    
    if(indexPath.section==1)
    {
        cellIdentifier=@"ScanResultsTableViewCell";
        ScanResultsTableViewCell *cellItem=(ScanResultsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"ScanResultsCell" owner:self options:nil];
        cellItem=[nib objectAtIndex:0];
        
        //get the item object
        LSDeviceInfo *lsDevice=[self.scanResultsArray objectAtIndex:indexPath.row];
        
        //set the item content
        NSString *deviceType=[NSString stringWithFormat:@"%@",@(lsDevice.deviceType)];
        cellItem.protocolLabel.text=lsDevice.protocolType;
        cellItem.deviceImage.image=[DataFormatConverter getDeviceImageViewWithType:[DataFormatConverter stringToDeviceType:deviceType]];
        cellItem.serviceLabel.text=[NSString stringWithFormat:@"Service:%@",lsDevice.serviceStringValue];
        cellItem.accessoryType=UITableViewCellAccessoryNone;
        
        NSString *deviceName=[NSString stringWithFormat:@"%@:%@",lsDevice.deviceName,lsDevice.broadcastId];
        if(lsDevice.preparePair || (lsDevice.broadcastId.length && lsDevice.deviceName.length  && [lsDevice.deviceName hasSuffix:lsDevice.broadcastId]))
        {
            deviceName=lsDevice.deviceName;
        }
        if(lsDevice.macAddress.length)
        {
            deviceName=lsDevice.deviceName;
        }
        if(!deviceName.length)
        {
            deviceName=@"undefine";
        }
        cellItem.deviceLabel.text=deviceName;
        if(lsDevice.macAddress.length)
        {
            cellItem.protocolLabel.text=[NSString stringWithFormat:@"Address:%@",lsDevice.macAddress];
        }
        else
        {
            cellItem.protocolLabel.text=[NSString stringWithFormat:@"Address:nil"];
        }
        if(lsDevice.isInSystem && !lsDevice.services.count)
        {
            cellItem.serviceLabel.text=[NSString stringWithFormat:@"Service:paired in system"];
        }
        
        if(lsDevice.broadcastId.length)
        {
            [self.indexPathMap setValue:indexPath forKey:lsDevice.broadcastId];
        }
        cellView = cellItem;
    }
     return cellView;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==1)
    {
        if([self.scanResultsArray count]>0)
        {
            LSDeviceInfo *lsDevice=[self.scanResultsArray objectAtIndex:indexPath.row];
            ScanResultsTableViewCell *scanRersultsCell=(ScanResultsTableViewCell *)cell;
            if(lsDevice.preparePair)
            {
                scanRersultsCell.deviceLabel.textColor=[UIColor redColor];
                scanRersultsCell.statusLabel.text=@"pairing";
                scanRersultsCell.statusLabel.textColor=[UIColor redColor];
            }
            else
            {
                if(lsDevice.rssi)
                {
                    scanRersultsCell.statusLabel.text=[NSString stringWithFormat:@"%@",lsDevice.rssi];
                }
                else
                {
                    scanRersultsCell.statusLabel.text=@"";
                }
            }
            if(lsDevice.isInSystem)
            {
                scanRersultsCell.statusLabel.text=@"";
                UIColor *textColor=[DataFormatConverter colorWithHexString:@"8B4726"];
                scanRersultsCell.deviceLabel.textColor=textColor;
                scanRersultsCell.serviceLabel.textColor=textColor;
                scanRersultsCell.protocolLabel.textColor=textColor;
            }
        }
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0 && indexPath.row==0)
    {
//        [self showBroadcastTypeSettingView];
        [self showRssiFilter];
    }
    else if(indexPath.section==1)
    {
        self.currentDevice=[self.scanResultsArray objectAtIndex:indexPath.row];
        if(self.currentDevice.preparePair
           || (!self.currentDevice.isRegistered && [@"A6" isEqualToString:self.currentDevice.protocolType]))
        {
            [self stopSearching];
            self.currentWorkingStatus=WorkingStatusPairDevice;
            //设置绑定用户时指定的用户编号及用户信息
            LSScaleUserInfo *userInfo=[[LSScaleUserInfo alloc] init];
            userInfo.gender=LSUserGenderMale;
            userInfo.height=170; //单位CM
            userInfo.weight=40;
            userInfo.age=33;
            userInfo.userNumber=1;
            self.currentDevice.userInfo=userInfo;
            [self pairingDevice:self.currentDevice];
        }
        else
        {
            [self stopSearching];
            if([DataFormatConverter isNotRequiredPairDevice:self.currentDevice.protocolType])
            {
                self.currentWorkingStatus=WorkingStatusSaveDevice;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *userId=self.currentDeviceUser.userID;
                    [BleDevice bindDeviceWithUserId:userId
                                         deviceInfo:self.currentDevice
                             inManagedObjectContext:self.databaseManager.managedContext];
                });
            }
            NSString *msg=[DataFormatConverter parseObjectDetailInStringValue:self.currentDevice];
            [AlertViewUtils showConfirmAlertView:title_device_info
                                         message:msg
                                      controller:self
                                         handler:^(UIAlertAction * _Nullable action) {
                [self performSegueWithIdentifier:@"SearchResultsIdentifier" sender:self];
            }];
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SearchResultsIdentifier"])
    {
        if([segue.destinationViewController isKindOfClass:[DeviceViewController class]])
        {
            [self.lsBleManager stopSearch];
            
            NSIndexPath * indexPath=[self.tableView indexPathForSelectedRow];
            DeviceViewController *showInfoVC=( DeviceViewController *)segue.destinationViewController;
            showInfoVC.currentDevice=[self.scanResultsArray objectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - LSDevicePairing Delegate

-(void)bleDevice:(LSDeviceInfo *)lsDevice didProductUserlistUpdate:(NSDictionary *)userlist
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissIndicatorView:^{
            [self showDeviceUsers:userlist];
        }];
    });
}

-(void)bleDevice:(LSDeviceInfo *)lsDevice didPairingStatusChange:(LSDevicePairedResults)pairingStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissIndicatorView:^{
            if(lsDevice && pairingStatus==LSDevicePairedResultsSuccess)
            {
                NSString *userId=self.currentDeviceUser.userID;
                [BleDevice bindDeviceWithUserId:userId
                                     deviceInfo:lsDevice
                         inManagedObjectContext:self.databaseManager.managedContext];
                NSString *msg=[DataFormatConverter parseObjectDetailInStringValue:lsDevice];
                [AlertViewUtils showConfirmAlertView:title_pair_success
                                             message:msg
                                          controller:self
                                             handler:^(UIAlertAction * _Nullable action) {
                 [self performSegueWithIdentifier:@"SearchResultsIdentifier" sender:self];
            }];}
            else
            {
                [AlertViewUtils showConfirmAlertView:title_pair_failed
                                             message:msg_pair_failed
                                          controller:self
                                             handler:nil];
            }
        }];
    });
}

-(void)bleDevice:(LSDeviceInfo *)lsDevice didOperationCommandUpdate:(LSDeviceOperationCmdInfo *)cmdInfo
{
    if(DOperationCmdInputDeviceId == cmdInfo.operationCmd){
        //set device'id for test
        NSString *deviceID=@"ff028a0003e2";
        [self.lsBleManager inputOperationCmd:cmdInfo.operationCmd replyObj:deviceID forDevice:lsDevice.broadcastId];
    }
}

#pragma mark - LSBluetoothStatusDelegate

-(void)systemDidBluetoothStatusChange:(CBManagerState)bleState
{
    NSLog(@"sky-test on bluetooth status change >> %@",@(bleState));
    if(CBManagerStatePoweredOn!=bleState){
        [self stopSearching];
    }
}


@end
