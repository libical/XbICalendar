//
//  XbICalendarIncomingTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/13/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarIncomingTests : XbICalendarIcsTest
@end

@implementation XbICalendarIncomingTests

- (NSString *)icsFileNameUnderTest
{
    return @"incoming";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 15, @"Expected 15 calendars");
}

- (void)test_calendar_methods
{
    XbICVCalendar * vCalendar1 = self.calendars[0];
    XCTAssertEqualObjects([vCalendar1 method], @"REQUEST", @"Unexpected method");
    
    XbICVCalendar * vCalendar5 = self.calendars[4];
    XCTAssertEqualObjects([vCalendar5 method], @"REPLY", @"Unexpected method");
    
    XbICVCalendar * vCalendar11 = self.calendars[10];
    XCTAssertEqualObjects([vCalendar11 method], @"CANCEL", @"Unexpected method");
    
    XbICVCalendar * vCalendar12 = self.calendars[11];
    XCTAssertEqualObjects([vCalendar12 method], @"COUNTER", @"Unexpected method");
    
    XbICVCalendar * vCalendar13 = self.calendars[12];
    XCTAssertEqualObjects([vCalendar13 method], @"PUBLISH", @"Unexpected method");
}

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"Mailto:B@example.com", @"Unexpected event organizer");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970701T100000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_event_with_end_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970701T10300Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_event_with_timestamp
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    [self assertUtcDateString:@"19970610T190000Z"
                isEqualToDate:[vEvent dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_event_with_summary
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    // NOTE: Beginning space from .ics file is purposefully trimmed.
    XCTAssertEqualObjects([vEvent summary], @"Pool party", @"event summary is incorrect");
}

- (void)test_event_with_uid
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent UID], @"calsrv.example.com-873970198738776@example.com", @"Unexpected event UID");
}

- (void)test_event_with_sequence
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqual([vEvent sequence], @2, @"Unexpected sequence");
}

- (void)test_event_with_status
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    
    XCTAssertEqualObjects([vEvent status], @"CONFIRMED", @"Unexpected status");
}

- (void)test_event_with_delegated_attendee
{
    XbICVEvent * vEventWithDelegate = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:5];
    NSArray * attendees = [vEventWithDelegate attendees];
    XCTAssertEqual([attendees count], 1, @"Expected 1 attendee");
    
    XbICProperty *attendeeWithDelegate = attendees[0];
    XCTAssertTrue([attendeeWithDelegate isKindOfClass:[XbICProperty class]], @"Attendee with delegate object is not property class.");
    NSDictionary *parametersForDelegate = attendeeWithDelegate.parameters;
    
    XCTAssertEqualObjects(parametersForDelegate[@"PARTSTAT"], @"DELEGATED", @"Unexpected participation status");
    
    // TODO: Should the (escape) quotations be in property parameter values?
    //  They should propably be stripped out during parse.
    XCTAssertEqualObjects(parametersForDelegate[@"DELEGATED-TO"], @"\"Mailto:C@example.com\"", @"Unexpected delegated to attendee");
    XCTAssertEqualObjects(attendeeWithDelegate.value, @"Mailto:B@example.com", @"Unexpected attendee value");
}

- (void)test_calendar_with_freebusy
{
    XbICVCalendar * vCalendar = self.calendars[14];
    
    NSArray * freeBusies = [vCalendar componentsOfKind:ICAL_VFREEBUSY_COMPONENT];
    XCTAssertEqual([freeBusies count], 1, @"Expected 1 freebusy component");
    
    XbICComponent * freeBusy = freeBusies[0];
    
    NSArray * freeBusyProperties = [freeBusy propertiesOfKind:ICAL_FREEBUSY_PROPERTY];
    XCTAssertEqual([freeBusyProperties count], 7, @"Expected 7 freebusy properties");
    
    XbICProperty * firstProperty = freeBusyProperties[0];
    XCTAssertTrue([firstProperty isKindOfClass:[XbICProperty class]], @"First freebusy is not XbICProperty");
    NSString * firstValue = (NSString *)firstProperty.value;
    XCTAssertTrue([firstValue isKindOfClass:[NSString class]], @"First freebusy value is not NSString");
    
    NSArray * freeBusyValues = [firstValue componentsSeparatedByString:@"/"];
    XCTAssertEqual([freeBusyValues count], 2, @"Expected two values separated by '/' in freebusy");
    
    NSDate * beginDate = [self.utcDateFormatter dateFromString:freeBusyValues[0]];
    NSDate * endDate = [self.utcDateFormatter dateFromString:freeBusyValues[1]];
    XCTAssertNotNil(beginDate, @"Unable to parse begin date of freebusy");
    XCTAssertNotNil(endDate, @"Unable to parse end date of freebusy");
    
    [self assertUtcDateString:@"19980101T180000Z"
                isEqualToDate:beginDate
           withFailureMessage:@"Begin date of freebusy is incorrect"];
    
    [self assertUtcDateString:@"19980101T190000Z"
                isEqualToDate:endDate
           withFailureMessage:@"End date of freebusy is incorrect"];
}

@end
