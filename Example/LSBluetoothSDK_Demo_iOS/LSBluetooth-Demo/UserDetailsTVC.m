
//
//  UserDetailsTVC.m
//  LsBluetooth-Test
//
//  Created by lifesense on 15/8/14.
//  Copyright (c) 2015年 com.lifesense. All rights reserved.
//

#import "UserDetailsTVC.h"
#import "DeviceUser.h"
#import "LSDatabaseManager.h"
#import "FatScaleSettingTVC.h"
#import "PedometerSettingTVC.h"
#import "DataFormatConverter.h"
#import "UserNameTableViewCell.h"
#import <LSDeviceBluetooth/LSDeviceBluetooth.h>


#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value

#define KCellDataKey   @"cellData"

// keep track of which rows have date cells
#define kDateStartRow   2


static NSString *kDateCellID = @"dateCell";
static NSString *kDatePickerID = @"datePicker";
static NSString *kOtherCell = @"otherCell";
static NSString *kUserNameCell = @"UserNameTableViewCell";
static NSString *kFatScaleSettingCell = @"fatScaleSettingCell";
static NSString *kPedometerSettingCell = @"pedometerSettingCell";

#pragma mark -

@interface UserDetailsTVC ()<UITextFieldDelegate,UIActionSheetDelegate,LSDebugMessageDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

// this button appears only when the date picker is shown (iOS 6.1.x or earlier)
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic,strong) NSArray *athleteLevelArray;
@property (nonatomic,strong)DeviceUser *currentDeviceUser;
@property (nonatomic,strong)UITableViewCell *currentSelectCell;

@property (nonatomic,strong)UILabel *userNameLabel;

@end


#pragma mark -

@implementation UserDetailsTVC

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    LSDatabaseManager *databaseManager=[LSDatabaseManager defaultManager];
    self.currentDeviceUser=[[databaseManager allObjectForEntityForName:@"DeviceUser" predicate:nil] lastObject];
    
    // setup our data source
    self.dataArray = [self userDetailsDataSource];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
   
   
    [self.dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
   //    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
//    Add "-all_load"、"-ObjC" in other linker flags,like this
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
    
    [self.pickerView setMaximumDate:[NSDate date]];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

-(BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - table view data source

-(NSArray *)userDetailsDataSource
{
    NSMutableDictionary *nameItem = [@{ kTitleKey : @"Name" ,KCellDataKey :self.currentDeviceUser.name} mutableCopy];
    
    NSMutableDictionary *genderItem= [@{ kTitleKey : @"Gender" ,KCellDataKey:self.currentDeviceUser.gender} mutableCopy];
    
    NSMutableDictionary *birthdayItem = [@{ kTitleKey : @"Birthday",
                                            kDateKey : self.currentDeviceUser.birthday } mutableCopy];
    
    NSNumber *heightValue=self.currentDeviceUser.height;
    NSString *heightStringValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:[heightValue doubleValue]];
    
    NSMutableDictionary *heightItem = [@{ kTitleKey : @"Height",KCellDataKey: heightStringValue} mutableCopy];
    
    
    NSNumber *weightValue=self.currentDeviceUser.weight;
    NSString *weightStringValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:[weightValue doubleValue]];
    
    NSMutableDictionary *weightItem = [@{ kTitleKey : @"Weight",KCellDataKey:weightStringValue } mutableCopy];

    NSMutableDictionary *athleteLevelItem = [@{ kTitleKey : @"Athlete Level" ,KCellDataKey:self.currentDeviceUser.athleteLevel} mutableCopy];

    return @[nameItem, genderItem, birthdayItem,heightItem,weightItem,athleteLevelItem];
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
NSUInteger DeviceSystemMajorVersion()
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _deviceSystemMajorVersion =
        [[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] integerValue];
    });
    
    return _deviceSystemMajorVersion;
}

