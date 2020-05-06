//
//  BaseSettingItemTVC.m
//  LSBluetooth-Demo
//
//  Created by caichixiang on 2018/8/13.
//  Copyright © 2018年 Lifesense. All rights reserved.
//

#import "BaseSettingItemTVC.h"
#import "DataFormatConverter.h"
#import "NSDate+Utils.h"

@interface BaseSettingItemTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, assign) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) UITableViewCell *currentSelectCell;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSArray *datePickerIndexRows;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) LSSedentaryClock      *sedentaryRemind;
@property (nonatomic, strong) LSBehaviorRemindInfo  *behaviorRemind;
@property (nonatomic, strong) LSDMessageReminder    *messageRemind;
@property (nonatomic, strong) LSDeviceWeatherInfo   *weatherRemind;
@property (nonatomic, strong) LSFutureWeatherModel  *weatherModel;
@property (nonatomic, strong) LSDeviceHeartRateAlertInfo   *heartRateRemind;
@property (nonatomic, strong) LSDNightMode *nightMode;
@property (nonatomic, strong) LSMoodRecordReminder *moodRecordReminder;
@property (nonatomic, strong) LSBluetoothManager *bleManager;
@property (nonatomic, strong) LSSportsInfo *sportsInfo;
@property (nonatomic, assign) BOOL isSettingEnable;
@property (nonatomic, strong) KCIAppointmentReminder *appointmentReminder;
@property (nonatomic, strong) KCIMessageReminder    *messageReminder;
@property (nonatomic, strong) KCISimpleReminder     *simpleReminder;
@property (nonatomic, strong) KCIWakeupReminder     *wakeupReminder;
@property (nonatomic, assign) BOOL isJoinAgenda;
@property (nonatomic, assign) NSUInteger reminderIndex;
@property (nonatomic, strong) LSPedometerQuietMode *quietMode;
@end

@implementation BaseSettingItemTVC

-(BOOL)shouldAutorotate
{
    return NO;
}


/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.tableView setMultipleTouchEnabled:YES];
    [self.dateFormatter setDateFormat:@"HH:mm"];
    self.navigationItem.title=self.item.title;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

