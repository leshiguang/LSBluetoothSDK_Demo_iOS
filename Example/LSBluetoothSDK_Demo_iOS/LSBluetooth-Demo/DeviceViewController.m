//
//  DeviceViewController.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/7/16.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "DeviceViewController.h"
#import "DataFormatConverter.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>

#import "DeviceUser.h"
#import "ScanFilter.h"
#import "LSDatabaseManager.h"
#import "DeviceUser+Handler.h"
#import "BleDevice+Handler.h"
#import "PedometerSettingTVC.h"
#import "UpgradeFileItem.h"
#import "CustomTableView.h"
#import "LSSettinItemDelegate.h"

#define fun_connect                 @"Connect"
#define fun_disconnect              @"Disconnect"
#define fun_upgrade                 @"Firmware Upgrade"
#define fun_binding                 @"Device Binding"
#define fun_setting                 @"Other Setting"
#define fun_read_battery            @"Read Battery"
#define fun_push_user_info          @"Push User Info"
#define fun_scan_wifi               @"Scan Wifi"
#define fun_connent_wifi            @"connect wifi"
#define fun_reconnect_wifi          @"rest connect wifi"
#define fun_wifi_state              @"wifi state"


#define msg_connect_failed          @"Connect Failed"
#define msg_bind_failed             @"Binding Failed"
#define msg_bind_success            @"Binding Success"
#define msg_upgrade_failed          @"Upgrade Failed"
#define msg_upgrade_success         @"Upgrade Success"

#define prompt_bluetooth_disable    @"Bluetooth is not available."
#define prompt_bind_failed          @"please try again."
#define prompt_binding              @"binding,please wait...\n\n"
#define prompt_upgrading            @"upgrading,please wait...\n\n"
#define prompt_unsupport_bind       @"unsupported,no scan results."
#define prompt_input_number         @"input random number"
#define prompt_input_error          @"random code error,please re-enter"
#define file_not_found              @"file not found"
#define gps_unavailable             @"Gps Unavailable"
#define gps_positioning_failure     @"Positioning Failure"
#define gps_positioning_success     @"Positioning Success"
#define gps_refuse                  @"Refuse"
#define prompt_sync_setting         @"syncing setting"
#define prompt_device_unknown       @"Device is not certified."




@interface DeviceViewController ()<LSDeviceDataDelegate,LSDeviceUpgradingDelegate,
LSBluetoothStatusDelegate,LSDevicePairingDelegate,UIAlertViewDelegate,LSSettingItemDelegate,LSDebugMessageDelegate>

@property (nonatomic, strong)  LSBluetoothManager *lsBleManager;
@property (nonatomic, strong)  LSProductUserInfo *productUserInfo;
@property (nonatomic, strong)  LSDatabaseManager *databaseManager;
@property (nonatomic, strong)  DeviceUser *currentDeviceUser;
@property (nonatomic, strong)  NSString *upgradeFile;
@property (nonatomic, assign)  NSTimeInterval upgradingStartTime;
@property (nonatomic, assign)  NSUInteger dataCount;
@property (nonatomic, strong)  UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign)  float osVersion;
@property (nonatomic, strong)  UIProgressView *progressBarView;
@property (nonatomic, strong)  UILabel *progressLabel;
@property (nonatomic, strong)  CATransition *animation;
@property (nonatomic, strong)  UIAlertController *alertController;
@property (nonatomic, strong)  LSWeightData *scaleData;

@property (nonatomic, strong) LSScaleWifiModel *wifiModel;
@end

static NSString *spaceString=@"\n -----------------------";

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toastView.hidden=YES;
    self.toastMessageLabel.hidden=YES;
    self.nameLabel.text=[NSString stringWithFormat:@"%@ [%@]",self.currentDevice.deviceName,self.currentDevice.broadcastId];
    // Do any additional setup after loading the view.
       NSLog(@"deviceConnectedState:%@,key:%@",@([self.lsBleManager checkDeviceConnectState:self.currentDevice.broadcastId]),self.currentDevice.broadcastId);
    [self connectDevice];
    [[LSBluetoothManager defaultManager] setDebugMessageDelegate:self permission:@"syncing"];
    [[LSBluetoothManager defaultManager] setDebugMessageDelegate:self permission:@"all"];
    //update gps state
    [self.lsBleManager updatePhoneGpsState:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated
{
    if([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        self.measureDatas=nil;
        //stop data sync service
        [self.lsBleManager stopDataReceiveService];
    }
    [super viewWillDisappear:animated];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - View Methods

- (void)appendOutputText:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.osVersion > 10.0){
            [self.dataTextView insertText:@"  "];
            [self.dataTextView insertText:text];
            [self.dataTextView insertText:@"\n"];
        }
        else{
            self.dataTextView.text=[self.dataTextView.text stringByAppendingString:@"  "];
            self.dataTextView.text=[self.dataTextView.text stringByAppendingString:text];
            self.dataTextView.text=[self.dataTextView.text stringByAppendingString:@"\n"];
        }
    });
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

