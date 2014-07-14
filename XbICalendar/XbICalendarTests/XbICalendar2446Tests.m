//
//  XbICalendar2445Tests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/12/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendar2446Tests : XbICalendarIcsTest
@end

@implementation XbICalendar2446Tests

- (NSString *)icsFileNameUnderTest
{
    return @"2446";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 53, @"Expected 53 calendars");
}

- (void)test_calendar_method
{
    XbICVCalendar * vCalendar = self.calendars[0];
    XCTAssertEqualObjects([vCalendar method], @"PUBLISH", @"Unexpected method");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970701T200000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_event_with_end_date
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:1];
    
    [self assertUtcDateString:@"19970701T230000Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_event_with_timestamp
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970611T190000Z"
                isEqualToDate:[vEvent dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_event_with_summary
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent summary], @"ST. PAUL SAINTS -VS- DULUTH-SUPERIOR DUKES", @"event summary is incorrect");
}

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"mailto:a@example.com", @"Unexpected event organizer");
}

- (void)test_event_with_uid
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent UID], @"0981234-1234234-23@example.com", @"Unexpected event UID");
}

- (void)test_event_with_sequence
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:1];
    
    XCTAssertEqual([vEvent sequence], @1, @"Unexpected sequence");
}

- (void)test_event_with_multiline_description
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:3];
    
    XCTAssertEqualObjects([vEvent description], @"MIDWAY STADIUM\\nBig time game. MUST see.\\nExpected duration:2 hours\\n", @"Unexpected description");
}

- (void)test_event_with_status
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:3];
    
    XCTAssertEqualObjects([vEvent status], @"CONFIRMED", @"Unexpected status");
}

- (void)test_event_with_location
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:3];
    
    XCTAssertEqualObjects([vEvent location], @"http://www.midwaystadium.com/", @"Unexpected location");
}

- (void)test_event_with_attendees
{
    XbICVEvent * vEvent = [self eventAtIndex:0 ofCalendarAtIndex:5];
    NSArray * attendees = [vEvent attendees];
    XCTAssertEqual([attendees count], 6, @"Expected 6 attendees");
    
    // Test a few attendees which cover the different parameters:
    
    // First attendee:
    XbICProperty *attendee1 = attendees[0];
    XCTAssertTrue([attendee1 isKindOfClass:[XbICProperty class]], @"First attendee object is not property class.");
    NSDictionary *parameters1 = attendee1.parameters;
    
    XCTAssertEqualObjects(parameters1[@"ROLE"], @"CHAIR", @"Unexpected attendee role");
    XCTAssertEqualObjects(parameters1[@"PARTSTAT"], @"ACCEPTED", @"Unexpected attendee participation status");
    XCTAssertEqualObjects(parameters1[@"CN"], @"BIG A", @"Unexpected attendee common name");
    XCTAssertEqualObjects(attendee1.value, @"Mailto:A@example.com", @"Unexpected attendee value");
    
    // Second attendee:
    XbICProperty *attendee2 = attendees[1];
    XCTAssertTrue([attendee2 isKindOfClass:[XbICProperty class]], @"Second attendee object is not property class.");
    NSDictionary *parameters2 = attendee2.parameters;
    
    XCTAssertEqualObjects(parameters2[@"RSVP"], @"TRUE", @"Unexpected attendee rsvp");
    XCTAssertEqualObjects(parameters2[@"CUTYPE"], @"INDIVIDUAL", @"Unexpected attendee calendar user type");
    XCTAssertEqualObjects(parameters2[@"CN"], @"B", @"Unexpected attendee common name");
    XCTAssertEqualObjects(attendee2.value, @"Mailto:B@example.com", @"Unexpected attendee value");
    
    // Last attendee:
    XbICProperty *attendee6 = attendees[5];
    XCTAssertTrue([attendee6 isKindOfClass:[XbICProperty class]], @"Sixth attendee object is not property class.");
    NSDictionary *parameters6 = attendee6.parameters;
    
    XCTAssertEqualObjects(parameters6[@"ROLE"], @"NON-PARTICIPANT", @"Unexpected attendee role");
    XCTAssertEqualObjects(parameters6[@"RSVP"], @"FALSE", @"Unexpected attendee rsvp");
    XCTAssertEqualObjects(attendee6.value, @"Mailto:E@example.com", @"Unexpected attendee value");
}

@end