- (void) back:(UIBarButtonItem *)sender
{
    [self showAlertView:nil  message:@"Save Changes ?"   cancelBtn:YES handler:^(UIAlertAction *action)
     {
         if(action.style == UIAlertActionStyleDefault)
         {
             [self showIndicatorView:prompt_setting handler:nil];
             [self syncSettingInfo];
         }
         else{
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

-(void)showSaveButton
{
    if(!self.navigationItem.hidesBackButton)
    {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = newBackButton;
    }
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

-(UIDatePicker *)datePicker
{
    if(!_datePicker){
        _datePicker=[[UIDatePicker alloc] init];
    }
    return _datePicker;
}

-(LSDeviceHeartRateAlertInfo *)heartRateRemind
{
    if(!_heartRateRemind){
        _heartRateRemind=[[LSDeviceHeartRateAlertInfo alloc] init];
    }
    _heartRateRemind.isEnable=self.isSettingEnable;
    return _heartRateRemind;
}

-(LSFutureWeatherModel *)weatherModel
{
    if(!_weatherModel){
        _weatherModel=[[LSFutureWeatherModel alloc] init];
    }
    return _weatherModel;
}

-(LSDeviceWeatherInfo *)weatherRemind
{
    if(!_weatherRemind){
        _weatherRemind=[[LSDeviceWeatherInfo alloc] init];
    }
    return _weatherRemind;
}

-(LSDMessageReminder *)messageRemind
{
    if(!_messageRemind){
        _messageRemind=[[LSDMessageReminder alloc] init];
        _messageRemind.shockDelay=2;                            //延时2秒开始振动
        _messageRemind.shockType=LSVibrationModeInterval;       //振动方式
        _messageRemind.shockTime=10;                            //振动时间
        _messageRemind.shockLevel1=6;                           //振动等级1
        _messageRemind.shockLevel2=8;                           //振动等级2
    }
    _messageRemind.isOpen=self.isSettingEnable;
    return _messageRemind;
}

-(LSBehaviorRemindInfo *)behaviorRemind
{
    if(!_behaviorRemind){
        _behaviorRemind=[[LSBehaviorRemindInfo alloc] init];
        _behaviorRemind.type=LSReminderTypeDrinkWater;
    }
    _behaviorRemind.enable=self.isSettingEnable;
    return _behaviorRemind;
}

-(LSSedentaryClock *)sedentaryRemind
{
    if(!_sedentaryRemind){
        _sedentaryRemind=[[LSSedentaryClock alloc] init];
        _sedentaryRemind.isOpen=YES;
        _sedentaryRemind.shockType=LSVibrationModeContinued;  //振动类型
        _sedentaryRemind.shockTime=10;                        //振动时间，单位秒
        _sedentaryRemind.shockLevel1=7;                       //振动等级1，0~9
        _sedentaryRemind.shockLevel2=8;                       //振动等级2，0~9
        _sedentaryRemind.interval=5;                          //振动频率，单位min
        [_sedentaryRemind addWeek:LSWeekMonday,LSWeekTuesday,LSWeekWednesday,
         LSWeekThursday,LSWeekFriday,LSWeekSaturday,LSWeekSunday];
    }
    _sedentaryRemind.isOpen=self.isSettingEnable;
    return _sedentaryRemind;
}

-(LSDNightMode *)nightMode
{
    if(!_nightMode){
        _nightMode=[[LSDNightMode alloc] init];
    }
    _nightMode.isOpen=self.isSettingEnable;
    return _nightMode;
}

-(LSSportsInfo *)sportsInfo
{
    if(!_sportsInfo){
        _sportsInfo=[[LSSportsInfo alloc] init];
    }
    return _sportsInfo;
}

-(LSBluetoothManager *)bleManager
{
    if(!_bleManager){
        _bleManager=[LSBluetoothManager defaultManager];
    }
    return _bleManager;
}

-(LSMoodRecordReminder *)moodRecordReminder
{
    if(!_moodRecordReminder){
        _moodRecordReminder=[[LSMoodRecordReminder alloc] init];
    }
    _moodRecordReminder.enable=self.isSettingEnable;
    return _moodRecordReminder;
}

-(KCIAppointmentReminder *)appointmentReminder{
    if(!_appointmentReminder){
        _appointmentReminder=[[KCIAppointmentReminder alloc] init];
    }
    self.reminderIndex++;
    _appointmentReminder.reminderIndex=(int)self.reminderIndex;
    _appointmentReminder.totalStatus=YES;
    _appointmentReminder.status=self.isSettingEnable;
    _appointmentReminder.joinAgenda=self.isJoinAgenda;
    return _appointmentReminder;
}

-(KCIMessageReminder *)messageReminder{
    if(!_messageReminder){
        _messageReminder=[[KCIMessageReminder alloc] init];
    }
    self.reminderIndex++;
    _messageReminder.reminderIndex=(int)self.reminderIndex;
    _messageReminder.totalStatus=YES;
    _messageReminder.status=self.isSettingEnable;
    _messageReminder.joinAgenda=self.isJoinAgenda;
    return _messageReminder;
}

-(KCISimpleReminder *)simpleReminder{
    if(!_simpleReminder){
        _simpleReminder=[[KCISimpleReminder alloc] init];
    }
    self.reminderIndex++;
    _simpleReminder.reminderIndex=(int)self.reminderIndex;
    _simpleReminder.totalStatus=YES;
    _simpleReminder.status=self.isSettingEnable;
    _simpleReminder.joinAgenda=self.isJoinAgenda;
    return _simpleReminder;
}

-(KCIWakeupReminder *)wakeupReminder{
    if(!_wakeupReminder){
        _wakeupReminder=[[KCIWakeupReminder alloc] init];
    }
    self.reminderIndex++;
    _wakeupReminder.reminderIndex=(int)self.reminderIndex;
    _wakeupReminder.totalStatus=YES;
    _wakeupReminder.status=self.isSettingEnable;
    _wakeupReminder.joinAgenda=self.isJoinAgenda;
    return _wakeupReminder;
}

-(LSPedometerQuietMode *)quietMode{
    if(!_quietMode){
        _quietMode=[[LSPedometerQuietMode alloc] init];
    }
    _quietMode.status=self.isSettingEnable;
    return _quietMode;
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    [self.tableView reloadData];
}


-(LSDeviceSettingItem *)itemWithIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSources objectAtIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"onCellFor Row:%@",indexPath);
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
    LSDeviceSettingItem *itemData = self.dataSources[indexPath.row];
    cell.textLabel.text = itemData.title;
    cell.detailTextLabel.text=(NSString *)itemData.itemValue;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSaveButton];
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //item action
    LSDeviceSettingItem *item=[self itemWithIndexPath:indexPath];
    item.indexPath=indexPath;
    if (item.itemType == LSSettingItemNumber)
    {
        [self showNumberInputView:[NSString stringWithFormat:@"Set %@",item.title]
                      placeholder:item.title
                             item:item
                     keyboardType:UIKeyboardTypeNumberPad];
    }
    else  if (item.itemType == LSSettingItemText)
    {
        [self showNumberInputView:[NSString stringWithFormat:@"Set %@",item.title]
                      placeholder:item.title
                             item:item
                     keyboardType:UIKeyboardTypeDefault];
    }
    else if (item.itemType == LSSettingItemSwitch)
    {
        if([self.currentSelectCell.detailTextLabel.text isEqualToString:item_switch_enable])
        {
            if([item.title isEqualToString:item_cell_switch_status]){
                self.isSettingEnable=NO;
            }
            if([item.title isEqualToString:item_cell_join_agenda]){
                self.isJoinAgenda=NO;
            }
            self.currentSelectCell.detailTextLabel.text=item_switch_disable;
        }
        else{
            if([item.title isEqualToString:item_cell_switch_status]){
                self.isSettingEnable=YES;
            }
            if([item.title isEqualToString:item_cell_join_agenda]){
                self.isJoinAgenda=YES;
            }
            self.currentSelectCell.detailTextLabel.text=item_switch_enable;
        }
    }
    else if(item.itemType == LSSettingItemSingleChoice){
        [self showSingleChoiceView:item];
    }
    else if (item.itemType == LSSettingItemDatePicker)
    {
        [self showDatePicker];
    }
    else{
        NSLog(@"undefine item select action:%@",@(item.itemType));
    }
}


#pragma mark - ShowInputView

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
                                                       handler:handler];
        [alert addAction:cancel];
    }
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
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
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)showNumberInputView:(NSString *)title
               placeholder:(NSString *)msg
                      item:(LSDeviceSettingItem *)item
              keyboardType:(UIKeyboardType)type
{
    UIAlertController *alertView=[UIAlertController alertControllerWithTitle:title
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleAlert];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = msg;
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.keyboardType=type;
    }];
    [alertView addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action)
    {
        NSArray * textfields = alertView.textFields;
        UITextField *textField = textfields[0];
        NSString *textValue=textField.text;
        NSLog(@"my input value:%@",textValue);
        self.currentSelectCell=[self.tableView cellForRowAtIndexPath:item.indexPath];
        self.currentSelectCell.detailTextLabel.text=textValue;
        if(type == UIKeyboardTypeNumberPad){
            [self handleData:@(textValue.intValue) forSettingItem:item];
        }
        else{
            [self handleData:textValue forSettingItem:item];
        }
    }]];
    // present alert view.
    [self presentViewController:alertView animated:YES completion:nil];
}