-(UILabel *)progressLabel
{
    if(!_progressLabel){
        _progressLabel=[[UILabel alloc] initWithFrame:CGRectMake(105, 49, 60, 20)];
        _progressLabel.textAlignment=NSTextAlignmentCenter;
        _progressLabel.textColor=[UIColor blueColor];
        _progressLabel.font=[UIFont systemFontOfSize:13];
        _progressLabel.text=@"---";
    }
    return _progressLabel;
}

-(UIProgressView *)progressBarView
{
    if(!_progressBarView){
        _progressBarView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressBarView.progress=0;
        _progressBarView.frame = CGRectMake(20,80,220,10);//CGRect(x: 10, y: 70, width: 250, height: 0);
    }
    return  _progressBarView;
}

-(UIAlertController *)alertController
{
    if(!_alertController){
        _alertController = [UIAlertController alertControllerWithTitle:@"ScaleData"
                                                               message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
        [_alertController.view addSubview:self.indicatorView];
        NSDictionary * views = @{@"pending" : _alertController.view, @"indicator" : self.indicatorView};
        NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
        NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
        NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
        [_alertController.view addConstraints:constraints];
    }
    return _alertController;
}

-(float)osVersion{
    if(_osVersion <=0){
        NSString *ver = [[UIDevice currentDevice] systemVersion];
        _osVersion= [ver floatValue];
    }
    return _osVersion;
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

-(void)updateDeviceConnectState:(LSDeviceConnectState)connectState
{
    if(LSDeviceStateConnectSuccess == connectState)
    {
        self.statusLabel.text=@"connected";
        self.statusLabel.textColor=[[UIColor alloc] initWithRed:0 green:100/255.0f blue:0 alpha:1];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
    else if (LSDeviceStateConnecting == connectState)
    {
        self.statusLabel.text=@"connecting";
        self.statusLabel.textColor=[UIColor darkGrayColor];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
    else if (LSDeviceStateConnectFailure == connectState)
    {
        self.statusLabel.text=@"connect failure";
        self.statusLabel.textColor=[UIColor brownColor];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
    else if(LSDeviceStateDisconnect == connectState)
    {
        self.statusLabel.text=@"disconnect";
        self.statusLabel.textColor=[UIColor redColor];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
    else if (LSDeviceStateConnectionTimedout == connectState)
    {
        self.statusLabel.text=@"connection timeout";
        self.statusLabel.textColor=[UIColor blueColor];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
    else
    {
        self.statusLabel.text=@"unkown";
        self.statusLabel.textColor=[UIColor grayColor];
        [self setTextAnimation:self.statusLabel key:self.statusLabel.text];
    }
}

-(void)updateRealtimeData:(LSWeightData *)weightData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *value=[DataFormatConverter doubleValueWithOneDecimalFormat:weightData.weight];
        NSString *msg=[NSString stringWithFormat:@"ScaleData:%@",value];
        if(self.scaleData.isRealtimeData){
            self.alertController.title=msg;
        }
        else{
            self.scaleData=weightData;
            [self showProgressingView:msg handler:nil];
        }
    });
}

-(void)updateNewDataPrompt
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.dataCount>0){
            self.newsLabel.hidden=NO;
            self.newsLabel.text=[NSString stringWithFormat:@"%@ News",@(self.dataCount)];
            [self setTextAnimation:self.newsLabel key:self.newsLabel.text];
        }
    });
}

-(void)hideProcessingView
{
    [self.processingView stopAnimating];
    self.processingView.hidden=YES;
}

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

-(void)showProgressingView:(NSString *)msg
                   handler:(void (^ __nullable)(void))completion
{
    [self.indicatorView startAnimating];
    [self presentViewController:self.alertController animated:YES completion:completion];
}

-(void)showInputView:(NSString *)msg
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: nil
                                                                    message: msg
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"random number";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alert.textFields;
        UITextField *textField = textfields[0];
        NSString *randomNumber=textField.text;
        NSLog(@"my input random number:%@",randomNumber);
        NSInteger results=[self.lsBleManager inputOperationCmd:DOperationCmdInputRandomCode
                                                      replyObj:randomNumber
                                                     forDevice:self.currentDevice.broadcastId];
        
        if(ECodeRandomCodeVerifyFailure == results){
            //提示重新输入
            [self showInputView:prompt_input_error];
        }
        else{
            [self showIndicatorView:prompt_binding handler:nil];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showAlertView:(NSString *)title
             message:(NSString *)msg
           cancelBtn:(BOOL)enable
             handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:handler];
    if(enable){
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [alert addAction:cancel];
    }
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showProgressView:(NSString *)msg handler:(void (^ __nullable)(void))completion
{
    UIAlertController *pending = [UIAlertController alertControllerWithTitle:nil
                                                                     message:msg
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [pending.view addSubview:self.progressLabel];
    [pending.view addSubview:self.progressBarView];
    //add action
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       [self cancelFirmwareUpgrade];
                                                     }];
    [pending addAction:cancel];
    [self presentViewController:pending animated:YES completion:completion];
}

