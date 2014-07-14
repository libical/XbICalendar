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
}

- (NSString *)icsFileNameUnderTest
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
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

- (XbICVEvent *)eventAtIndex:(NSUInteger)eventIndex ofCalendarAtIndex:(NSUInteger)calendarIndex
{
    XbICVCalendar * vCalendar = self.calendars[calendarIndex];
    NSArray * events = [vCalendar componentsOfKind:ICAL_VEVENT_COMPONENT];
    XCTAssertTrue([events count] >= eventIndex + 1, @"Expected an event at index %d", eventIndex);
    
    return events[eventIndex];
}

#pragma mark - Helper methods

- (NSString *)filePathForIcsFileName:(NSString *)fileName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [bundle pathForResource:fileName ofType:@"ics"];
}

@end
