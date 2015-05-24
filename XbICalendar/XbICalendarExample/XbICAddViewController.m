//
//  XbICAddViewController.m
//  XbICalendar
//
//  Created by Han Chengge on 5/22/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import "XbICAddViewController.h"
#import "XBiCalendar.h"
#import <EventKitUI/EventKitUI.h>

@interface XbICAddViewController ()

@end

@implementation XbICAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.fileName;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *icsFilePath = [documentsDirectory stringByAppendingPathComponent:self.fileName];
    
    XbICVCalendar *vCalendar = [XbICVCalendar vCalendarFromFile:icsFilePath];
    if (vCalendar) {
        NSArray *events = [vCalendar subcomponents];
        if (events.count > 0) {
            XbICVEvent *event = events[0];
            
            self.summary = [event summary];
            self.summaryLabel.text = self.summary;
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateStyle: NSDateFormatterMediumStyle];
            [df setTimeStyle:NSDateFormatterShortStyle];
            
            self.startDate = [event dateStart];
            self.startLabel.text = [df stringFromDate:self.startDate];
            
            self.endDate = [event dateEnd];
            self.endLabel.text = [df stringFromDate:self.endDate];
        }
    }
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

- (IBAction)addToCalendar:(id)sender {
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            return;
        }
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = self.summaryLabel.text;
        event.startDate = self.startDate;
        event.endDate = self.endDate;
        event.calendar = [store defaultCalendarForNewEvents];
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Added event to calendar" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