-(void)showSingleChoiceView:(LSDeviceSettingItem *)item
{
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
             NSNumber *value=[item valueOfKey:action.title];
             [self handleData:value forSettingItem:item];
        }]];
    }
    // Present action sheet.
    [self presentViewController:alertView animated:YES completion:nil];
}


#pragma mark - update alarm clock day setting and save

-(void)deviceSetingCategory:(LSDeviceSettingCategory)category
           didSettingReults:(BOOL)status
                  errorCode:(NSUInteger)code
{
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
}

-(void)showDatePicker{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    
    [picker setDatePickerMode:UIDatePickerModeTime];
    [alertController.view addSubview:picker];
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.currentSelectCell.detailTextLabel.text=[self.dateFormatter stringFromDate:picker.date];
            LSDeviceSettingItem *item = self.dataSources[[self.tableView indexPathForCell:self.currentSelectCell].row];
            [self handleData:picker.date forSettingItem:item];
        }];
        action;
    })];
    [self presentViewController:alertController  animated:YES completion:nil];
}

#pragma mark - Handle Setting Item Data

-(void)parseWeatherRemindSetting:(int)data
                         forItem:(LSDeviceSettingItem *)item
{
    if([item.title isEqualToString:item_cell_weather_aqi]){
        self.weatherModel.AQI=data;
    }
    else if([item.title isEqualToString:item_cell_temperature_min]){
        self.weatherModel.temperatureOne=data;
    }
    else if ([item.title isEqualToString:item_cell_temperature_max]){
        self.weatherModel.temperatureTwo=data;
    }
    else if([item.title isEqualToString:item_cell_weather_date]){
        long long utc = [NSDate date].timeIntervalSince1970;
        if(data ==1){
            //tomorrow
            utc=utc+24*60*60;
        }
        else if(data == 2){
            //day after tomorrow
            utc=utc+(24*60*60)*2;
        }
        self.weatherRemind.utc=utc;
    }
    else if([item.title isEqualToString:item_cell_weather_type]){
        self.weatherModel.type=(LSWeatherType)data;
    }
}

