//
//  XbICalendarProcessIncomingTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarProcessIncomingTests : XbICalendarIcsTest
@end

@implementation XbICalendarProcessIncomingTests

- (NSString *)icsFileNameUnderTest
{
    return @"process-incoming";
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
    XCTAssertEqualObjects([vCalendar2 method], @"REQUEST", @"Unexpected method");
    
    XbICVCalendar * vCalendar3 = self.calendars[2];
    XCTAssertEqualObjects([vCalendar3 method], @"REQUEST", @"Unexpected method");
}

- (void)test_events_with_organizer
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqualObjects([[vEvent1 organizer] emailAddress], @"Mailto:bob@cal.softwarestudio.org", @"Unexpected event organizer");
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    XCTAssertEqualObjects([[vEvent2 organizer] emailAddress], @"Mailto:bob@cal.softwarestudio.org", @"Unexpected event organizer");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqualObjects([[vEvent3 organizer] emailAddress], @"Mailto:bob@cal.softwarestudio.org", @"Unexpected event organizer");
}

- (void)test_events_with_start_date
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    [self assertUtcDateString:@"19970701T120000Z"
                isEqualToDate:[vEvent1 dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    [self assertUtcDateString:@"19970701T13000Z"
                isEqualToDate:[vEvent2 dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    [self assertUtcDateString:@"19970701T140000Z"
                isEqualToDate:[vEvent3 dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_events_with_end_date
{
    // TODO: This endDate fails to be parsed.  Why?
    //    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    //    [self assertUtcDateString:@"19970701T1300Z"
    //                isEqualToDate:[vEvent1 dateEnd]
    //           withFailureMessage:@"event dateEnd is incorrect"];
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    [self assertUtcDateString:@"19970701T140000Z"
                isEqualToDate:[vEvent2 dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    [self assertUtcDateString:@"19970701T150000Z"
                isEqualToDate:[vEvent3 dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_events_with_timestamp
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    [self assertUtcDateString:@"19970611T030000Z"
                isEqualToDate:[vEvent1 dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    [self assertUtcDateString:@"19970611T040000Z"
                isEqualToDate:[vEvent2 dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    [self assertUtcDateString:@"19970611T050000Z"
                isEqualToDate:[vEvent3 dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_events_with_summary
{
    // NOTE: Leading space purposefully trimmed.
    
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqualObjects([vEvent1 summary], @"Overlap  1", @"event summary is incorrect");
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    XCTAssertEqualObjects([vEvent2 summary], @"Overlap  2", @"event summary is incorrect");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqualObjects([vEvent3 summary], @"Overlap  3", @"event summary is incorrect");
}

- (void)test_events_with_uid
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqualObjects([vEvent1 UID], @"calsrv.example.com-873970198738703@example.com", @"Unexpected event UID");
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    XCTAssertEqualObjects([vEvent2 UID], @"calsrv.example.com-873970198738704@example.com", @"Unexpected event UID");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqualObjects([vEvent3 UID], @"calsrv.example.com-873970198738705@example.com", @"Unexpected event UID");
}

- (void)test_events_with_sequence
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqual([vEvent1 sequence], @0, @"Unexpected sequence");
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    XCTAssertEqual([vEvent2 sequence], @0, @"Unexpected sequence");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqual([vEvent3 sequence], @0, @"Unexpected sequence");
}

- (void)test_events_with_status
{
    XbICVEvent * vEvent1 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertEqualObjects([vEvent1 status], @"CONFIRMED", @"Unexpected status");
    
    XbICVEvent * vEvent2 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    XCTAssertEqualObjects([vEvent2 status], @"CONFIRMED", @"Unexpected status");
    
    XbICVEvent * vEvent3 = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    XCTAssertEqualObjects([vEvent3 status], @"CONFIRMED", @"Unexpected status");
}

- (void)test_event_with_attendees
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    NSArray * attendees = [vEvent attendees];
    XCTAssertEqual([attendees count], 2, @"Expected 2 attendees");
    
    // First attendee:
    XbICPerson *attendee1 = attendees[0];
    XCTAssertTrue([attendee1 isKindOfClass:[XbICPerson class]], @"First attendee object is not XbICPerson class.");
    NSDictionary *parameters1 = attendee1.parameters;
    
    XCTAssertEqual([attendee1 RSVP], NO, @"Unexpected attendee rsvp");
    XCTAssertEqualObjects([attendee1 name], @"Alice", @"Unexpected attendee common name");
    XCTAssertEqualObjects([attendee1 emailAddress], @"Mailto:alice@cal.softwarestudio.org", @"Unexpected attendee email address");
    XCTAssertEqualObjects(parameters1[@"CUTYPE"], @"INDIVIDUAL", @"Unexpected attendee calendar user type");
    XCTAssertEqualObjects(parameters1[@"ROLE"], @"CHAIR", @"Unexpected attendee role");
    
    // Second attendee:
    XbICPerson *attendee2 = attendees[1];
    XCTAssertTrue([attendee2 isKindOfClass:[XbICPerson class]], @"Second attendee object is not XbICPerson class.");
    NSDictionary *parameters2 = attendee2.parameters;
    
    XCTAssertEqual([attendee2 RSVP], YES, @"Unexpected attendee rsvp");
    XCTAssertEqualObjects([attendee2 name], @"B", @"Unexpected attendee common name");
    XCTAssertEqualObjects([attendee2 emailAddress], @"Mailto:B@example.com", @"Unexpected attendee email address");
    XCTAssertEqualObjects(parameters2[@"CUTYPE"], @"INDIVIDUAL", @"Unexpected attendee calendar user type");
}

@end
