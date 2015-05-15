//
//  XbICPropertyTest.m
//  XbICalendar
//
//  Created by Han Chengge on 5/15/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICPropertyTest : XbICalendarIcsTest

@end

@implementation XbICPropertyTest

- (NSString *)icsFileNameUnderTest
{
    return @"2446";
}

- (void)test_property_with_utcoffset
{
    XbICComponent * vTimezone = [self componentAtIndex:0 kind:ICAL_VTIMEZONE_COMPONENT ofCalendarAtIndex:3];
    XbICComponent * standard = vTimezone.subcomponents[0];
    XbICProperty *offset = standard.properties[2];
    int v = [(NSNumber *)offset.value intValue];
    
    icalvalue *ical_v = icalvalue_new_from_string(ICAL_UTCOFFSET_VALUE, [@"-0500" cStringUsingEncoding:NSUTF8StringEncoding]);
    
    XCTAssertTrue(icalvalue_get_utcoffset(ical_v) == v, @"Unexpected timezone offset");
}

- (void)test_property_with_duration
{
    XbICComponent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:3];
    XbICComponent * vAlarm = vEvent.subcomponents[0];
    XbICProperty *trigger = vAlarm.properties[0];
    NSDictionary *v = (NSDictionary *)trigger.value;
    
    icalvalue *ical_v = icalvalue_new_from_string(ICAL_DURATION_VALUE, [@"-PT2H" cStringUsingEncoding:NSUTF8StringEncoding]);
    struct icaldurationtype ical_duration = icalvalue_get_duration(ical_v);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInt:ical_duration.is_neg] forKey:@"is_neg"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.weeks] forKey:@"weeks"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.days] forKey:@"days"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.hours] forKey:@"hours"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.minutes] forKey:@"minutes"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.seconds] forKey:@"seconds"];
    
    XCTAssertEqualObjects(v, dictionary, @"Unexpected duration");
}

- (void)test_property_with_request_status
{
    XbICComponent * vEvent = [self componentAtIndex:0 kind:ICAL_VEVENT_COMPONENT ofCalendarAtIndex:6];
    XbICProperty *request_status = vEvent.properties[4];
    NSDictionary *v = (NSDictionary *)request_status.value;
    
    icalvalue *ical_v = icalvalue_new_from_string(ICAL_REQUESTSTATUS_VALUE, [@"2.0;Success" cStringUsingEncoding:NSUTF8StringEncoding]);
    struct icalreqstattype ical_reqstat = icalvalue_get_requeststatus(ical_v);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:ical_reqstat.code] forKey:@"code"];
    
    if (ical_reqstat.debug) {
        [dictionary setObject:[NSString stringWithCString: ical_reqstat.debug encoding: NSASCIIStringEncoding] forKey:@"debug"];
    }
    
    if (ical_reqstat.desc) {
        [dictionary setObject:[NSString stringWithCString: ical_reqstat.desc encoding: NSASCIIStringEncoding] forKey:@"desc"];
    }
    
    XCTAssertEqualObjects(v, dictionary, @"Unexpected request status");
}

@end