-(void)parseBehaviorRemindSetting:(id)data forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        if([item.title isEqualToString:item_cell_start_time]){
            self.behaviorRemind.startTime=[self.dateFormatter stringFromDate:(NSDate *)data];
        }
        else{
            self.behaviorRemind.endTime=[self.dateFormatter stringFromDate:(NSDate *)data];
        }
    }
    else{
        int value=[(NSNumber *)data intValue];
        self.behaviorRemind.intervalTime=value;
    }
}

-(void)parseSedentaryRemindSetting:(id)data forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        NSCalendar *calender=[NSCalendar currentCalendar];
        NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute)
                                                     fromDate:(NSDate *)data];
        int hour=(int)[dateComponents hour];
        int minute=(int)[dateComponents minute];
        if([item.title isEqualToString:item_cell_start_time]){
            self.sedentaryRemind.startHour=hour;
            self.sedentaryRemind.startMinute=minute;
        }
        else{
            self.sedentaryRemind.endHour=hour;
            self.sedentaryRemind.endMinute=minute;
        }
    }
    else{
        int value=[(NSNumber *)data intValue];
        if([item.title isEqualToString:item_cell_vibration_interval]){
            self.sedentaryRemind.interval=value;
        }
        else {
            self.sedentaryRemind.shockTime=value;
        }
    }
}

-(void)parseNightModeSetting:(id)data forItem:(LSDeviceSettingItem *)item
{
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute)
                                                 fromDate:(NSDate *)data];
    int hour=(int)[dateComponents hour];
    int minute=(int)[dateComponents minute];
    if([item.title isEqualToString:item_cell_start_time]){
        self.nightMode.startHour=hour;
        self.nightMode.startMin=minute;
    }
    else{
        self.nightMode.endHour=hour;
        self.nightMode.endMin=minute;
    }
}

-(void)parseSportsInfo:(int)data forItem:(LSDeviceSettingItem *)item
{
    if([item.title isEqualToString:item_cell_speed]){
        self.sportsInfo.speed=data;
    }
    else{
        self.sportsInfo.distance=data;
    }
}

#pragma mark - Moodbeam Record Setting Item

-(void)parseMoodRecordRemindSetting:(id)data
                            forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        NSCalendar *calender=[NSCalendar currentCalendar];
        NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute)
                                                     fromDate:(NSDate *)data];
        int hour=(int)[dateComponents hour];
        int minute=(int)[dateComponents minute];
        if([item.title isEqualToString:item_cell_start_time]){
            self.moodRecordReminder.startTime=[NSString stringWithFormat:@"%@:%@",@(hour),@(minute)];
        }
        else{
            self.moodRecordReminder.endTime=[NSString stringWithFormat:@"%@:%@",@(hour),@(minute)];
        }
    }
    else{
        int value=[(NSNumber *)data intValue];
        if([item.title isEqualToString:item_cell_vibration_interval]){
            self.moodRecordReminder.vibrationInterval=value;
        }
        else if([item.title isEqualToString:item_cell_vibration_time]){
            self.moodRecordReminder.vibrationTime=value;
        }
    }
}

#pragma mark - Kchiing Reminder Setting

