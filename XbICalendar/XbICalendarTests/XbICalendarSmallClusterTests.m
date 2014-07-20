//
//  XbICalendarSmallClusterTests.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/19/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarSmallClusterTests : XbICalendarIcsTest

@end

@implementation XbICalendarSmallClusterTests

- (NSString *)icsFileNameUnderTest
{
    return @"smallcluster";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 1, @"Expected 1 calendars");
}

- (void)test_recurrence_rule_frequency
{
    XbICProperty * rrule = [self getRecurrenceRule];
    NSDictionary * parameters = [self valueParametersForRrule:rrule];
    
    XCTAssertEqualObjects(parameters[@"FREQ"], @"YEARLY", @"Unexpected frequency value");
}

// TODO: The parsing process strips out the UNTIL parameter.  Why?

- (void)test_recurrence_rule_by_set_position
{
    XbICProperty * rrule = [self getRecurrenceRule];
    NSDictionary * parameters = [self valueParametersForRrule:rrule];
    
    XCTAssertEqualObjects(parameters[@"BYSETPOS"], @"-1,2,-3,4,-5,6,-7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,4,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54", @"Unexpected by-set-position value");
}

- (void)test_recurrence_rule_by_second
{
    XbICProperty * rrule = [self getRecurrenceRule];
    NSDictionary * parameters = [self valueParametersForRrule:rrule];
    
    XCTAssertEqualObjects(parameters[@"BYSECOND"], @"1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,4,25,26", @"Unexpected by second value");
}

#pragma mark - Helper methods

// TODO: Improve API so consumers don't have to do these kinds of things.

- (XbICProperty *)getRecurrenceRule
{
    XbICVEvent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:0];
    XCTAssertNotNil(vEvent, @"Expected an event");
    
    NSArray * recurrenceRules = [vEvent propertiesOfKind:ICAL_RRULE_PROPERTY];
    XCTAssertTrue([recurrenceRules count] > 0, @"Expected a recurrence rule");
    
    return recurrenceRules[0];
}

- (NSDictionary *)valueParametersForRrule:(XbICProperty *)rrule
{
    NSString *value = (NSString *)rrule.value;
    XCTAssertNotNil(value, @"Expected value");
    XCTAssertTrue([value isKindOfClass:[NSString class]], @"Expected value to be NSString");
    
    NSArray *valueParameters = [value componentsSeparatedByString:@";"];
    XCTAssertTrue([valueParameters count] > 0, @"Expected value parameters");
    
    NSMutableDictionary *valueParametersDict = [NSMutableDictionary dictionaryWithCapacity:[valueParameters count]];
    
    for (NSString *parameter in valueParameters) {
        NSArray *parameterParts = [parameter componentsSeparatedByString:@"="];
        XCTAssertEqual([parameterParts count], 2, @"Expected parameter to have two parts");
        
        valueParametersDict[parameterParts[0]] = parameterParts[1];
    }
    
    return valueParametersDict;
}

@end
