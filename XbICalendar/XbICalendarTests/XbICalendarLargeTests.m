//
//  XbICalendarLargeTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/18/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarLargeTests : XbICalendarIcsTest
@end

@implementation XbICalendarLargeTests

- (NSString *)icsFileNameUnderTest
{
    return @"large";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertEqual([self.calendars count], 1788, @"Expected 1788 calendars");
}

- (void)test_calendar_methods
{
    XbICVCalendar * vCalendar3 = self.calendars[2];
    XCTAssertEqualObjects([vCalendar3 method], @"PUBLISH", @"Unexpected method");
    
    XbICVCalendar * vCalendar9 = self.calendars[8];
    XCTAssertEqualObjects([vCalendar9 method], @"CANCEL", @"Unexpected method");
}

#pragma mark - Event

- (void)test_event_with_organizer
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:6];
    
    XCTAssertEqualObjects([[vEvent organizer] emailAddress], @"mailto:a@example.com", @"Unexpected event organizer");
}

- (void)test_event_with_start_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:6];
    
    [self assertUtcDateString:@"19970701T200000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
}

- (void)test_event_with_end_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:7];
    
    [self assertUtcDateString:@"19970701T230000Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_event_with_timestamp
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:6];
    
    [self assertUtcDateString:@"19970611T190000Z"
                isEqualToDate:[vEvent dateStamp]
           withFailureMessage:@"event dateStamp is incorrect"];
}

- (void)test_event_with_created_date
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    [self assertUtcDateString:@"19980309T130000Z"
                isEqualToDate:[vEvent dateCreated]
           withFailureMessage:@"event dateCreated is incorrect"];
}

- (void)test_event_with_location
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    XCTAssertEqualObjects([vEvent location], @"1CP Conference Room 4350", @"event location incorrect");
}

- (void)test_event_with_description
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:2];
    
    // NOTE: the \n is also in the .ics file
    XCTAssertEqualObjects([vEvent description], @"Discuss how we can test c&s interoperability\\nusing iCalendar and other IETF standards.", @"event description incorrect");
}

- (void)test_event_with_summary
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    XCTAssertEqualObjects([vEvent summary], @"XYZ Project Review", @"event summary is incorrect");
}

- (void)test_event_with_uid
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    
    XCTAssertEqualObjects([vEvent UID], @"guid-1.host1.com", @"Unexpected event UID");
}

- (void)test_event_with_sequence
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:7];
    
    XCTAssertEqual([vEvent sequence], @1, @"Unexpected sequence");
}

- (void)test_event_with_status
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:13];

    XCTAssertEqualObjects([vEvent status], @"CONFIRMED", @"Unexpected status");
}

#pragma mark - Person

- (void)test_person_with_rsvp
{
    XbICVEvent * vEventWithAttendee = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:1];
    NSArray * attendees = [vEventWithAttendee attendees];
    XCTAssertEqual([attendees count], 1, @"Expected 1 attendee");
    
    XbICPerson *attendee = attendees[0];
    XCTAssertTrue([attendee isKindOfClass:[XbICPerson class]], @"Attendee is not XbICPerson.");
    NSDictionary *parameters = attendee.parameters;
    
    XCTAssertTrue([attendee RSVP], @"Unexpected RSVP");
    XCTAssertEqualObjects(parameters[@"ROLE"], @"REQ-PARTICIPANT", @"Unexpected ROLE for attendee");
    XCTAssertEqualObjects(parameters[@"CUTYPE"], @"GROUP", @"Unexpected attendee calendar user type");
    XCTAssertEqualObjects([attendee emailAddress], @"MAILTO:employee-A@host.com", @"Unexpected attendee email address");
}

