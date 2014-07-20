//
//  XbICalendarOverlapTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarOverlapTests : XbICalendarIcsTest

@end

/* 
 NOTE: It seems that overlaps.ics is a perfect test file for
 verifying that conflicts are resolved.  At this level (where 
 we're simply testing whether the XbIEvent gives access to the 
 parsed values), however, these tests aren't very exciting.
 */

@implementation XbICalendarOverlapTests

- (NSString *)icsFileNameUnderTest
{
    return @"overlaps";
}

- (BOOL)shouldExpectOneOrMoreCalendars
{
    return NO;
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertEqual([self.calendars count], 0, @"Expected 0 calendars");
    XCTAssertEqual([self.events count], 5, @"Expected 5 top-level events");
}

- (void)test_first_event_dates
{
    XbICVEvent * vEvent = self.events[0];
    
    [self assertUtcDateString:@"20001104T150000"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    [self assertUtcDateString:@"20001104T160000"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_last_event_dates
{
    XbICVEvent * vEvent = self.events[4];
    
    [self assertUtcDateString:@"20001104T170000"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    [self assertUtcDateString:@"20001104T180000"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

@end
