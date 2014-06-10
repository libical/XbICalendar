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

- (void)test_inmemory {

    
  NSString * testData =
 @"BEGIN:VCALENDAR\nPRODID:-//Gaggle.net//Gaggle Calendar/EN\nVERSION:2.0\nCALSCALE:GREGORIAN\nMETHOD:REQUEST\nBEGIN:VEVENT\nDTSTAMP:20140606T091218Z\nDTSTART;TZID=America/Los_Angeles:20140609T151100\nDTEND;TZID=America/Los_Angeles:20140609T161100\nSUMMARY:Test EVent\nUID:9d83226944e8b8c7a77f0c5362560ff6@gaggle.net\nDESCRIPTION:\nSEQUENCE:1\nSTATUS:CONFIRMED\nTRANSP:OPAQUE\nCLASS:PUBLIC\nLOCATION:\nCREATED:20140606T091133Z\nLAST-MODIFIED:20140606T091147Z\nATTENDEE;ROLE=OPT-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE:mailto:ahalls@staging.gaggle.net\nATTENDEE;ROLE=OPT-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE:mailto:ahalls_student@staging.gaggle.net\nORGANIZER;CN=Andrew  Halls:mailto:ahalls@staging.gaggle.net\nEND:VEVENT\nBEGIN:VTIMEZONE\nTZID:America/Los_Angeles\nTZURL:http://tzurl.org/zoneinfo/America/Los_Angeles\nX-LIC-LOCATION:America/Los_Angeles\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0800\nTZOFFSETTO:-0700\nTZNAME:PDT\nDTSTART:20070311T020000\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\nEND:DAYLIGHT\nBEGIN:STANDARD\nTZOFFSETFROM:-0700\nTZOFFSETTO:-0800\nTZNAME:PST\nDTSTART:20071104T020000\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\nEND:STANDARD\nBEGIN:STANDARD\nTZOFFSETFROM:-075258\nTZOFFSETTO:-0800\nTZNAME:PST\nDTSTART:18831118T120702\nRDATE:18831118T120702\nEND:STANDARD\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0800\nTZOFFSETTO:-0700\nTZNAME:PDT\nDTSTART:19180331T020000\nRDATE:19180331T020000\nRDATE:19190330T020000\nRDATE:19480314T020000\nRDATE:19500430T020000\nRDATE:19510429T020000\nRDATE:19520427T020000\nRDATE:19530426T020000\nRDATE:19540425T020000\nRDATE:19550424T020000\nRDATE:19560429T020000\nRDATE:19570428T020000\nRDATE:19580427T020000\nRDATE:19590426T020000\nRDATE:19600424T020000\nRDATE:19610430T020000\nRDATE:19620429T020000\nRDATE:19630428T020000\nRDATE:19640426T020000\nRDATE:19650425T020000\nRDATE:19660424T020000\nRDATE:19670430T020000\nRDATE:19680428T020000\nRDATE:19690427T020000\nRDATE:19700426T020000\nRDATE:19710425T020000\nRDATE:19720430T020000\nRDATE:19730429T020000\nRDATE:19740106T020000\nRDATE:19750223T020000\nRDATE:19760425T020000\nRDATE:19770424T020000\nRDATE:19780430T020000\nRDATE:19790429T020000\nRDATE:19800427T020000\nRDATE:19810426T020000\nRDATE:19820425T020000\nRDATE:19830424T020000\nRDATE:19840429T020000\nRDATE:19850428T020000\nRDATE:19860427T020000\nRDATE:19870405T020000\nRDATE:19880403T020000\nRDATE:19890402T020000\nRDATE:19900401T020000\nRDATE:19910407T020000\nRDATE:19920405T020000\nRDATE:19930404T020000\nRDATE:19940403T020000\nRDATE:19950402T020000\nRDATE:19960407T020000\nRDATE:19970406T020000\nRDATE:19980405T020000\nRDATE:19990404T020000\nRDATE:20000402T020000\nRDATE:20010401T020000\nRDATE:20020407T020000\nRDATE:20030406T020000\nRDATE:20040404T020000\nRDATE:20050403T020000\nRDATE:20060402T020000\nEND:DAYLIGHT\nBEGIN:STANDARD\nTZOFFSETFROM:-0700\nTZOFFSETTO:-0800\nTZNAME:PST\nDTSTART:19181027T020000\nRDATE:19181027T020000\nRDATE:19191026T020000\nRDATE:19450930T020000\nRDATE:19490101T020000\nRDATE:19500924T020000\nRDATE:19510930T020000\nRDATE:19520928T020000\nRDATE:19530927T020000\nRDATE:19540926T020000\nRDATE:19550925T020000\nRDATE:19560930T020000\nRDATE:19570929T020000\nRDATE:19580928T020000\nRDATE:19590927T020000\nRDATE:19600925T020000\nRDATE:19610924T020000\nRDATE:19621028T020000\nRDATE:19631027T020000\nRDATE:19641025T020000\nRDATE:19651031T020000\nRDATE:19661030T020000\nRDATE:19671029T020000\nRDATE:19681027T020000\nRDATE:19691026T020000\nRDATE:19701025T020000\nRDATE:19711031T020000\nRDATE:19721029T020000\nRDATE:19731028T020000\nRDATE:19741027T020000\nRDATE:19751026T020000\nRDATE:19761031T020000\nRDATE:19771030T020000\nRDATE:19781029T020000\nRDATE:19791028T020000\nRDATE:19801026T020000\nRDATE:19811025T020000\nRDATE:19821031T020000\nRDATE:19831030T020000\nRDATE:19841028T020000\nRDATE:19851027T020000\nRDATE:19861026T020000\nRDATE:19871025T020000\nRDATE:19881030T020000\nRDATE:19891029T020000\nRDATE:19901028T020000\nRDATE:19911027T020000\nRDATE:19921025T020000\nRDATE:19931031T020000\nRDATE:19941030T020000\nRDATE:19951029T020000\nRDATE:19961027T020000\nRDATE:19971026T020000\nRDATE:19981025T020000\nRDATE:19991031T020000\nRDATE:20001029T020000\nRDATE:20011028T020000\nRDATE:20021027T020000\nRDATE:20031026T020000\nRDATE:20041031T020000\nRDATE:20051030T020000\nRDATE:20061029T020000\nEND:STANDARD\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0800\nTZOFFSETTO:-0700\nTZNAME:PWT\nDTSTART:19420209T020000\nRDATE:19420209T020000\nEND:DAYLIGHT\nBEGIN:DAYLIGHT\nTZOFFSETFROM:-0700\nTZOFFSETTO:-0700\nTZNAME:PPT\nDTSTART:19450814T160000\nRDATE:19450814T160000\nEND:DAYLIGHT\nBEGIN:STANDARD\nTZOFFSETFROM:-0800\nTZOFFSETTO:-0800\nTZNAME:PST\nDTSTART:19460101T000000\nRDATE:19460101T000000\nRDATE:19670101T000000\nEND:STANDARD\nEND:VTIMEZONE\nEND:VCALENDAR\n\n";

    XbICVCalendar * vCalendar =  [XbICVCalendar vCalendarFromString:testData];
    XCTAssertTrue([vCalendar.method isEqualToString:@"REQUEST"], @"");
    
    
    XbICVEvent * vEvent = (XbICVEvent *) [vCalendar firstComponentOfKind:ICAL_VEVENT_COMPONENT];
    XCTAssertTrue([vEvent isKindOfClass:[XbICVEvent class]], @"");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    
    NSDate * date = [vEvent dateStart];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Los_Angeles"]];
    NSDate * dateReference = [dateFormatter dateFromString:@"20140609T151100"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    
    date = [vEvent dateEnd];
    dateReference = [dateFormatter dateFromString:@"20140502T170000Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    
    date = [vEvent dateStamp];
    dateReference = [dateFormatter dateFromString:@"20140606T091218Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    date = [vEvent dateCreated];
    dateReference = [dateFormatter dateFromString:@"20140501T205317Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    
    date = [vEvent dateLastModified];
    dateReference = [dateFormatter dateFromString:@"20140501T205540Z"];
    XCTAssertEqualWithAccuracy([date timeIntervalSinceReferenceDate],
                               [dateReference timeIntervalSinceReferenceDate],0.001,@"");
    

    
    
}
@end
