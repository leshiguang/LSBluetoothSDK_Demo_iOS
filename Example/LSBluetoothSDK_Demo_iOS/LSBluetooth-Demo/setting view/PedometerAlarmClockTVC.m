
//
//  UserDetailsTVC.m
//  LsBluetooth-Test
//
//  Created by lifesense on 15/8/14.
//  Copyright (c) 2015年 com.lifesense. All rights reserved.
//

#import "PedometerAlarmClockTVC.h"

#import "DeviceUser.h"
#import "LSDatabaseManager.h"
#import "FatScaleSettingTVC.h"
#import "PedometerSettingTVC.h"
#import "DataFormatConverter.h"
#import "DeviceUserProfiles.h"
#import "DeviceAlarmClock.h"
#import "LSDeviceSettingItem.h"


#define kPickerAnimationDuration2    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag2              99     // view tag identifiying the date picker view

#define kTitleKey2       @"title"   // key for obtaining the data source item's title
#define kDateKey2        @"date"    // key for obtaining the data source item's date value

#define KCellDataKey2   @"cellData"

// keep track of which rows have date cells
#define kDateStartRow2   3


static NSString *kDateCellID = @"alarmClockCell";
static NSString *kDatePickerID = @"alarmClockDatePicker";
static NSString *kOtherCell = @"dayCell";
static NSString *kIndexCell= @"indexCell";
static NSString *kTitleCell= @"titleCell";
static NSString *KTypeCell=@"typeCell";

static NSString *kMonday=@"Monday";
static NSString *kTuesday=@"Tuesday";
static NSString *kWednesday=@"Wednesday";
static NSString *kThursday=@"Thursday";
static NSString *kFriday=@"Friday";
static NSString *kSaturday=@"Saturday";
static NSString *kSunday=@"Sunday";


#pragma mark -

@interface PedometerAlarmClockTVC ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;
@property (nonatomic, assign) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) IBOutlet UIDatePicker *alarmClockPickerView;
@property (nonatomic, strong) NSArray *athleteLevelArray;
@property (nonatomic, strong) DeviceAlarmClock *currentAlarmClock;
@property (nonatomic, strong) UITableViewCell *currentSelectCell;
@property (nonatomic, strong) NSArray *section1DataSource;
@property (nonatomic, strong) NSArray *section2DataSource;
@property (nonatomic,strong) LSPedometerAlarmClock *alarmClock;
@property (nonatomic,strong) LSDeviceEventReminderInfo *eventClock;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end


#pragma mark -

@implementation PedometerAlarmClockTVC

-(BOOL)shouldAutorotate
{
    return NO;
}

-(LSPedometerAlarmClock *)alarmClock
{
    if(!_alarmClock){
        _alarmClock=[[LSPedometerAlarmClock alloc] init];
        _alarmClock.isOpen=YES;
        _alarmClock.shockType=LSVibrationModeInterval;
        _alarmClock.shockTime=15;
        _alarmClock.shockLevel1=6;
        _alarmClock.shockLevel2=8;
        //default value
        [_alarmClock addWeek:LSWeekFriday,LSWeekSunday,LSWeekSaturday,
         LSWeekTuesday,LSWeekThursday,LSWeekWednesday,LSWeekMonday];
    }
    return _alarmClock;
    
}

