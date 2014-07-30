//
//  XbICalendarInviteWriteTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarInviteWriteTests : XbICalendarIcsTest
@end

@implementation XbICalendarInviteWriteTests

-(BOOL) isWritingFiles {
    return YES;
}

- (NSString *)icsFileNameUnderTest
{
    return @"invite";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 1, @"Expected 1 calendars");
}

- (void)test_writing_calendar {
    XbICFile * file = [XbICFile fileWithPathname:self.filePathForTemporaryDirectoryICSFileName];
    [file writeVCalendar:self.calendars[0]];
    
    XbICVCalendar * calendarFromFile = (XbICVCalendar *) [file read];
    
    XCTAssert( [calendarFromFile isEqual:self.calendars[0]], @"Compare Calendars");
    
}

//- (void)test_calendar_helper_method
//{
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString *path = [bundle pathForResource:@"invite" ofType:@"ics"];
//    
//    XbICVCalendar * vCalendar =  [XbICVCalendar vCalendarFromFile:path];
//    XCTAssertNotNil(vCalendar, @"Initialization");
//}
//
//- (void)test_calendar_method
//{
//    XbICVCalendar * vCalendar = self.calendars[0];
//    XCTAssertEqualObjects([vCalendar method], @"REQUEST", @"Unexpected method");
//}
//
//- (void)test_event_count
//{
//    XbICVCalendar * vCalendar = self.calendars[0];
//    NSArray * events = [vCalendar componentsOfKind:ICAL_VEVENT_COMPONENT];
//    
//    XCTAssertEqual(events.count, 1, @"Expecting a single event");
//}
//
//- (void)test_event_with_location
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertEqualObjects([vEvent location], @"Team Room 2A", @"event location is incorrect");
//}
//
//- (void)test_event_with_start_date
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"20140502T160000Z"
//                isEqualToDate:[vEvent dateStart]
//           withFailureMessage:@"event dateStart is incorrect"];
//}
//
//- (void)test_event_with_end_date
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"20140502T170000Z"
//                isEqualToDate:[vEvent dateEnd]
//           withFailureMessage:@"event dateEnd is incorrect"];
//}
//
//- (void)test_event_with_timestamp
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"20140501T205541Z"
//                isEqualToDate:[vEvent dateStamp]
//           withFailureMessage:@"event dateStamp is incorrect"];
//}
//
//- (void)test_event_with_last_modified_date
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"20140501T205540Z"
//                isEqualToDate:[vEvent dateLastModified]
//           withFailureMessage:@"event dateLastModified is incorrect"];
//}
//
//- (void)test_event_with_created_date
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    [self assertUtcDateString:@"20140501T205317Z"
//                isEqualToDate:[vEvent dateCreated]
//           withFailureMessage:@"event dateCreated is incorrect"];
//}
//
//- (void)test_event_with_summary
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertEqualObjects([vEvent summary], @"Test Event", @"event summary is incorrect");
//}
//
//- (void)test_event_with_uid
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertEqualObjects([vEvent UID], @"rdfu8eaik1ss1tc3t725ppijlo@google.com", @"Unexpected event UID");
//}
//
//- (void)test_event_with_sequence
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertEqual([vEvent sequence], @0, @"Unexpected sequence");
//}
//
//- (void)test_event_with_status
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertEqualObjects([vEvent status], @"CONFIRMED", @"Unexpected status");
//}
//
//- (void)test_event_with_description
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XCTAssertTrue([[vEvent description] isEqualToString:@"View your event at http://www.google.com/calendar/event?action="
//                   "VIEW&eid=cmRmdThlYWlrMXNzMXRjM3Q3MjVwcGlqbG8gYWhhbGxzQGdhZ2dsZS5uZXQ&tok=MT"
//                   "kjYW5kcmV3QGdhbHRzb2Z0LmNvbTUwMjM5OTI1MTk0NzQyMWFlNDA5OGMzZjNmODIyMzdhNjhiM"
//                   "TZmMWI&ctz=America/Denver&hl=en." ], @"" );
//}
//
//- (void)test_event_with_organizer
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    XbICPerson * organizer = [vEvent organizer];
//    XCTAssertNotNil(organizer, @"Expected organizer");
//    XCTAssertTrue([organizer isKindOfClass:[XbICPerson class]], @"Organizer is not XbICPerson");
//    XCTAssertTrue([((NSString *)[organizer value]) isEqualToString: @"mailto:andrew@galtsoft.com"], @"Organizer value is incorrect");
//    XCTAssertTrue([[organizer name] isEqualToString: @"Andrew Halls"], @"Organizer name is incorrect");
//}
//
//- (void)test_event_with_attendees
//{
//    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
//    
//    NSArray * attendees = [vEvent attendees];
//    XCTAssertEqual(attendees.count, 3, @"Expected 3 attendees");
//
//    XbICPerson * attendee1 = attendees[0];
//    XCTAssertTrue([attendee1 isKindOfClass:[XbICPerson class]], @"First attendee is not XbICPerson");
//    XCTAssertTrue([((NSString *)[attendee1 value]) isEqualToString: @"mailto:andrewhalls.iphone@gmail.com"], @"Attendee value is incorrect");
//    XCTAssertTrue([[attendee1 name] isEqualToString: @"Andrew Halls"], @"Attendee name is incorrect");
//    XCTAssertTrue([attendee1 RSVP], @"Attendee RSVP is incorrect");
//}

@end
