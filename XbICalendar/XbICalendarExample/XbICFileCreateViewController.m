//
//  XbICFileCreateViewController.m
//  XbICalendar
//
//  Created by Han Chengge on 5/17/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import "XbICFileCreateViewController.h"
#import "ical.h"

@interface XbICFileCreateViewController ()

@end

@implementation XbICFileCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"XbICFile Create";
    
    UIView *dateInputAccessoryView = [[UIView alloc] init];
    
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];
    [dateInputAccessoryView addSubview:self.datePicker];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton addTarget:self action:@selector(donePicker:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:doneButton.tintColor forState:UIControlStateNormal];
    [doneButton setTag:11];
    [dateInputAccessoryView addSubview:doneButton];
    
    [dateInputAccessoryView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.datePicker.frame.size.height + 50)];
    [self.datePicker setFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, self.datePicker.frame.size.height)];
    [doneButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 2, 60, 46)];

    [self.startDateTextField setInputView:dateInputAccessoryView];
    [self.endDateTextField setInputView:dateInputAccessoryView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    for (int i = 1; ; i++) {
        NSString *icsFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Event%d.ics", i]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:icsFile]) {
            self.fileNameTextField.text = [NSString stringWithFormat:@"Event%d", i];
            break;
        }
    }
    
    self.summaryTextField.text = @"";
    self.startDateTextField.text = @"";
    self.endDateTextField.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectedDate:(UIDatePicker *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM dd, yyyy, H:mm a"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    
    if ([self.startDateTextField isFirstResponder]) {
        self.startDateTextField.text = formatedDate;
    }
    else if ([self.endDateTextField isFirstResponder]) {
        self.endDateTextField.text = formatedDate;
    }
}

- (void)donePicker:(UIButton *)sender {
    [self selectedDate:self.datePicker];
    
    if ([self.startDateTextField isFirstResponder]) {
        [self.startDateTextField resignFirstResponder];
    }
    else {
        [self.endDateTextField resignFirstResponder];
    }
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)exitTextEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)onCreate:(id)sender {
    NSString *summaryString = self.summaryTextField.text;
    NSString *startDateString = self.startDateTextField.text;
    NSString *endDateString = self.endDateTextField.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy, H:mm a"];
    
    NSDate *startDate = [dateFormatter dateFromString:startDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    NSString *fileContent = [NSString stringWithFormat:@"BEGIN:VCALENDAR\nVERSION:2.0\nBEGIN:VEVENT\nDTSTART:%@\nDTEND:%@\nSUMMARY:%@\nEND:VEVENT\nEND:VCALENDAR",
                             [self icaltimetypeStringFromDate:startDate],
                             [self icaltimetypeStringFromDate:endDate],
                             summaryString];
    
    NSData *data = [fileContent dataUsingEncoding:NSASCIIStringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *icsFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ics", self.fileNameTextField.text]];
    
    [data writeToFile:icsFile atomically:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.ics file created.", self.fileNameTextField.text] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(NSString *) icaltimetypeStringFromDate:(id) date {
    icaltimetype t = icaltime_null_time();
    if ([date isKindOfClass:[NSDate class]]) {
        unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |NSTimeZoneCalendarUnit ;
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *components = [calendar components:unitFlags fromDate:date];
        t.year =  (int)[components year];
        t.month = (int)[components month];
        t.day =   (int)[components day];
        t.hour =  (int)[components hour];
        t.minute = (int)[components minute];
        t.second = (int)[components second];
        
        t.is_date = NO;
        
        icaltime_set_timezone(&t, icaltimezone_get_utc_timezone());
    }
    else {
        NSLog(@"Error: invalid date format");
    }
    return [NSString stringWithCString: icalvalue_as_ical_string(icalvalue_new_datetime(t)) encoding: NSASCIIStringEncoding];
}

@end
