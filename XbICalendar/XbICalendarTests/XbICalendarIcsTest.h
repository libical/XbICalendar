//
//  XbICalendarTest.h
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/12/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendar.h"

/*
 'XbICalendarIcsTest' assists in loading a .ics file and testing its components.
 Subclass this class and provide the icsFileNameUnderTest method to test a file.
 
 The idea is NOT to test every component in each .ics file.  Rather, we are trying
 to get a good sampling of each file and then test any aspect which makes that
 file unique.  Along the same lines, we take care not to (over-)test the basic 
 parsing of components because, really, that's libical itself.  Therefore, the 
 primary value in these unit (/integration) tests is found in testing that our 
 XbIC* objects allow for accessing the parsed values.
 */

@interface XbICalendarIcsTest : XCTestCase

@property (nonatomic, strong, readonly) NSDateFormatter *utcDateFormatter;
@property (nonatomic, readonly) double dateMatchAccuracy;

@property (nonatomic, strong, readonly) XbICComponent * rootComponent;
@property (nonatomic, copy, readonly) NSArray * calendars;
@property (nonatomic, copy, readonly) NSArray * events;

- (XbICComponent *)componentFromIcsFileName:(NSString *)fileName;
- (XbICVCalendar *)calendarFromIcsFileName:(NSString *)fileName;

- (void)assertUtcDateString:(NSString *)dateString isEqualToDate:(NSDate *)date withFailureMessage:(NSString *)failureMessage;

- (XbICVEvent *)componentAtIndex:(NSUInteger)componentIndex kind:(icalcomponent_kind)kind ofCalendarAtIndex:(NSUInteger)calendarIndex;

// This MUST be overidden in subclasses.  Examples are "2445" or "invite".
- (NSString *)icsFileNameUnderTest;

// Override this when testing a .ics file which has no calendars.  Default: YES.
- (BOOL)shouldExpectOneOrMoreCalendars;

@end