#define EMBEDDED_DATE_PICKER (DeviceSystemMajorVersion() >= 7)

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
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
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
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        if (targetedDatePicker != nil)
        {
            // we found a UIDatePicker in this cell, so update it's date value
            //
            NSDictionary *itemData = self.dataArray[self.datePickerIndexPath.row - 1];
            [targetedDatePicker setDate:[itemData valueForKey:kDateKey] animated:NO];
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
    
    if ((indexPath.row == kDateStartRow))
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
    if(section==0)
    {
        if ([self hasInlineDatePicker])
        {
            // we have a date picker, so allow for it in the number of rows in this section
            numRows = self.dataArray.count;
            ++numRows;
        }
        else
        {
            numRows=self.dataArray.count;}
    }
    else
    {
        numRows=1;
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
    if ([self indexPathHasPicker:indexPath])
    {
        cellID = kDatePickerID;
    }
    else if ([self indexPathHasDate:indexPath])
    {
      
        cellID = kDateCellID;
    }


    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            cellID=kUserNameCell;
        }
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
         cell.detailTextLabel.textAlignment=NSTextAlignmentLeft;
        // if we have a date picker open whose cell is above the cell we want to update,
        // then we have one more cell than the model allows
        //
        NSInteger modelRow = indexPath.row;
        if (self.datePickerIndexPath != nil && self.datePickerIndexPath.row <= indexPath.row)
        {
            modelRow--;
        }
    
        NSDictionary *itemData = self.dataArray[modelRow];
        
        // proceed to configure our cell
        if ([cellID isEqualToString:kDateCellID])
        {
            cell.textLabel.text = [itemData valueForKey:kTitleKey];
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[itemData valueForKey:kDateKey]];
        }
        else if ([cellID isEqualToString:kUserNameCell])
        {
            
            UserNameTableViewCell *cellView=nil;
             NSString *identifier=@"UserNameTableViewCell";
            cellView =(UserNameTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
            NSArray *nib=[[NSBundle mainBundle] loadNibNamed:@"UserNameCell" owner:self options:nil];
            cellView=[nib objectAtIndex:0];
            
            NSString *cellValue=[NSString stringWithFormat:@"%@",[itemData valueForKey:KCellDataKey]];
            
            cellView.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            self.userNameLabel=cellView.userNameLabel;
            self.userNameLabel.text=cellValue;
            cell=cellView;
        }
      
        else if ([cellID isEqualToString:kOtherCell] )
        {
            NSString *titleStr=[itemData valueForKey:kTitleKey];
        
            cell.textLabel.text = titleStr ;
        
            NSString *cellValue=[NSString stringWithFormat:@"%@",[itemData valueForKey:KCellDataKey]];
            
            cell.detailTextLabel.textAlignment=NSTextAlignmentLeft;
            cell.detailTextLabel.text = cellValue;
            [cell.textLabel sizeToFit];
            [cell.detailTextLabel sizeToFit];
        }
        
         return cell;
    }
    
    else
    {
        cellID=kFatScaleSettingCell;
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        
        cell.accessoryType=UITableViewCellAccessoryDetailButton;
        cell.textLabel.text=@"Fat Scale Setting";
        cell.detailTextLabel.text=@"";
        return cell;
    }
//    else
//    {
//        cellID=kPedometerSettingCell;
//        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
//
//        cell.accessoryType=UITableViewCellAccessoryDetailButton;
//        cell.textLabel.text=@"Pedometer Setting";
//        cell.detailTextLabel.text=@"";
//        return cell;
//    }
    
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

/*! Reveals the UIDatePicker as an external slide-in view, iOS 6.1.x and earlier, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath used to display the UIDatePicker.
 */
- (void)displayExternalDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first update the date picker's date value according to our model
    NSDictionary *itemData = self.dataArray[indexPath.row];
    [self.pickerView setDate:[itemData valueForKey:kDateKey] animated:YES];
    
    // the date picker might already be showing, so don't add it to our view
    if (self.pickerView.superview == nil)
    {
        CGRect startFrame = self.pickerView.frame;
        CGRect endFrame = self.pickerView.frame;
        
        // the start position is below the bottom of the visible frame
        startFrame.origin.y = CGRectGetHeight(self.view.frame);
        
        // the end position is slid up by the height of the view
        endFrame.origin.y = startFrame.origin.y - CGRectGetHeight(endFrame);
        
        self.pickerView.frame = startFrame;
        
        [self.view addSubview:self.pickerView];
        
        // animate the date picker into view
        [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = endFrame; }
                         completion:^(BOOL finished) {
                             // add the "Done" button to the nav bar
                             self.navigationItem.rightBarButtonItem = self.doneButton;
                         }];
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentSelectCell=[tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section==0)
    {
        if (self.currentSelectCell.reuseIdentifier == kDateCellID)
        {
            if (EMBEDDED_DATE_PICKER)
            {
                 [self displayInlineDatePickerForRowAtIndexPath:indexPath];
            }
            else
            {
                [self displayExternalDatePickerForRowAtIndexPath:indexPath];
            }
        }
        else
        {
            if(indexPath.row==0)
            {
                [self showCharacterInputAlertView];
            }
            else if (indexPath.row==1 )
            {
                if([self.currentSelectCell.detailTextLabel.text isEqualToString:@"Male"])
                {
                self.currentSelectCell.detailTextLabel.text=@"Female";
                    self.currentDeviceUser.gender=@"Female";
                }
                else
                {
                    self.currentSelectCell.detailTextLabel.text=@"Male";
                    self.currentDeviceUser.gender=@"Male";
                }
            }
            else if (indexPath.row==3)
            {
                [self showNumberInputAlertView:@"User Height" message:@"Enter your height value(unit for 'm')"];
            }
            else if (indexPath.row==4)
            {
               [self showNumberInputAlertView:@"User Weight" message:@"Enter your weight value(unit for 'kg')"];
            }
            else if (indexPath.row==5)
            {
                [self showAthleteLevelSettingView];
            }
        }
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
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
    NSMutableDictionary *itemData = self.dataArray[targetedCellIndexPath.row];
    [itemData setValue:targetedDatePicker.date forKey:kDateKey];
    
    // update the cell's date string
    cell.detailTextLabel.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    
    //update the birthday to user info
    
    self.currentDeviceUser.birthday=targetedDatePicker.date;
    
}