-(KRepeatSetting *)getKRepeatSetting:(long)remindTime mode:(int)index
{
    KRepeatSetting *repeatSetting=[[KRepeatSetting alloc] init];
    if(index == 0){
        //once
        repeatSetting.repeatType=KRepeatNone;
        repeatSetting.value=0;
    }
    else if(index == 1){
        if(remindTime == 0){
            remindTime=[[NSDate date] timeIntervalSince1970];
        }
        //1x
        repeatSetting.repeatType=KRepeatBasedOnNumbers;
        repeatSetting.value=1;
        //next repeat reminder time,after 2 minutes of remindTime
        long nextTime=remindTime+2*60;
        repeatSetting.multiRemindTimes=@[@(nextTime)];
    }
    else if(index == 2){
        if(remindTime == 0){
            remindTime=[[NSDate date] timeIntervalSince1970];
        }
        //2x
        repeatSetting.repeatType=KRepeatBasedOnNumbers;
        repeatSetting.value=2;
        //next repeat reminder time,after 2 minutes of remindTime
        long nextTime=remindTime+1*60;
        long nextTime2=remindTime+2*60;
        repeatSetting.multiRemindTimes=@[@(nextTime),@(nextTime2)];
    }
    else if(index == 3){
        //"Every 3 minutes"
        repeatSetting.repeatType=KRepeatBasedOnMinutes;
        repeatSetting.value=3;
        //set start time and ends time
        long startTime=[[NSDate date] timeIntervalSince1970];
        repeatSetting.startTime=startTime;
        repeatSetting.endsTime=startTime+24*3600;
    }
    return repeatSetting;
    
}

-(void)parseAppointmentRemindSetting:(id)data
                             forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        //to utc
        if([item.title isEqualToString: item_cell_appointment_time]){
            NSDate *timeDate=(NSDate *)data;
//            long utc=timeDate.timeIntervalSince1970;
//            long utcWithTimeZone=[timeDate toLocalTime].timeIntervalSince1970;
//            NSLog(@"不带时区的UTC >> %@",[NSString stringWithFormat:@"%08lX",utc]); //5C048ACB
//            NSLog(@"带时区的UTC >> %@",[NSString stringWithFormat:@"%08lX",utcWithTimeZone]);// 5C04FB4B
            //TODO 带时区的UTC时间，后期需修改为不带时区的UTC时间
            self.appointmentReminder.appointTime=timeDate.timeIntervalSince1970;
        }
        else if([item.title isEqualToString:item_cell_reminder_time]){
            NSDate *timeDate=(NSDate *)data;
            self.appointmentReminder.remindTime=timeDate.timeIntervalSince1970;
        }
    }
    else{
        if([item.title isEqualToString:item_cell_vibration_length]){
            int value=[(NSNumber *)data intValue];
            self.appointmentReminder.vibrationLength=value;
        }
        else if([item.title isEqualToString:item_cell_repeat_mode]){
            int value=[(NSNumber *)data intValue];
            self.appointmentReminder.repeatSetting=[self getKRepeatSetting:self.appointmentReminder.remindTime mode:value];
        }
        else if ([item.title isEqualToString:item_cell_reminder_title]){
            self.appointmentReminder.title=(NSString *)data;
        }
        else if([item.title isEqualToString:item_cell_reminder_content]){
            self.appointmentReminder.content=(NSString *)data;
        }
        else if([item.title isEqualToString:item_cell_reminder_location]){
            self.appointmentReminder.location=(NSString *)data;
        }
    }
}

-(void)parseMessageRemindSetting:(id)data
                         forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        //to utc
        if([item.title isEqualToString:item_cell_reminder_time]){
            NSDate *timeDate=(NSDate *)data;
            self.messageReminder.remindTime=timeDate.timeIntervalSince1970;
        }
    }
    else{
        if([item.title isEqualToString:item_cell_vibration_length]){
            int value=[(NSNumber *)data intValue];
            self.messageReminder.vibrationLength=value;
        }
        else if([item.title isEqualToString:item_cell_reminder_content]){
            self.messageReminder.content=(NSString *)data;
        }
    }
}


-(void)parseSimpleRemindSetting:(id)data
                        forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        //to utc
        if([item.title isEqualToString: item_cell_reminder_time]){
            NSDate *timeDate=(NSDate *)data;
            //TODO 带时区的UTC时间，后期需修改为不带时区的UTC时间
            self.simpleReminder.remindTime=timeDate.timeIntervalSince1970;
        }
        else if([item.title isEqualToString:item_cell_ends_time]){
            NSDate *timeDate=(NSDate *)data;
            if(self.simpleReminder.repeatSetting){
                self.simpleReminder.repeatSetting.expirationDate=timeDate.timeIntervalSince1970;
            }
        }
    }
    else{
        if([item.title isEqualToString:item_cell_vibration_length]){
            int value=[(NSNumber *)data intValue];
            self.simpleReminder.vibrationLength=value;
        }
        else if([item.title isEqualToString:item_cell_repeat_mode]){
            int value=[(NSNumber *)data intValue];
            self.simpleReminder.repeatSetting=[self getKRepeatSetting:self.simpleReminder.remindTime mode:value];
        }
        else if ([item.title isEqualToString:item_cell_reminder_title]){
            self.simpleReminder.title=(NSString *)data;
        }
        else if([item.title isEqualToString:item_cell_reminder_content]){
            self.simpleReminder.content=(NSString *)data;
        }
    }
}