-(void)dismissIndicatorView:(void (^ __nullable)(void))handler
{
    if(self.indicatorView.isAnimating){
        [self.indicatorView stopAnimating];
    }
    [self dismissViewControllerAnimated:YES completion:handler];
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

-(void)showData
{
    if(self.measureDatas.count){
        self.dataCount=self.measureDatas.count;
        [self.processingView stopAnimating];
        self.processingView.hidden=YES;
        self.newsLabel.text=[NSString stringWithFormat:@"%@ News",@(self.dataCount)];
        [self setTextAnimation:self.newsLabel key:self.newsLabel.text];
    }
    for(NSArray *array in self.measureDatas){
        [self appendOutputText:spaceString];
        for(NSString *value in array){
            [self appendOutputText:value];
        }
    }
}

#pragma mark - Navigation Methods

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pedometerSettingMenu"])
    {
        if([segue.destinationViewController isKindOfClass:[PedometerSettingTVC class]])
        {
            PedometerSettingTVC *view=( PedometerSettingTVC *)segue.destinationViewController;
            view.activeDevice=self.currentDevice;
        }
    }
    
}

//if NO,disable perform segue
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    [self showMenu:nil];
    return NO;
}

-(BOOL)isSupportBatteryReading
{
    if(self.currentDevice.deviceType==LSDeviceTypePedometer){
        if([self.currentDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame){
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        return NO;
    }
}

-(BOOL)isSupportDeviceBinding
{
    if(self.currentDevice.deviceType==LSDeviceTypePedometer){
        if([self.currentDevice.protocolType caseInsensitiveCompare:@"A5"]==NSOrderedSame){
            return YES;
        }
        else{
            return NO;
        }
    }
    else if([self.currentDevice.protocolType caseInsensitiveCompare:@"A6"]==NSOrderedSame){
        return YES;
    }
    else{
        return NO;
    }
}

-(BOOL)isSupportFirmwareUpgrading
{
    if(self.currentDevice.deviceType==LSDeviceTypePedometer){
        if([self.currentDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame){
            return NO;
        }
        else{
            return YES;
        }
    }
    else if([self.currentDevice.protocolType caseInsensitiveCompare:@"A6"]==NSOrderedSame){
        return YES;
    }
    else{
        return NO;
    }
}

-(BOOL)isSupportOtherSetting
{
    if(self.currentDevice.deviceType==LSDeviceTypePedometer){
        if([self.currentDevice.protocolType caseInsensitiveCompare:@"A2"]==NSOrderedSame){
            return NO;
        }
        else{
            return YES;
        }
    }
    else{
        return NO;
    }
}

-(void)showGpsStatusSelectMenu:(LSDeviceData *)packet
{
    LSSportNotify *sportNotify=(LSSportNotify *)packet.dataObj;
    if(sportNotify.type != 0x01){
        return ;
    }
    UIAlertController *actionSheet=[UIAlertController alertControllerWithTitle:@"Device Function Menu"
                                                                       message:nil
                                    
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:gps_unavailable
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      // Distructive button tapped.
                                                      [self dismissViewControllerAnimated:YES completion:^{}];
                                                      [self updatePhoneGpsState:LSGpsStateUnavailable sportNotiy:sportNotify];
                                                      
                                                  }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:gps_positioning_failure
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      // Distructive button tapped.
                                                      [self dismissViewControllerAnimated:YES completion:^{}];
                                                      [self updatePhoneGpsState:LSGpsStatePositioningFailure sportNotiy:sportNotify];
                                                  }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:gps_positioning_success
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      //read battery
                                                      [self dismissViewControllerAnimated:YES completion:^{ }];
                                                      [self updatePhoneGpsState:LSGpsStatePositioningSuccess sportNotiy:sportNotify];
                                                  }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:gps_refuse
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
                                                      //device binding
                                                      [self dismissViewControllerAnimated:YES completion:^{ }];
                                                      [self updatePhoneGpsState:LSGpsStateRefuse sportNotiy:sportNotify];
                                                  }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)showMenu:(id)sender
{
    UIAlertController *actionSheet=[UIAlertController alertControllerWithTitle:@"Device Function Menu"
                                                                         message:nil
                                      
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{}];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:fun_connect
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{}];
        //connect device
        [self connectDevice];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:fun_disconnect
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{}];
        //disconnect
        [self disconnectDevice];
    }]];
    if([self isSupportBatteryReading]){
    [actionSheet addAction:[UIAlertAction actionWithTitle:fun_read_battery
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
        //read battery
        [self dismissViewControllerAnimated:YES completion:^{ }];
        [self.lsBleManager readDeviceVoltage:self.currentDevice.broadcastId];
                                                  }]];
    }
    if([self isSupportDeviceBinding]){
    [actionSheet addAction:[UIAlertAction actionWithTitle:fun_binding
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
         //device binding
         [self dismissViewControllerAnimated:YES completion:^{ }];
         [self bindDevice];
                                                  }]];
    }
    if([self isSupportFirmwareUpgrading]){
    [actionSheet addAction:[UIAlertAction actionWithTitle:fun_upgrade
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *action) {
        //firmware upgade
        [self dismissViewControllerAnimated:YES completion:^{}];
        [self showUpgradeFile];
      }]];
     }

    if([self.currentDevice.protocolType isEqualToString:@"A6"]){
        [actionSheet addAction:[UIAlertAction actionWithTitle:fun_push_user_info style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self showIndicatorView:prompt_sync_setting handler:^{
                [self updateScaleUserInfo];
            }];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:fun_scan_wifi style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self sacaleScanWifi];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:fun_connent_wifi style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self connectWifi];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:fun_reconnect_wifi style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self reconnectWifi];
        }]];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:fun_wifi_state style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self wifiState];
        }]];
    }
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}


