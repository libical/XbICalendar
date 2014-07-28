//
//  XbICalendarSpanListTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarSpanListTests : XbICalendarIcsTest
@end

@implementation XbICalendarSpanListTests

- (NSString *)icsFileNameUnderTest
{
    return @"spanlist";
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
    
    [self assertUtcDateString:@"19980101T000000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    [self assertUtcDateString:@"19980101T010000Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

- (void)test_last_event_dates
{
    XbICVEvent * vEvent = self.events[4];
    
    [self assertUtcDateString:@"19980106T060000Z"
                isEqualToDate:[vEvent dateStart]
           withFailureMessage:@"event dateStart is incorrect"];
    
    [self assertUtcDateString:@"19980106T070000Z"
                isEqualToDate:[vEvent dateEnd]
           withFailureMessage:@"event dateEnd is incorrect"];
}

@end