-(void)parseWakeupRemindSetting:(id)data
                        forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        //to utc
        if([item.title isEqualToString: item_cell_reminder_time]){
            NSDate *timeDate=(NSDate *)data;
            //TODO 带时区的UTC时间，后期需修改为不带时区的UTC时间
            self.wakeupReminder.remindTime=timeDate.timeIntervalSince1970;
        }
    }
    else{
        if([item.title isEqualToString:item_cell_vibration_length]){
            int value=[(NSNumber *)data intValue];
            self.wakeupReminder.vibrationLength=value;
        }
        else if([item.title isEqualToString:item_cell_snooze_length]){
            int value=[(NSNumber *)data intValue];
            self.wakeupReminder.snoozeLength=value;
        }
        else if([item.title isEqualToString:item_cell_repeat_mode]){
            int value=[(NSNumber *)data intValue];
            self.wakeupReminder.repeatSetting=[self getKRepeatSetting:self.wakeupReminder.remindTime mode:value];
        }
        else if ([item.title isEqualToString:item_cell_reminder_title]){
            self.wakeupReminder.title=(NSString *)data;
        }
        else if([item.title isEqualToString:item_cell_reminder_content]){
            self.wakeupReminder.content=(NSString *)data;
        }
    }
}

-(void)parseQuietModeSetting:(id)data
                     forItem:(LSDeviceSettingItem *)item
{
    if([data isKindOfClass:[NSDate class]]){
        NSCalendar *calender=[NSCalendar currentCalendar];
        NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute)
                                                     fromDate:(NSDate *)data];
        int hour=(int)[dateComponents hour];
        int minute=(int)[dateComponents minute];
        if([item.title isEqualToString:item_cell_start_time]){
            self.quietMode.startTime=[NSString stringWithFormat:@"%@:%@",@(hour),@(minute)];
        }
        else{
            self.quietMode.endsTime=[NSString stringWithFormat:@"%@:%@",@(hour),@(minute)];
        }
    }
    else{
        int value=[(NSNumber *)data intValue];
        if([item.title isEqualToString:item_cell_device_funs]){
            LSDeviceFunctionInfo *funs=[[LSDeviceFunctionInfo alloc] init];
            funs.enable=(value==1?YES:NO);
            funs.function=LSDeviceFunctionTurnOnScreen;
            self.quietMode.functions=@[funs];
        }
    }
}


/**
 * 数据项设置处理
 */