-(void)showUpgradeFile
{
    NSMutableArray *arrays=[NSMutableArray arrayWithCapacity:10];
    NSArray <UpgradeFileItem *>* fileItems=[UpgradeFileItem localUpgradeFiles:self.currentDevice.modelNumber];
    if(!fileItems.count){
        [self showAlertView:msg_upgrade_failed message:file_not_found cancelBtn:NO handler:nil];
        return ;
    }
    for(UpgradeFileItem *fileItem in fileItems){
        LSDeviceSettingItem *item=[[LSDeviceSettingItem alloc] initWithCategory:DSCategoryCustomPages];
        item.itemType=LSSettingItemFile;
        item.title=fileItem.firmwareVersion;
        item.itemValue=fileItem.fileName;
        item.filePath=fileItem.filePath;
        NSLog(@"target upgrade file:%@",fileItem.filePath);
        [arrays addObject:item];
    }
    CustomTableView *tableView=[[CustomTableView alloc] initWithFrame:CGRectMake(0, 0, 280, 300)
                                                           dataSource:arrays
                                                             delegate:self];
    
    UIViewController *controller = [[UIViewController alloc]init];
    CGRect rect = CGRectMake(0, 0, 272, 300);
    [controller setPreferredContentSize:rect.size];
    [controller.view addSubview:tableView];
    [controller.view bringSubviewToFront:tableView];
    [controller.view setUserInteractionEnabled:YES];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title_select_upgrade_file
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController setValue:controller forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDestructive handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark - SDK Sample Code

-(LSBluetoothManager *)lsBleManager
{
    if(!_lsBleManager){
        _lsBleManager=[LSBluetoothManager defaultManager];
    }
    return _lsBleManager;
}


-(BOOL)isDataSyncing
{
    return ([LSBluetoothManager defaultManager].managerStatus == ManagerStatusSyncing);
}


-(BOOL)isConnected
{
    LSDeviceConnectState state=[self.lsBleManager checkDeviceConnectState:self.currentDevice.broadcastId];
    if(state == LSDeviceStateConnectSuccess){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)addDevices
{
    //clear
    //set delay disconnect for A3 BPM OR Scale
    self.currentDevice.delayDisconnect=YES;
    //add new one
    __weak DeviceViewController *weakSelf=self;
     self.currentDevice.macAddress=self.currentDevice.broadcastId;
    
//    com.leshiguang.saas.rbac.demo.appid
//    88d01e7cb606c28eb35f9667df309aeb57ccf54b
    [self.lsBleManager addMeasureDevice:@"88d01e7cb606c28eb35f9667df309aeb57ccf54b" andDevice:self.currentDevice
                                 result:^(NSUInteger result) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if(result == 200){
                //设备认证成功
                //start data syncing
                BOOL isSuccess=[weakSelf.lsBleManager startDataReceiveService:weakSelf];
                if(!isSuccess && !weakSelf.lsBleManager.isBluetoothPowerOn){
                    weakSelf.processingView.hidden=YES;
                    [weakSelf showAlertView:msg_connect_failed message:prompt_bluetooth_disable cancelBtn:NO handler:nil];
                }
                else{
                    weakSelf.processingView.hidden=NO;
                    if(!weakSelf.processingView.isAnimating){
                        [weakSelf.processingView startAnimating];
                    }
                   [weakSelf updateDeviceConnectState:LSDeviceStateConnecting];
                }
            }
            else{
                [weakSelf showAlertView:msg_connect_failed message:prompt_device_unknown cancelBtn:NO handler:nil];
            }
        });
    }];
}

-(void)connectDevice
{
    //check working status of sdk
    LSBManagerStatus workingStatus=self.lsBleManager.managerStatus;
    if(ManagerStatusPairing == workingStatus){
        //cancel pairing process
        [self.lsBleManager cancelDevicePairing:self.currentDevice];
    }
    else if (ManagerStatusScaning == workingStatus){
        //cancel scaning process
        [self.lsBleManager stopSearch];
    }
    else if(ManagerStatusUpgrading == workingStatus){
        //cancel upgrading process
        [self.lsBleManager cancelDeviceUpgrading:self.currentDevice.broadcastId];
    }
    else if (ManagerStatusSyncing == workingStatus){
        if([self isConnected]){
            self.lsBleManager.deviceDataDelegate=self;
            //update connect status
            [self updateDeviceConnectState:LSDeviceStateConnectSuccess];
            //展示测量数据
            [self showData];
        }else{
            self.newsLabel.hidden=YES;
            self.processingView.hidden=NO;
            if(!self.processingView.isAnimating){
                [self.processingView startAnimating];
            }
            //stop
            [self.lsBleManager stopDataReceiveService];
            //restart
            [self connectDevice];
        }
        return ;
    }
    else{
        self.processingView.hidden=NO;
        self.newsLabel.hidden=YES;
        //add device
        [self addDevices];
    }
}

