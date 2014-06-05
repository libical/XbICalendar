//
//  XbICViewController.m
//  XbICalendar
//
//  Created by Andrew Halls on 5/26/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "XbICViewController.h"
#import "XBiCalendar.h"

@interface XbICViewController ()
@property (nonatomic, weak) IBOutlet UITextView * descriptionTextView;
@property (nonatomic, weak) IBOutlet UILabel * summaryLabel;
@property (nonatomic, weak) IBOutlet UILabel * startLabel;
@property (nonatomic, weak) IBOutlet UILabel *   endLabel;

@end

@implementation XbICViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.fileName;
    
    NSString *path = [[NSBundle mainBundle] resourcePath];
    NSString *pathname = [NSString stringWithFormat:@"%@/%@", path, self.fileName];

    XbICVCalendar * vCalendar = [XbICVCalendar vCalendarFromFile:pathname];
    if (vCalendar) {
        NSArray * events = [vCalendar subcomponents];
        if (events.count > 0) {
            XbICVEvent * event = events[0];
            self.summaryLabel.text = [event summary];
            self.descriptionTextView.text = [event description];
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            [df setDateStyle: NSDateFormatterMediumStyle];
            [df setTimeStyle:NSDateFormatterShortStyle];
            self.startLabel.text = [df stringFromDate:[event dateStart]];
            self.endLabel.text = [df stringFromDate:[event dateEnd]];
            
        }
    }
    
    
}



@end
