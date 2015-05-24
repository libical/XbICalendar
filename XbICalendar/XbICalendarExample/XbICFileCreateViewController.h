//
//  XbICFileCreateViewController.h
//  XbICalendar
//
//  Created by Han Chengge on 5/17/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XbICFileCreateViewController : UIViewController

@property UIDatePicker *datePicker;
@property NSDate *startDate;
@property NSDate *endDate;

@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *summaryTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

- (IBAction)exitTextEditing:(id)sender;
- (IBAction)onCreate:(id)sender;

@end