-(void)disconnectDevice
{
  [self.lsBleManager stopDataReceiveService];
}

-(void)bindDevice
{
    if(!self.currentDevice.peripheralIdentifier){
        [self showAlertView:msg_bind_failed message:prompt_unsupport_bind cancelBtn:NO handler:nil];
        return ;
    }
    BOOL delay=NO;
    //check working status of sdk
    LSBManagerStatus workingStatus=self.lsBleManager.managerStatus;
    if(ManagerStatusPairing == workingStatus){
        //cancel pairing process
        return ;
    }
    else if (ManagerStatusScaning == workingStatus){
        //cancel scaning process
        [self.lsBleManager stopSearch];
    }
    else if(ManagerStatusUpgrading == workingStatus){
        delay=YES;
        //cancel upgrading process
        [self.lsBleManager cancelDeviceUpgrading:self.currentDevice.broadcastId];
    }
    else if (ManagerStatusSyncing == workingStatus){
        delay=YES;
        [self disconnectDevice];
    }
    //calling interface
    [self showIndicatorView:prompt_binding handler:^{
        double delayInSeconds = delay ? 3.0:0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.lsBleManager pairingWithDevice:self.currentDevice delegate:self];
        });
    }];
}

-(void)cancelFirmwareUpgrade
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //cancel firmware upgrade
    [self.lsBleManager cancelDeviceUpgrading:self.currentDevice.broadcastId];
}

-(void)upgradeFirmware:(NSString *)filePath
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showIndicatorView:prompt_upgrading handler:^{
        BOOL delay=NO;
        //firmware upgrade
        if(ManagerStatusPairing == self.lsBleManager.managerStatus){
            [self.lsBleManager cancelDevicePairing:self.currentDevice];
            delay=YES;
        }
        else if(ManagerStatusSyncing == self.lsBleManager.managerStatus){
            [self.lsBleManager stopDataReceiveService];
            delay=YES;
        }
        else if(ManagerStatusScaning == self.lsBleManager.managerStatus){
            [self.lsBleManager stopSearch];
            delay=YES;
        }
        else if(ManagerStatusUpgrading == self.lsBleManager.managerStatus)
        {
            return ;
        }
        double delayInSeconds = delay ? 3.0:0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.upgradingStartTime =[[NSDate date] timeIntervalSince1970];
            NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
            [self.lsBleManager upgradingWithDevice:self.currentDevice file:fileUrl delegate:self];
        });
    }];
}

-(void)updatePhoneGpsState:(LSGpsState)gpsState
                sportNotiy:(LSSportNotify *)notify
{
    //response
    LSSportNotifyConfirm *sportConfirm=[[LSSportNotifyConfirm alloc] init];
    sportConfirm.gpsState=gpsState;
    [self.lsBleManager pushDeviceMessage:sportConfirm
                               forDevice:self.currentDevice.broadcastId
                                andBlock:^(BOOL isSuccess, NSUInteger errorCode)
    {
        NSString *msg=[NSString stringWithFormat:@"update gps state is success ? %@,errorCode=%@",@(isSuccess),@(errorCode)];
        [self appendOutputText:msg];
    }];
}


-(BOOL)isAerobicExercise:(LSDeviceSportMode)sportMode
{
    if(LSSportModeAerobicSport12 == sportMode
       || LSSportModeAerobicSport == sportMode
       || LSSportModeAerobicSport6 == sportMode){
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)findUpgradeFile
{
    if(!self.currentDevice.firmwareVersion.length || !self.currentDevice.modelNumber.length)
    {
        return nil;
    }
    if([self.currentDevice.modelNumber hasPrefix:@"417"])
    {
        //mambo 2
        return  [[NSBundle mainBundle] pathForResource:@"417BEH140T063000A01D110_a7daa9a0"
                                                ofType:@"lsf"];
    }
   else if ([self.currentDevice.modelNumber hasPrefix:@"418"])
    {
            //ziva
            return  [[NSBundle mainBundle] pathForResource:@"418BRH140T064000A01D110_e5939d88"
                                                    ofType:@"lsf"];
    }
    else if ([self.currentDevice.modelNumber hasPrefix:@"415"])
    {
        //mambo watch
        return  [[NSBundle mainBundle] pathForResource:@"415B7H240T007004A01D710_c6c994eb"
                                                ofType:@"lsf"];
    }
    else if ([self.currentDevice.modelNumber hasPrefix:@"422"]||[self.currentDevice.modelNumber hasPrefix:@"426B"])
    {
        //mambo watch
        return  [[NSBundle mainBundle] pathForResource:@"422B0H044T029000A01D110_db3fc0ce"
                                                ofType:@"lsf"];
    }
    else if ([self.currentDevice.modelNumber hasPrefix:@"LS-405"])
    {
        //mambo watch
        return  [[NSBundle mainBundle] pathForResource:@"ls405_B2_A045_20151009"
                                                ofType:@"hex"];
    }
    else if([self.currentDevice.deviceName hasPrefix:@"gG-RPM 0022"])
    {
        return [[NSBundle mainBundle] pathForResource:@"GBF-1719-B_A06_H09_CRC_7315_20200217" ofType:@"bin"];
    }
    else
    {
        return nil;
    }
}

/**
 * 在数据同步过程中更新用户信息
 */
-(void)updateScaleUserInfo
{
    LSScaleUserInfo *userInfo=[[LSScaleUserInfo alloc] init];
    userInfo.gender=LSUserGenderMale;
    userInfo.height=170; //单位CM
    userInfo.weight=30.4;
    userInfo.age=33;
    userInfo.userNumber=4;
    [self.lsBleManager pushDeviceMessage:userInfo
                               forDevice:self.currentDevice.broadcastId
                                andBlock:^(BOOL isSuccess, NSUInteger errorCode)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSuccess){
                [self dismissIndicatorView:nil];
                //更新成功
                [self appendOutputText:spaceString];
                NSString *msg=[NSString stringWithFormat:@"#success >> test user info "];
                [self appendOutputText:msg];
                [self appendOutputText:userInfo.description];
            }
            else{
                [self dismissIndicatorView:nil];
                //更新失败
                [self appendOutputText:spaceString];
                NSString *msg=[NSString stringWithFormat:@"#failed to update user info,code:%@",@(errorCode)];
                [self appendOutputText:msg];
            }
        });
      
    }];
}

