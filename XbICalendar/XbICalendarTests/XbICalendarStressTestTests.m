//
//  XbICalendarStressTestTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarStressTestTests : XbICalendarIcsTest

@end

@implementation XbICalendarStressTestTests

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
    
    // (Parsing this crazy file didn't cause an exception / crash)
}

@end