-(void)handleData:(id)data  forSettingItem:(LSDeviceSettingItem *)item
{
    if(item.itemType == LSSettingItemDatePicker){
        //日期数据处理
        if(DSCategorySedentaryRemind == item.type){
            [self parseSedentaryRemindSetting:data forItem:item];
        }
        else if(DSCategoryBehaviorRemind == item.type){
            [self parseBehaviorRemindSetting:data forItem:item];
        }
        else if(DSCategoryNightMode == item.type){
            [self parseNightModeSetting:data forItem:item];
        }
        else if(DSMoodRecordRemind == item.type){
            [self parseMoodRecordRemindSetting:data forItem:item];
        }
        else if(DSAppointmentRemind == item.type){
            [self parseAppointmentRemindSetting:data forItem:item];
        }
        else if (DSMessageRemind == item.type){
            [self parseMessageRemindSetting:data forItem:item];
        }
        else if(DSWakeupRemind == item.type){
            [self parseWakeupRemindSetting:data forItem:item];
        }
        else if(DSSimpleRemind == item.type){
            [self parseSimpleRemindSetting:data forItem:item];
        }
        else if(DSCategoryQuietMode == item.type){
            [self parseQuietModeSetting:data forItem:item];
        }
        else{
            NSLog(@"undefine setting item with DatePicker  >> %@",item);
        }
    }
    else if(item.itemType == LSSettingItemNumber){
        //数字处理
        int value=[(NSNumber *)data intValue];
        if(DSCategoryHeartRateWarning == item.type){
            if([item.title isEqualToString:item_cell_min_hr]){
                self.heartRateRemind.minHeartRate=value;
            }
            else{
                self.heartRateRemind.maxHeartRate=value;
            }
        }
        else if(DSCategorySedentaryRemind == item.type){
            //久坐提醒设置
            [self parseSedentaryRemindSetting:data forItem:item];
        }
        else if(DSCategoryWeatherRemind == item.type){
            //天气设置
            [self parseWeatherRemindSetting:value forItem:item];
        }
        else if (DSCategoryBehaviorRemind == item.type){
            //行为提醒设置
            [self parseBehaviorRemindSetting:data forItem:item];
        }
        else if(DSCategorySportsInfo == item.type){
            //运动配速、距离设置
            [self parseSportsInfo:value forItem:item];
        }
        else if(DSMoodRecordRemind == item.type){
            [self parseMoodRecordRemindSetting:data forItem:item];
        }
        else if(DSAppointmentRemind == item.type){
            //kchiing appointment reminder
            [self parseAppointmentRemindSetting:data forItem:item];
        }
        else if (DSMessageRemind == item.type){
            //kchiing message reminder
            [self parseMessageRemindSetting:data forItem:item];
        }
        else if(DSWakeupRemind == item.type){
            //kchiing wakeup reminder
            [self parseWakeupRemindSetting:data forItem:item];
        }
        else if(DSSimpleRemind == item.type){
            //kchiing simple reminder
            [self parseSimpleRemindSetting:data forItem:item];
        }
        else{
            NSLog(@"undefine setting item with Number  >> %@",item);
        }
    }
    else if(item.itemType == LSSettingItemSingleChoice){
        //单项选择
        if(item.type == DSCategoryMessageRemind){
            LSDeviceMessageType messageType=(LSDeviceMessageType)([(NSNumber *)data unsignedIntegerValue]);
            self.messageRemind.type=messageType;
        }
        else if(item.type == DSCategoryWeatherRemind){
            int value=(int)[(NSNumber *)data unsignedIntegerValue];
            [self parseWeatherRemindSetting:value forItem:item];
        }
        else if(DSAppointmentRemind == item.type){
            //kchiing appointment reminder
            [self parseAppointmentRemindSetting:data forItem:item];
        }
        else if (DSMessageRemind == item.type){
            //kchiing message reminder
            [self parseMessageRemindSetting:data forItem:item];
        }
        else if(DSWakeupRemind == item.type){
            //kchiing wakeup reminder
            [self parseWakeupRemindSetting:data forItem:item];
        }
        else if(DSSimpleRemind == item.type){
            //kchiing simple reminder
            [self parseSimpleRemindSetting:data forItem:item];
        }
        else if(DSCategoryQuietMode == item.type){
            //quiet mode setting
            [self parseQuietModeSetting:data forItem:item];
        }
        else{
            NSLog(@"undefine setting item with Single Choice  >> %@",item);
        }
    }
    else if(item.itemType == LSSettingItemText){
        if(DSAppointmentRemind == item.type){
            //kchiing appointment reminder
            [self parseAppointmentRemindSetting:data forItem:item];
        }
        else if (DSMessageRemind == item.type){
            //kchiing message reminder
            [self parseMessageRemindSetting:data forItem:item];
        }
        else if(DSWakeupRemind == item.type){
            //kchiing wakeup reminder
            [self parseWakeupRemindSetting:data forItem:item];
        }
        else if(DSSimpleRemind == item.type){
            //kchiing simple reminder
            [self parseSimpleRemindSetting:data forItem:item];
        }
        else{
            NSLog(@"undefine setting item with text  >> %@",item);
        }
    }
    else{
        NSLog(@"undefine setting item >> %@",item);
    }
}

/**
 * 将设置信息同步至设备
 */
