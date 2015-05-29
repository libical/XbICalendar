//
//  XbICAddViewController.h
//  XbICalendar
//
//  Created by Han Chengge on 5/22/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XbICAddViewController : UIViewController

@property (nonatomic, strong) NSString *fileName;
@property NSString *summary;
@property NSDate *startDate;
@property NSDate *endDate;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;

- (IBAction)addToCalendar:(id)sender;

@end