- (void)sacaleScanWifi {
    [self.lsBleManager scanScalesWifi:self.currentDevice.broadcastId andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSuccess){
                [self dismissIndicatorView:nil];
                //更新成功
                [self appendOutputText:spaceString];
                NSString *msg=[NSString stringWithFormat:@"#success >> test scan wifi "];
                [self appendOutputText:msg];
//                [self appendOutputText:userInfo.description];
            }
            else{
                [self dismissIndicatorView:nil];
                //更新失败
                [self appendOutputText:spaceString];
                NSString *msg=[NSString stringWithFormat:@"#failed to scan wifi,code:%@",@(errorCode)];
                [self appendOutputText:msg];
            }
        });
    }];
}

- (void)connectWifi {
    for (LSScaleWifiModelItem *model in self.wifiModel.wifiModelAry) {
        if ([model.ssidName isEqualToString:@"lifesense_2.4G"]) {
            [[LSBluetoothManager defaultManager] connectWifi:self.currentDevice.broadcastId bssid:model.bssid password:@"life8511" andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
                [self dismissIndicatorView:nil];
            }];
        } else {
            [self dismissIndicatorView:nil];
        }
    }
}

- (void)reconnectWifi {
    [[LSBluetoothManager defaultManager] restConnectRequest:self.currentDevice.broadcastId andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
        [self dismissIndicatorView:nil];
    }];
}

- (void)wifiState {
    [[LSBluetoothManager defaultManager] wifiStatusRequest:self.currentDevice.broadcastId andBlock:^(BOOL isSuccess, NSUInteger errorCode) {
        [self dismissIndicatorView:nil];
    }];
}

#pragma mark - LSDeviceDataDelegate
//device connection state change
-(void)bleDevice:(LSDeviceInfo *)device didConnectStateChange:(LSDeviceConnectState)connectState
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateDeviceConnectState:connectState];
        if(LSDeviceStateConnectSuccess == connectState)
        {
            self.dataCount=0;
            [self.processingView stopAnimating];
            self.processingView.hidden=YES;
            self.newsLabel.text=@"";
        }
        else
        {
            self.newsLabel.hidden=YES;
            self.processingView.hidden=NO;
            if(!self.processingView.isAnimating && [self isDataSyncing])
            {
                [self.processingView startAnimating];
            }
        }
    });
}

//device information update
-(void)bleDeviceDidInformationUpdate:(LSDeviceInfo *)device
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendOutputText:spaceString];
        [self appendOutputText:@"#Device Information"];
        if(device.deviceSn.length && device.deviceId.length){
            [self appendOutputText:[NSString stringWithFormat:@"deviceSn:%@",device.deviceSn]];
            [self appendOutputText:[NSString stringWithFormat:@"deviceId:%@",device.deviceId]];
        }
        [self appendOutputText:[NSString stringWithFormat:@"firmwareVersion: %@",device.firmwareVersion]];
        [self appendOutputText:[NSString stringWithFormat:@"hardwareVersion: %@",device.hardwareVersion]];
        [self appendOutputText:[NSString stringWithFormat:@"modelNumber: %@",device.modelNumber]];
        [self appendOutputText:[NSString stringWithFormat:@"timezone: %@",device.timezone]];
        [self appendOutputText:[NSString stringWithFormat:@"protocolType: %@",device.protocolType]];
        //update device firmware version
        NSString *userId=self.currentDeviceUser.userID;
        [BleDevice bindDeviceWithUserId:userId
                             deviceInfo:device
                 inManagedObjectContext:self.databaseManager.managedContext];
    });
}

//product user info update
-(void)bleDevice:(LSDeviceInfo *)device didProductUserInfoUpdate:(LSProductUserInfo *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendOutputText:spaceString];
        self.productUserInfo=userInfo;
        [self appendOutputText:@"#Product User Info"];
        NSString *str=[DataFormatConverter parseObjectDetailInStringValue:userInfo];
        [self appendOutputText:str];
    });
}

