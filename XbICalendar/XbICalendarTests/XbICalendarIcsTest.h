//
//  XbICalendarTest.h
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/12/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendar.h"

@interface XbICalendarIcsTest : XCTestCase

@property (nonatomic, strong, readonly) NSDateFormatter *utcDateFormatter;
@property (nonatomic, readonly) double dateMatchAccuracy;

@property (nonatomic, strong, readonly) XbICComponent * rootComponent;
@property (nonatomic, copy, readonly) NSArray * calendars;

- (XbICComponent *)componentFromIcsFileName:(NSString *)fileName;
- (XbICVCalendar *)calendarFromIcsFileName:(NSString *)fileName;

- (void)assertUtcDateString:(NSString *)dateString isEqualToDate:(NSDate *)date withFailureMessage:(NSString *)failureMessage;

- (XbICVEvent *)eventAtIndex:(NSUInteger)eventIndex ofCalendarAtIndex:(NSUInteger)calendarIndex;

// This MUST be overidden in subclasses.  Examples are "2445" or "invite".
- (NSString *)icsFileNameUnderTest;

@end