/*! User chose to finish using the UIDatePicker by pressing the "Done" button
 (used only for "non-inline" date picker, iOS 6.1.x or earlier)
 
 @param sender The sender for this action: The "Done" UIBarButtonItem
 */
- (IBAction)doneAction:(id)sender
{
    CGRect pickerFrame = self.pickerView.frame;
    pickerFrame.origin.y = CGRectGetHeight(self.view.frame);
    
    // animate the date picker out of view
    [UIView animateWithDuration:kPickerAnimationDuration animations: ^{ self.pickerView.frame = pickerFrame; }
                     completion:^(BOOL finished) {
                         [self.pickerView removeFromSuperview];
                     }];
    
    // remove the "Done" button in the navigation bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table cell
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSString *selectValue=[self.athleteLevelArray objectAtIndex:buttonIndex];
    self.currentSelectCell.detailTextLabel.text=selectValue;
    self.currentDeviceUser.athleteLevel=[NSNumber numberWithLongLong:[selectValue longLongValue]];
}


#pragma mark -UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *value=[textField text];
    if(value.length)
    {
        NSIndexPath *currentIndexPath=[self.tableView indexPathForCell:self.currentSelectCell];
        if(currentIndexPath.row==0)
        {
            if([self isWebSocketUrl:value])
            {
                self.userNameLabel.text=value;
                NSString *websocketUrl=[NSString stringWithFormat:@"ws://%@",value];
                //init websocket
                return ;
            }
            else
            {
                if(value.length>16)
                {
                    value=[value substringToIndex:16];
                }
                NSLog(@"user name length is %ld ",(unsigned long)value.length);
                self.userNameLabel.text=value;
                self.currentDeviceUser.name=value;
            }
        }
        else if (currentIndexPath.row==3)
        {
            if([value doubleValue]>2.5)
            {
                self.currentDeviceUser.height=[NSNumber numberWithDouble:2.5];
            }
            else
            {
                self.currentDeviceUser.height=[NSNumber numberWithDouble:[value doubleValue]];
            }
            
            NSNumber *heightValue=self.currentDeviceUser.height;
            NSString *heightStringValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:[heightValue doubleValue]];
            
            self.currentSelectCell.detailTextLabel.text=heightStringValue;
            
        }
        else if (currentIndexPath.row==4)
        {
            if ([value doubleValue]>300)
            {
                self.currentDeviceUser.weight=[NSNumber numberWithDouble:300];
            }
            else
            {
                self.currentDeviceUser.weight=[NSNumber numberWithDouble:[value doubleValue]];
                
            }
            
            NSNumber *weightValue=self.currentDeviceUser.weight;
            NSString *weightStringValue=[DataFormatConverter doubleValueWithTwoDecimalFormat:[weightValue doubleValue]];
            self.currentSelectCell.detailTextLabel.text=weightStringValue;
            
            
        }
    }
    
}


#pragma mark - user details setting

-(void)showCharacterInputAlertView
{
    
    UIAlertView *userNameAlertView=[[UIAlertView alloc] initWithTitle:@"User Name" message:@"Enter your user name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    userNameAlertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *userNameTextField=[userNameAlertView textFieldAtIndex:0];
    userNameTextField.delegate=self;
    userNameTextField.keyboardType=UIKeyboardTypeNamePhonePad;
    userNameTextField.text=self.currentDeviceUser.name;
    [userNameAlertView show];
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


-(NSArray *)athleteLevelArray
{
    return @[@"0",@"1",@"2",@"3",@"4",@"5"];
}

-(void)showAthleteLevelSettingView
{
    
    NSUInteger maxUserNumber=[self.athleteLevelArray count];
    if(maxUserNumber)
    {
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"Select Athlete Level"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:nil, nil];
        
        
        NSString *title=nil;
        
        for(int i=0;i<maxUserNumber;i++)
        {
            title=[NSString stringWithFormat:@"Level : %d",i];
            [actionSheet addButtonWithTitle:title];
        }
        
        actionSheet.actionSheetStyle=UIActionSheetStyleDefault;
        [actionSheet showInView:self.view];
    }
}

#pragma mark - Send Debug Message To WebSocket Server

/**
 * 判断字符串是否符合websocket url格式
 * eg. 192.168.220.98:8989
 */
-(BOOL)isWebSocketUrl:(NSString *)str
{
    NSString *emailRegex = @"[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+\\:[0-9]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:str];
}


@end

