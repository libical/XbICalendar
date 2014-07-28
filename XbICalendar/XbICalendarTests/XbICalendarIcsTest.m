//
//  XbICalendarIcsTest.m
//  XbICalendar
//
//  Created by Mark DeLaVergne on 7/12/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "XbICalendarIcsTest.h"

@interface XbICalendarIcsTest ()
@property (nonatomic, strong, readwrite) NSDateFormatter *utcDateFormatter;
@property (nonatomic, readwrite) double dateMatchAccuracy;

@property (nonatomic, strong, readwrite) XbICComponent * rootComponent;
@property (nonatomic, copy, readwrite) NSArray * calendars;
@property (nonatomic, copy, readwrite) NSArray * events;
@end

@implementation XbICalendarIcsTest

- (void)setUp
{
    [super setUp];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    self.utcDateFormatter = dateFormatter;
    
    self.dateMatchAccuracy = 0.001;
    
    NSString *icsFileName = [self icsFileNameUnderTest];
    self.rootComponent = [self componentFromIcsFileName:icsFileName];
    self.calendars = [self.rootComponent componentsOfKind:ICAL_VCALENDAR_COMPONENT];
    self.events = [self.rootComponent componentsOfKind:ICAL_VEVENT_COMPONENT];
    
    if ([self.calendars count] == 0 && self.rootComponent.kind == ICAL_VCALENDAR_COMPONENT) {
        self.calendars = @[self.rootComponent];
    }
    
    if ([self shouldExpectOneOrMoreCalendars]) {
        XCTAssertTrue(self.calendars != nil && [self.calendars count] > 0);
    }
}

- (NSString *)icsFileNameUnderTest
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)shouldExpectOneOrMoreCalendars
{
    return YES;
}

- (XbICComponent *)componentFromIcsFileName:(NSString *)fileName
{
    NSString *filePath = [self filePathForIcsFileName:fileName];
    XbICFile * file = [XbICFile fileWithPathname:filePath];
    return [file read];
}

- (XbICVCalendar *)calendarFromIcsFileName:(NSString *)fileName
{
    NSString *filePath = [self filePathForIcsFileName:fileName];
    return [XbICVCalendar vCalendarFromFile:filePath];
}

- (void)assertUtcDateString:(NSString *)dateString isEqualToDate:(NSDate *)date withFailureMessage:(NSString *)failureMessage
{
    NSDate * dateReference = [self.utcDateFormatter dateFromString:dateString];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],
                               self.dateMatchAccuracy,
                               @"%@", failureMessage);
}

- (XbICVEvent *)componentAtIndex:(NSUInteger)componentIndex kind:(icalcomponent_kind)kind ofCalendarAtIndex:(NSUInteger)calendarIndex
{
    XbICVCalendar * vCalendar = self.calendars[calendarIndex];
    NSArray * components = [vCalendar componentsOfKind:kind];
    XCTAssertTrue([components count] >= componentIndex + 1, @"Expected an event at index %d", componentIndex);
    
    return components[componentIndex];
}

#pragma mark - Helper methods

- (NSString *)filePathForIcsFileName:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [bundle pathForResource:fileName ofType:@"ics"];
}

@end