//weight  scale measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeight:(LSWeightData *)weightData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        if(weightData.isRealtimeData){
            [self updateRealtimeData:weightData];
            return;
        }
        self.scaleData=nil;
        [self dismissIndicatorView:nil];
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:weightData];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
        float bmi=(weightData.weight/self.productUserInfo.height)/self.productUserInfo.height;
        [self appendOutputText:[NSString stringWithFormat:@"BMI:%@",@(bmi)]];
        //for test
        LSProductUserInfo *userInfo=[[LSProductUserInfo alloc] init];
        double resistance=667.0;
        userInfo.height=1.75;
        userInfo.weight=67.8;
        userInfo.age=34;
        userInfo.gender=LSUserGenderMale;
        userInfo.isAthlete=YES;
        //calculate body composition data
        LSWeightAppendData * bodyCompositionData=[[LSBluetoothManager defaultManager] calculateBodyCompositionData:resistance userInfo:userInfo];
        NSLog(@"body composition data %@",[DataFormatConverter parseObjectDetailInDictionary:bodyCompositionData]);
    });
}

//fat scale measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWeightAppend:(LSWeightAppendData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
    });
}

- (void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForWifi:(LSScaleWifiModel *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.wifiModel = data;
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
        
    });
}

- (void)bleDevice:(LSDeviceInfo *)device didConnectWifiResult:(LSScaleConnectWifiResult *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
        
    });
}

//blood prossure measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodPressure:(LSSphygmometerData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        NSArray *dataStr=[DataFormatConverter parseBloodPressureMeterMeasureData:data];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
    });
   
}

//kitchen scale measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForKitchen:(LSKitchenScaleData *)kitData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        [self updateNewDataPrompt];
        NSString *str=[DataFormatConverter parseObjectDetailInStringValue:kitData];
        [self appendOutputText:str];
    });
}


//pedometer measurement data update
-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForPedometer:(LSDeviceData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!data) {
            return ;
        }
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        if(DataFormatConverter.currentDevicePower >0){
            self.powerTitleLabel.hidden=NO;
            self.powerLabel.hidden=NO;
            self.powerLabel.text=[NSString stringWithFormat:@"%@%%",@(DataFormatConverter.currentDevicePower)];
        }
        NSArray *dataStr=[DataFormatConverter parseDeviceMeasureData:data];
        for(NSString *str in dataStr)
        {
            [self appendOutputText:str];
        }
        //处理设备上传的GPS请求
        if(data.dataType == LSPacketDataSportsModeNotify){
            [self showGpsStatusSelectMenu:data];
        }
    });
}

//device battery voltage update
-(void)bleDevice:(LSDeviceInfo *)lsDevice didBatteryVoltageUpdate:(LSUVoltageModel *)voltageObj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self appendOutputText:spaceString];
        NSString *msg=nil;
        if(voltageObj.batteryPercent >0){
            self.powerTitleLabel.hidden=NO;
            self.powerLabel.hidden=NO;
            msg=[NSString stringWithFormat:@"device voltage results:(%@)-%@%%,isCharging ? %@",@(voltageObj.voltage),@(voltageObj.batteryPercent),voltageObj.isCharging ? @"Yes":@"No"];
            self.powerLabel.text=[NSString stringWithFormat:@"%@%%",@(voltageObj.batteryPercent)];
        }
        else{
            self.powerTitleLabel.hidden=NO;
            self.powerLabel.hidden=NO;
            self.powerLabel.text=[NSString stringWithFormat:@"%@",@(voltageObj.voltage)];
            msg=[NSString stringWithFormat:@"device voltage results:(%@)-%@,isCharging ? %@",@(voltageObj.voltage),@(voltageObj.batteryPercent),voltageObj.isCharging ? @"Yes":@"No"];
        }
        [self appendOutputText:msg];
    });
}

-(void)bleDevice:(LSDeviceInfo *)device didMeasureDataUpdateForBloodGlucose:(LSBloodGlucoseData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.dataCount++;
        [self updateNewDataPrompt];
        [self appendOutputText:spaceString];
        [self appendOutputText:[NSString stringWithFormat:@"measure time=%@",data.measureTime]];
        NSString *msg=[NSString stringWithFormat:@"blood glucose value=%@,unit=%@ ",@(data.concentration),data.measureUnits];
        [self appendOutputText:msg];
    });
}

- (void)bleDevice:(LSDeviceInfo *)device didWifiState:(LSScaleWifiStateModel *)data {
    NSLog(@"wifi 连接状态回调 ----- connectState:%@ ssidName:%@",@(data.connectState),data.ssidName);
    self.dataCount++;
    [self updateNewDataPrompt];
    [self appendOutputText:spaceString];
    NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
    for(NSString *str in dataStr)
    {
        [self appendOutputText:str];
    }
}

