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

// TODO: more to come.

@end
