//
//  XbICalendarTests.m
//

#import <XCTest/XCTest.h>
#import "XBICalendar.h"

@interface XbICalendarTests : XCTestCase

@end

@implementation XbICalendarTests



- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)test_FileMissing
//{
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString *path = [bundle pathForResource:@"test" ofType:@"ics"];
//    XbICFile * file = [[XbICFile alloc] initWithPathname:path];
//    
//    // Need To verify the file was opened
//    
//    [file read];
//    
//    [file save];
//    
//}
//
//- (void)test_2445_ics {
//    
//    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    NSString *path = [bundle pathForResource:@"2445" ofType:@"ics"];
//    XbICFile * file = [[XbICFile alloc] initWithPathname:path];
//
//    [file read];
//    
//}

- (void)test_invite_ics {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"invite" ofType:@"ics"];
    
    XbICVCalendar * vCalendar =  [XbICVCalendar vCalendarFromFile:path];
    XCTAssertNotNil(vCalendar, @"Initialization");
    XCTAssertTrue([[vCalendar method] isEqualToString:@"REQUEST"], @"Expecting a REQUEST" );
    
    NSArray * events = [vCalendar componentsOfKind:ICAL_VEVENT_COMPONENT];
    XCTAssertEqual(events.count, 1, @"Expecting a single event");
    
    XbICVEvent * event = events[0];
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    
    NSDate * date = [event dateStart];
    NSDate * dateReference = [dateFormatter dateFromString:@"20140502T160000Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    
    date = [event dateEnd];
    dateReference = [dateFormatter dateFromString:@"20140502T170000Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");

    date = [event dateStamp];
    dateReference = [dateFormatter dateFromString:@"20140501T205541Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    date = [event dateCreated];
    dateReference = [dateFormatter dateFromString:@"20140501T205317Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");

    date = [event dateLastModified];
    dateReference = [dateFormatter dateFromString:@"20140501T205540Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    
    
    XCTAssertEqual([event sequence], @(0), @"Should be Equal");
    
    XCTAssertTrue([[event UID] isEqualToString:@"rdfu8eaik1ss1tc3t725ppijlo@google.com" ], @"" );
    
    XCTAssertNil([event location] , @"" );
    
    XCTAssertTrue([[event summary] isEqualToString:@"Test Event" ], @"" );
    
    XCTAssertTrue([[event status] isEqualToString:@"CONFIRMED" ], @"" );
    
    
    XCTAssertTrue([[event description] isEqualToString:@"View your event at http://www.google.com/calendar/event?action="
                   "VIEW&eid=cmRmdThlYWlrMXNzMXRjM3Q3MjVwcGlqbG8gYWhhbGxzQGdhZ2dsZS5uZXQ&tok=MT"
                   "kjYW5kcmV3QGdhbHRzb2Z0LmNvbTUwMjM5OTI1MTk0NzQyMWFlNDA5OGMzZjNmODIyMzdhNjhiM"
                   "TZmMWI&ctz=America/Denver&hl=en." ], @"" );
    
    XbICPerson * organizer = [event organizer];
    XCTAssertNotNil(organizer, @"");
    XCTAssertTrue([organizer isKindOfClass:[XbICPerson class]], @"");
    XCTAssertTrue([((NSString *)[organizer value]) isEqualToString: @"mailto:andrew@galtsoft.com"], @"");
    XCTAssertTrue([[organizer name] isEqualToString: @"Andrew Halls"], @"");

    
    NSArray * attendees = [event attendees];
    XCTAssertEqual(attendees.count, 3, @"");
    
    XbICPerson * attendee1 = attendees[0];
    XCTAssertNotNil(attendee1, @"");
    XCTAssertTrue([attendee1 isKindOfClass:[XbICPerson class]], @"");
    XCTAssertTrue([((NSString *)[attendee1 value]) isEqualToString: @"mailto:andrewhalls.iphone@gmail.com"], @"");
    XCTAssertTrue([[attendee1 name] isEqualToString: @"Andrew Halls"], @"");
    XCTAssertTrue([attendee1 RSVP], @"");

}


@end