-(LSDeviceEventReminderInfo *)eventClock
{
    if(!_eventClock){
        _eventClock=[[LSDeviceEventReminderInfo alloc] init];
        _eventClock.eventSwitch=YES;
        _eventClock.shockType=LSVibrationModeContinued;
        _eventClock.shockTime=10;
        _eventClock.shockLevel1=8;
        _eventClock.shockLevel2=9;
        _eventClock.eventcontent=@"test";
        _eventClock.index=1;
        //default value
        [_eventClock addWeek:LSWeekFriday,LSWeekSunday,LSWeekSaturday,
         LSWeekTuesday,LSWeekThursday,LSWeekWednesday,LSWeekMonday];
    }
    return _eventClock;
    
}
/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    LSDatabaseManager *databaseManager=[LSDatabaseManager defaultManager];
    DeviceUser *deviceUser=[[databaseManager allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    self.currentAlarmClock=deviceUser.userprofiles.deviceAlarmClock;
    
    // setup our data source
    self.section1DataSource=[self alarmClockTimeDataSource];
    self.section2DataSource=[self alarmClockDayDataSource];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.alarmClockPickerView setDatePickerMode:UIDatePickerModeTime];
    [self.tableView setMultipleTouchEnabled:YES];
    
    [self.dateFormatter setDateFormat:@"HH:mm"];
    
    //    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
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
    [self showAlertView:nil
                message:@"Save Changes ?"
              cancelBtn:YES
                handler:^(UIAlertAction *action) {
        if(action.style == UIAlertActionStyleDefault)
        {
            [self showIndicatorView:prompt_setting handler:nil];
            if(self.settingCategory == DSCategoryEventClock){
                [self saveEventClock];
            }
            else{
                [self saveAlarmClock];
            }
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

#pragma mark - table view data source

-(NSArray *)alarmClockDayDataSource
{
    NSMutableDictionary *mondayItem= [@{ kTitleKey2 : kMonday ,KCellDataKey2:self.currentAlarmClock.monday} mutableCopy];
    NSMutableDictionary *tuesdayItem= [@{ kTitleKey2 : kTuesday ,KCellDataKey2:self.currentAlarmClock.tuesday} mutableCopy];
    NSMutableDictionary *wednesdayItem= [@{ kTitleKey2 : kWednesday ,KCellDataKey2:self.currentAlarmClock.wednesday} mutableCopy];
    NSMutableDictionary *thursdayItem= [@{ kTitleKey2 : kThursday ,KCellDataKey2:self.currentAlarmClock.thursday} mutableCopy];
    NSMutableDictionary *fridayItem= [@{ kTitleKey2 : kFriday ,KCellDataKey2:self.currentAlarmClock.friday} mutableCopy];
    NSMutableDictionary *saturdayItem= [@{ kTitleKey2 : kSaturday ,KCellDataKey2:self.currentAlarmClock.saturday} mutableCopy];
    NSMutableDictionary *sundayItem= [@{ kTitleKey2 : kSunday ,KCellDataKey2:self.currentAlarmClock.sunday} mutableCopy];
    
    return @[mondayItem, tuesdayItem, wednesdayItem,thursdayItem,fridayItem,saturdayItem,sundayItem];
}

-(NSArray *)alarmClockTimeDataSource
{
    NSDate *currentTime=self.currentAlarmClock.alarmClockTime;
    NSMutableDictionary *reminderTypeItem = [@{ kTitleKey2 : @"Reminder Type",
                                                KCellDataKey2 : @"0" } mutableCopy];
    NSMutableDictionary *indexItem = [@{ kTitleKey2 : @"Clock Index",
                                                  KCellDataKey2 : @"1" } mutableCopy];
    NSMutableDictionary *titleItem = [@{ kTitleKey2 : @"Clock Title",
                                                  KCellDataKey2 : @"test" } mutableCopy];
    NSMutableDictionary *alarmClockTimeItem = [@{ kTitleKey2 : @"Alarm Clock Time",
                                           kDateKey2 : currentTime } mutableCopy];

    
    return @[reminderTypeItem,indexItem,titleItem,alarmClockTimeItem];
   
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


#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}


#pragma mark - Utilities

/*! Returns the major version of iOS, (i.e. for iOS 6.1.3 it returns 6)
 */
NSUInteger DeviceSystemMajorVersion2()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion =
        [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] integerValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER2 (DeviceSystemMajorVersion2() >= 7)

/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag2];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag2];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.section1DataSource[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey2] animated:NO];
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
 @param indexPath The indexPath to check if it represents start/end date cell.
 */
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow2))
    {
        hasDate = YES;
    }
    
    return hasDate;
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows=0;
    if(section==0) {
        if ([self hasInlineDatePicker])
        {
            // we have a date picker, so allow for it in the number of rows in this section
            numRows = self.section1DataSource.count;
            ++numRows;
        }
        else{
            numRows=self.section1DataSource.count;
        }
    }
    else {
        numRows=self.section2DataSource.count;
    }
    return numRows;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *cellID = kOtherCell;
    if ([self indexPathHasPicker:indexPath]) {
        cellID = kDatePickerID;
    }
    else if ([self indexPathHasDate:indexPath]){
        cellID = kDateCellID;
    }
    if(indexPath.section==0)
    {
        if(indexPath.row==0){
            cellID=KTypeCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            NSDictionary *itemData = self.section1DataSource[indexPath.row];
            cell.textLabel.text = [itemData valueForKey:kTitleKey2];
            cell.detailTextLabel.text=[itemData valueForKey:KCellDataKey2];
        }
        else if(indexPath.row == 1){
            cellID=kIndexCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            NSDictionary *itemData = self.section1DataSource[indexPath.row];
            cell.textLabel.text = [itemData valueForKey:kTitleKey2];
            cell.detailTextLabel.text=[itemData valueForKey:KCellDataKey2];
        }
        else if(indexPath.row==2){
            cellID=kTitleCell;
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            NSDictionary *itemData = self.section1DataSource[indexPath.row];
            cell.textLabel.text = [itemData valueForKey:kTitleKey2];
            cell.detailTextLabel.text=[itemData valueForKey:KCellDataKey2];
        }
        else{
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.selectionStyle=UITableViewCellSelectionStyleBlue;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.textAlignment=NSTextAlignmentLeft;
            // if we have a date picker open whose cell is above the cell we want to update,
            // then we have one more cell than the model allows
            NSInteger modelRow = indexPath.row;
            if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row){
                modelRow--;
            }
            NSDictionary *itemData = self.section1DataSource[modelRow];
            // proceed to configure our cell
            if ([cellID isEqualToString:kDateCellID]) {
                // we have either start or end date cells, populate their date field
                cell.textLabel.text = [itemData valueForKey:kTitleKey2];
                cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey2]];
            }
        }
        return cell;
    }
    else {
        cellID=kOtherCell;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        NSDictionary *itemData = self.section2DataSource[indexPath.row];
        cell.textLabel.text = [itemData valueForKey:kTitleKey2];
        BOOL isCheck=[[itemData valueForKey:KCellDataKey2] boolValue];
        if(isCheck) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
        return cell;
    }
}