- (void)bleDevice:(LSDeviceInfo *)device didReconnectWifiResult:(LSScaleRestConnectWifiResult *)data {
    NSLog(@"重置wifi ------- %@",@(data.restConnectState));
    self.dataCount++;
    [self updateNewDataPrompt];
    [self appendOutputText:spaceString];
    NSArray *dataStr=[DataFormatConverter parseScaleMeasureData:data];
    for(NSString *str in dataStr)
    {
        [self appendOutputText:str];
    }
}

#pragma mark - LSDeviceUpgradingDelegate

//firmware upgrade status
-(void)bleDevice:(LSDeviceInfo *)lsDevice didUpgradeStatusChange:(LSDeviceUpgradeStatus)upgradeStatus
           error:(LSErrorCode)errorCode
{
    NSLog(@"upgrade status change:%@",@(upgradeStatus));
    dispatch_async(dispatch_get_main_queue(), ^{
        if(LSUpgradeStatusUpgradeSuccess == upgradeStatus)
        {
            NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:self.upgradingStartTime];
            NSString *time=[NSString stringWithFormat:@"Consuming Time:%@",[DataFormatConverter timeLeftSinceDate:startDate]];
            [self hideProcessingView];
            [self dismissViewControllerAnimated:YES completion:^{
                [self showAlertView:msg_upgrade_success message:time cancelBtn:NO handler:nil];
            }];
        }
        else if (LSUpgradeStatusUpgradeFailure == upgradeStatus)
        {
            [self.lsBleManager cancelDeviceUpgrading:self.currentDevice.broadcastId];
            NSString *msg=[NSString stringWithFormat:@"Error Code:%@",@(errorCode)];
            [self hideProcessingView];
            [self dismissViewControllerAnimated:YES completion:^{
                [self showAlertView:msg_upgrade_failed message:msg cancelBtn:NO handler:nil];
            }];
        }
        else if(LSUpgradeStatusUpgrading == upgradeStatus){
            [self dismissViewControllerAnimated:YES completion:^{
                [self showProgressView:prompt_upgrading handler:nil];
            }];
        }
    });
}

-(void)bleDevice:(LSDeviceInfo *)lsDevice didUpgradeProgressUpdate:(NSUInteger)progress
{
    //更新进度条
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressBarView setProgress:(progress/10)*0.1];
        self.progressLabel.text=[NSString stringWithFormat:@"%@%%",@(progress)];
    });
}


#pragma mark - LSDevicePairing Delegate


-(void)bleDevice:(LSDeviceInfo *)lsDevice didPairingStatusChange:(LSDevicePairedResults)pairingStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.processingView stopAnimating];
        self.processingView.hidden=YES;
        self.newsLabel.text=@"";
        NSString *title=msg_bind_failed;
        NSString *status=[NSString stringWithFormat:@"Error Code:%@",@(pairingStatus)];
        if(lsDevice && pairingStatus==LSDevicePairedResultsSuccess)
        {
            title=msg_bind_success;
            status=nil;
        }
        [self dismissIndicatorView:^{
            [self showAlertView:title message:status cancelBtn:NO handler:nil];
        }];
    });
}

-(void)bleDevice:(LSDeviceInfo *)lsDevice didOperationCommandUpdate:(LSDeviceOperationCmdInfo *)cmdInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"operation cmd info %@ >>",[DataFormatConverter parseObjectDetailInDictionary:cmdInfo]);
        if(cmdInfo.operationCmd==DOperationCmdInputDeviceId)
        {
            //set id to device e.g
            NSString *testDeviceId=lsDevice.broadcastId;
            [self.lsBleManager inputOperationCmd:cmdInfo.operationCmd
                                        replyObj:testDeviceId forDevice:lsDevice.broadcastId];
        }
        else if (DOperationCmdInputPairedConfirm==cmdInfo.operationCmd)
        {
            //set pairing confirm
            NSNumber *confirmStatus=[NSNumber numberWithBool:YES];
            [self.lsBleManager inputOperationCmd:cmdInfo.operationCmd
                                        replyObj:confirmStatus forDevice:lsDevice.broadcastId];
        }
        else if(DOperationCmdInputRandomCode == cmdInfo.operationCmd){
            [self dismissIndicatorView:^{
                [self showInputView:prompt_input_number];
            }];
        }
        else if(DOperationCmdInputDeviceId == cmdInfo.operationCmd){
            //set device'id for test
             NSString *deviceID=self.currentDevice.broadcastId;
            [self.lsBleManager inputOperationCmd:cmdInfo.operationCmd
                                        replyObj:deviceID forDevice:lsDevice.broadcastId];
        }
    });
}


#pragma mark - LSBluetoothStatusDelegate

-(void)systemDidBluetoothStatusChange:(CBManagerState)bleState
{
    NSLog(@"sky-test on bluetooth status change >> %@",@(bleState));
    if(CBManagerStatePoweredOn==bleState){
        [self connectDevice];
    }
}

#pragma mark - LSSettingItemDelegate

-(void)deviceSettingItem:(LSDeviceSettingItem *)item didSelectionValue:(NSUInteger)value
{
    NSLog(@"onSettingItem:%@,status:%@",item.filePath,@(value));
    [self upgradeFirmware:item.filePath];
}

-(void)onDebugMessage:(NSString *)msg {
    NSLog(@"%@",msg);
}

@end