-(void)syncSettingInfo
{
    if(DSCategorySedentaryRemind == self.item.type){
        //同步久坐提醒设置信息
        [self.bleManager updateSedentaryInfo:@[self.sedentaryRemind]
                                 isEnableAll:YES forDevice:self.activeDevice.broadcastId
                                    andBlock:^(BOOL isSuccess, NSUInteger errorCode)
        {
            [self deviceSetingCategory:self.item.type didSettingReults:isSuccess errorCode:errorCode];
        }];
    }
    else if(DSCategoryHeartRateWarning == self.item.type){
        //同步运动心率警告设置信息
        [self.bleManager updateHeartRateAlertInfo:self.heartRateRemind
                                        forDevice:self.activeDevice.broadcastId
                                         andBlock:^(BOOL isSuccess, NSUInteger errorCode)
        {
         [self deviceSetingCategory:self.item.type didSettingReults:isSuccess errorCode:errorCode];
        }];
    }
    else if (DSCategoryMessageRemind == self.item.type)
    {
        //同步消息提醒设置信息
        [self.bleManager updateMessageRemind:self.messageRemind
                                   forDevice:self.activeDevice.broadcastId
                                    andBlock:^(BOOL isSuccess, NSUInteger errorCode)
        {
            [self deviceSetingCategory:self.item.type didSettingReults:isSuccess errorCode:errorCode];
        }];
    }
    else if (DSCategoryWeatherRemind == self.item.type)
    {
        self.weatherRemind.utc=[NSDate date].timeIntervalSince1970;
        [self.weatherRemind addWeatherData:self.weatherModel];
        //同步天气提醒设置信息
        [self.bleManager updateWeatherInfo:self.weatherRemind
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code)
        {
            [self deviceSetingCategory:self.item.type didSettingReults:state errorCode:code];
        }];
    }
    else if(DSCategoryBehaviorRemind == self.item.type){
        //同步行为提醒设置
        [self.bleManager updateBehaviorRemind:self.behaviorRemind
                                    forDevice:self.activeDevice.broadcastId
                                     andBlock:^(BOOL isSuccess, NSUInteger errorCode)
        {
            [self deviceSetingCategory:self.item.type didSettingReults:isSuccess errorCode:errorCode];
        }];
    }
    else if (DSCategoryNightMode == self.item.type)
    {
        //同步夜间模式设置
        [self.bleManager updateNightDisplayMode:self.nightMode
                                      froDevcie:self.activeDevice.broadcastId
                                       andBlock:^(BOOL state, NSUInteger code)
         {
             [self deviceSetingCategory:DSCategoryNightMode didSettingReults:state errorCode:code];
         }];
    }
    else if(DSCategorySportsInfo == self.item.type)
    {
        //同步运动信息设置
        [self.bleManager pushDeviceMessage:self.sportsInfo
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
           [self deviceSetingCategory:DSCategorySportsInfo didSettingReults:state errorCode:code];
        }];
    }
    else if(DSMoodRecordRemind == self.item.type){
        NSLog(@"sync mood record remind >> %@",[DataFormatConverter parseObjectDetailInDictionary:self.moodRecordReminder]);
        
        [self.bleManager pushDeviceMessage:self.moodRecordReminder
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
         [self deviceSetingCategory:DSMoodRecordRemind didSettingReults:state errorCode:code];
        }];
    }
    else if (DSAppointmentRemind == self.item.type){
        NSLog(@"sync appointment remind >> %@",self.appointmentReminder.description);
        [self.bleManager pushDeviceMessage:self.appointmentReminder
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
              [self deviceSetingCategory:DSAppointmentRemind didSettingReults:state errorCode:code];
        }];
    }
    else if (DSMessageRemind == self.item.type){
        NSLog(@"sync message remind >> %@",self.messageReminder.description);
        [self.bleManager pushDeviceMessage:self.messageRemind
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
            [self deviceSetingCategory:DSAppointmentRemind didSettingReults:state errorCode:code];
        }];
    }
    else if (DSSimpleRemind == self.item.type){
        NSLog(@"sync simple remind >> %@",self.simpleReminder.description);
        [self.bleManager pushDeviceMessage:self.simpleReminder
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
        [self deviceSetingCategory:DSAppointmentRemind didSettingReults:state errorCode:code];
        }];
    }
    else if (DSWakeupRemind == self.item.type){
        NSLog(@"sync wakeup remind >> %@",self.wakeupReminder.description);
        [self.bleManager pushDeviceMessage:self.wakeupReminder
                                 forDevice:self.activeDevice.broadcastId
                                  andBlock:^(BOOL state, NSUInteger code) {
           [self deviceSetingCategory:DSAppointmentRemind didSettingReults:state errorCode:code];
        }];
    }
    else if (DSCategoryQuietMode == self.item.type){
        NSLog(@"sync quiet mode >> %@",self.quietMode.description);
        [self.bleManager pushDeviceMessage:self.quietMode forDevice:self.activeDevice.broadcastId andBlock:^(BOOL state, NSUInteger code) {
            [self deviceSetingCategory:DSAppointmentRemind didSettingReults:state errorCode:code];
        }];
    }
}

@end