/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        [self.tableView beginUpdates];
        
        NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
        
        // check if 'indexPath' has an attached date picker below it
        if ([self hasPickerForIndexPath:indexPath])
        {
            // found a picker below it, so remove it
            [self.tableView deleteRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            // didn't find a picker below it, so we should insert it
            [self.tableView insertRowsAtIndexPaths:indexPaths
                                  withRowAnimation:UITableViewRowAnimationFade];
        }
        
        [self.tableView endUpdates];
    }
    
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showSaveButton];
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        if ([self.currentSelectCell.reuseIdentifier caseInsensitiveCompare:kDateCellID]==NSOrderedSame)
        {
            if (EMBEDDED_DATE_PICKER2) {
                [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            }
        }
        else if([self.currentSelectCell.reuseIdentifier caseInsensitiveCompare:kIndexCell]==NSOrderedSame){
            [self showInputView:@"Set Clock Index" keyboardType:UIKeyboardTypeNumberPad];
        }
        else if([self.currentSelectCell.reuseIdentifier caseInsensitiveCompare:kTitleCell]==NSOrderedSame){
            [self showInputView:@"Set Clock Title" keyboardType:UIKeyboardTypeDefault];
        }
        else if([self.currentSelectCell.reuseIdentifier caseInsensitiveCompare:KTypeCell]==NSOrderedSame){
            [self showInputView:@"Set Reminder Type" keyboardType:UIKeyboardTypeNumberPad];
        }
    }
    if(indexPath.section==1)
    {
        NSMutableDictionary *itemData = self.section2DataSource[indexPath.row];
        BOOL isCheck=[[itemData valueForKey:KCellDataKey2] boolValue];
        if(isCheck){
           self.currentSelectCell.accessoryType=UITableViewCellAccessoryNone;
            [itemData setValue:[NSNumber numberWithBool:NO] forKeyPath:KCellDataKey2];
            [self updateAlarmClockDaySetting:[itemData valueForKey:kTitleKey2] checkValue:NO];
        }
        else{
            [itemData setValue:[NSNumber numberWithBool:YES] forKeyPath:KCellDataKey2];
            self.currentSelectCell.accessoryType=UITableViewCellAccessoryCheckmark;
            [self updateAlarmClockDaySetting:[itemData valueForKey:kTitleKey2] checkValue:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(void)showInputView:(NSString *)msg
        keyboardType:(UIKeyboardType)type
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: nil
                                                                    message: msg
                                                             preferredStyle:UIAlertControllerStyleAlert];
    if(UIKeyboardTypeNumberPad == type){
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Index Number";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.keyboardType=type;
        }];
    }
    else{
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Clock Title";
            textField.textColor = [UIColor blueColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            textField.keyboardType=type;
        }];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action)
    {
        NSArray * textfields = alert.textFields;
        UITextField *textField = textfields[0];
        NSString *value=textField.text;
        if(textField.keyboardType == UIKeyboardTypeNumberPad){
            if([self.currentSelectCell.reuseIdentifier caseInsensitiveCompare:KTypeCell]==NSOrderedSame){
                self.eventClock.reminderType=(LSReminderType)value.intValue;
            }
            else{
                self.eventClock.index=value.intValue;
            }
        }
        else{
            self.eventClock.eventcontent=value;
        }
        self.currentSelectCell.detailTextLabel.text=value;
        NSLog(@"input value:%@,keyBoardType:%@,identifier:%@",value,@(textField.keyboardType),self.currentSelectCell.reuseIdentifier);
   
    }]];
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

