//
//  XbICalendarRestrictionTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarRestrictionTests : XbICalendarIcsTest

@end

@implementation XbICalendarRestrictionTests

- (NSString *)icsFileNameUnderTest
{
    return @"restriction";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 3, @"Expected 3 calendars");
}

- (void)test_calendar_method
{
    XbICVCalendar * vCalendar1 = self.calendars[0];
    XCTAssertEqualObjects([vCalendar1 method], @"REQUEST", @"Unexpected method");
    
    XbICVCalendar * vCalendar2 = self.calendars[1];
    XCTAssertEqualObjects([vCalendar2 method], @"PUBLISHca", @"Unexpected method");
    
    XbICVCalendar * vCalendar3 = self.calendars[2];
    XCTAssertEqualObjects([vCalendar3 method], @"REPLY", @"Unexpected method");
}

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"MAILTO:A@Example.com", @"Unexpected event organizer");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970903T163000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

// TODO: These dates cannot be parsed.  Why?

//- (void)test_event_with_end_date
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
//    
//    [self assertUtcDateString:@"19970903T190000Z"
//                isEqualToDate:[vEvent dateEnd]
//           withFailureMessage:@"event dateEnd is incorrect"];
//}
//
//- (void)test_event_with_timestamp
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"19970901T1300Z"
//                isEqualToDate:[vEvent dateStamp]
//           withFailureMessage:@"event dateStamp is incorrect"];
//}

- (void)test_event_with_summary
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent summary], @"Annual Employee Review", @"event summary is incorrect");
}

- (void)test_events_with_uid
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqualObjects([vEvent1 UID], @"19970901T130000Z-123401@host.com", @"Unexpected event UID");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqualObjects([vEvent3 UID], @"calsrv.example.com-873970198738777@example.com", @"Unexpected event UID");
}

- (void)test_event_with_multiple_sequences
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    NSArray * expected = @[@0,@1];
    XCTAssertEqualObjects([vEvent sequences], expected, @"Unexpected Sequence");
}

- (void)test_event_with_status
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent status], @"TENTATIVE", @"Unexpected status");
}

@end