- (void)test_person_with_cn
{
    XbICVEvent * vEventWithAttendee = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:11];
    NSArray * attendees = [vEventWithAttendee attendees];
    XCTAssertTrue([attendees count] > 3, @"Expected 3 or more attendees");
    
    XbICPerson *attendee = attendees[3];
    XCTAssertTrue([attendee isKindOfClass:[XbICPerson class]], @"Attendee with delegate object is not XbICPerson.");
    NSDictionary *parameters = attendee.parameters;
    
    XCTAssertTrue([attendee RSVP], @"Unexpected RSVP");
    XCTAssertEqualObjects([attendee name], @"Hal", @"Unexpected attendee common name");
    XCTAssertEqualObjects(parameters[@"CUTYPE"], @"INDIVIDUAL", @"Unexpected delegated to attendee");
    XCTAssertEqualObjects([attendee emailAddress], @"Mailto:D@example.com", @"Unexpected attendee email address");
}

#pragma mark - Components which don't have a XbIC* class

- (void)test_freebusy_with_organizer
{
    XbICComponent * freeBusy = [self componentAtIndex:0 kind:ICAL_VFREEBUSY_COMPONENT ofCalendarAtIndex:1787];
    
    NSArray * organizerProperties = [freeBusy propertiesOfKind:ICAL_ORGANIZER_PROPERTY];
    XCTAssertEqual([organizerProperties count], 1, @"Expected 1 organizer property");
    
    XbICProperty * organizer = organizerProperties[0];
    XCTAssertTrue([organizer isKindOfClass:[XbICProperty class]], @"Freebusy organizer is not XbICProperty");
    XCTAssertEqualObjects(organizer.value, @"MAILTO:jsmith@host.com", @"Freebusy organizer is incorrect");
}

- (void)test_freebusy_with_url
{
    XbICComponent * freeBusy = [self componentAtIndex:0 kind:ICAL_VFREEBUSY_COMPONENT ofCalendarAtIndex:1787];
    
    NSArray * urlProperties = [freeBusy propertiesOfKind:ICAL_URL_PROPERTY];
    XCTAssertEqual([urlProperties count], 1, @"Expected 1 url property");
    
    XbICProperty * url = urlProperties[0];
    XCTAssertTrue([url isKindOfClass:[XbICProperty class]], @"Freebusy URL is not XbICProperty");
    XCTAssertEqualObjects(url.value, @"http://www.host.com/calendar/busytime/jsmith.ifb", @"Freebusy URL is incorrect");
}

- (void)test_freebusy_with_start_date
{
    XbICComponent * freeBusy = [self componentAtIndex:0 kind:ICAL_VFREEBUSY_COMPONENT ofCalendarAtIndex:1787];
    
    NSArray * dateProperties = [freeBusy propertiesOfKind:ICAL_DTSTART_PROPERTY];
    XCTAssertEqual([dateProperties count], 1, @"Expected 1 DTSTART property");
    
    XbICProperty * date = dateProperties[0];
    XCTAssertTrue([date isKindOfClass:[XbICProperty class]], @"Freebusy DTSTART is not XbICProperty");
    XCTAssertTrue([date.value isKindOfClass:[NSDate class]], @"Freebusy DTSTART value is not NSDate");
    
    [self assertUtcDateString:@"19980313T141711Z"
                isEqualToDate:(NSDate *)date.value
           withFailureMessage:@"Freebusy DTSTART is incorrect"];
}

- (void)test_freebusy_with_end_date
{
    XbICComponent * freeBusy = [self componentAtIndex:0 kind:ICAL_VFREEBUSY_COMPONENT ofCalendarAtIndex:1787];
    
    NSArray * dateProperties = [freeBusy propertiesOfKind:ICAL_DTEND_PROPERTY];
    XCTAssertEqual([dateProperties count], 1, @"Expected 1 DTEND property");
    
    XbICProperty * date = dateProperties[0];
    XCTAssertTrue([date isKindOfClass:[XbICProperty class]], @"Freebusy DTEND is not XbICProperty");
    XCTAssertTrue([date.value isKindOfClass:[NSDate class]], @"Freebusy DTEND value is not NSDate");
    
    [self assertUtcDateString:@"19980410T141711Z"
                isEqualToDate:(NSDate *)date.value
           withFailureMessage:@"Freebusy DTEND is incorrect"];
}

@end