#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)alarmClockTimeAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    else
    {
        // external date picker: update the current "selected" cell's date
        targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    // update our data model
    NSMutableDictionary *itemData = self.section1DataSource[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey2];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    
    //update the birthday to user info
    
    NSCalendar *calender=[NSCalendar currentCalendar];
    NSDateComponents *dateComponents=[calender components:(NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:targetedDatePicker.date];
    NSInteger hour=[dateComponents hour];
    NSInteger minute=[dateComponents minute];
    
    self.currentAlarmClock.alarmClockTime=targetedDatePicker.date;
    [self updateClockTime:hour minute:minute];
    NSLog(@"un set alarm clock time %ld:%ld",(long)hour,(long)minute);
    
}


#pragma mark - update alarm clock day setting and save

-(void)updateAlarmClockDaySetting:(NSString *)selectTitle checkValue:(BOOL)checkValue
{
    NSNumber *value=[NSNumber numberWithBool:checkValue];
    NSLog(@"%@ is check ? %@",selectTitle,value);
    
    if([kMonday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.monday=value;
        [self.eventClock addWeekDay:LSWeekMonday];
        [self.alarmClock addWeekDay:LSWeekMonday];
        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekMonday];
            [self.alarmClock removeWeekDay:LSWeekMonday];
        }
        return ;
    }
    if([kTuesday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.tuesday=value;
        [self.eventClock addWeekDay:LSWeekTuesday];
        [self.alarmClock addWeekDay:LSWeekTuesday];
        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekTuesday];
            [self.alarmClock removeWeekDay:LSWeekTuesday];
        }
        return ;
    }
    if([kWednesday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.wednesday=value;
        [self.eventClock addWeekDay:LSWeekWednesday];
        [self.alarmClock addWeekDay:LSWeekWednesday];

        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekWednesday];
            [self.alarmClock removeWeekDay:LSWeekWednesday];
        }
        return ;
    }
    if([kThursday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.thursday=value;
        [self.eventClock addWeekDay:LSWeekThursday];
        [self.alarmClock addWeekDay:LSWeekThursday];

        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekThursday];
            [self.alarmClock removeWeekDay:LSWeekThursday];

        }
        return ;
    }
    if([kFriday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.friday=value;
        [self.eventClock addWeekDay:LSWeekFriday];
        [self.alarmClock addWeekDay:LSWeekFriday];
        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekFriday];
            [self.alarmClock removeWeekDay:LSWeekFriday];

        }
        return ;
    }
    if([kSaturday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.saturday=value;
        [self.eventClock addWeekDay:LSWeekSaturday];
        [self.alarmClock addWeekDay:LSWeekSaturday];

        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekSaturday];
            [self.alarmClock removeWeekDay:LSWeekSaturday];
        }
        return ;
    }
    if([kSunday isEqualToString:selectTitle])
    {
        self.currentAlarmClock.sunday=value;
        [self.eventClock addWeekDay:LSWeekSunday];
        [self.alarmClock addWeekDay:LSWeekSunday];
        if(!checkValue){
            [self.eventClock removeWeekDay:LSWeekSunday];
            [self.alarmClock removeWeekDay:LSWeekSunday];
        }
        return ;
    }
}

-(void)updateClockTime:(NSUInteger)hour minute:(NSUInteger)min
{
    if(DSCategoryEventClock == self.settingCategory){
        self.eventClock.hour=(int)hour;
        self.eventClock.minute=(int)min;
    }
    else{
        self.alarmClock.hour=(int)hour;
        self.alarmClock.minute=(int)min;
    }
}

-(void)saveEventClock
{
    //calling methods
    if(!self.eventClock.eventcontent.length){
        self.eventClock.eventcontent=@"test";
    }
    if(self.eventClock.index <=0){
        self.eventClock.index=1;
    }
    [[LSBluetoothManager defaultManager]  updateEventReminderInfo:self.eventClock
                                                        forDevice:self.activeDevice.broadcastId
                                                         andBlock:^(BOOL isSuccess, NSUInteger errorCode)
     {
         [self deviceSetingCategory:DSCategoryEventClock didSettingReults:isSuccess errorCode:errorCode];
     }];
}

-(void)saveAlarmClock
{
    //calling methods
    [[LSBluetoothManager defaultManager]  updateAlarmClock:@[self.alarmClock]
                                               isEnableAll:YES
                                                 forDevice:self.activeDevice.broadcastId
                                                  andBlock:^(BOOL isSuccess, NSUInteger code)
     {
         [self deviceSetingCategory:DSCategoryAlarmClock didSettingReults:isSuccess  errorCode:code];
     }];
}

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

@end

