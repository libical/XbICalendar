//
//  XbICalendar2445Tests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendar2445Tests : XbICalendarIcsTest
@end

@implementation XbICalendar2445Tests

- (NSString *)icsFileNameUnderTest
{
    return @"2445";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertEqual([self.calendars count], 6, @"Expected 6 calendars");
}

- (void)test_calendar_method
{
    XbICVCalendar * vCalendar = self.calendars[2];
    XCTAssertEqualObjects([vCalendar method], @"PUBLISH", @"Unexpected method");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970714T170000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_event_with_end_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970715T035959Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_event_with_timestamp
{
    XCTAssertTrue([self.events count] > 0, @"Expected top level events");
    XbICVEvent * vEvent = self.events[0];
    
    [self assertUtcDateString:@"19970901T130000Z"
                isEqualToDate:[vEvent dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_event_with_summary
{
    XCTAssertTrue([self.events count] >= 2, @"Expected top level events");
    XbICVEvent * vEvent = self.events[1];
    
    XCTAssertEqualObjects([vEvent summary], @"Laurel is in sensitivity awareness class.", @"event summary is incorrect");
}

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"MAILTO:jdoe@host1.com", @"Unexpected event organizer");
}

- (void)test_event_with_uid
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([vEvent UID], @"uid3@host1.com", @"Unexpected event UID");
}

- (void)test_event_with_sequence
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqual([vEvent sequence], @0, @"Unexpected sequence");
}

- (void)test_event_with_multiline_description
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([vEvent description], @"Discuss how we can test c&s interoperability\\nusing iCalendar and other IETF standards.", @"Unexpected description");
}

- (void)test_event_with_location
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    XCTAssertEqualObjects([vEvent location], @"LDB Lobby", @"Unexpected location");
}

@end
