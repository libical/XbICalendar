//
//  XbICInviteResponseTests.m
//  XbICalendar
//
//  Created by Andrew Halls on 8/5/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "XbICalendarIcsTest.h"

@interface XbICInviteResponseTests : XbICalendarIcsTest

@end

@implementation XbICInviteResponseTests

- (NSString *)icsFileNameUnderTest
{
    return @"invite";
}

- (void)test_initialization
{
    XCTAssertNotNil(self.rootComponent, @"Initialization");
    XCTAssertTrue([self.calendars count] == 1, @"Expected 1 calendars");
}

- (void)test_InviteAcceptResponse
{
    XbICVCalendar * response = [XbICInvite inviteResponseFromCalendar: self.calendars[0]
                                                            fromEmail: @"mailto:ahalls@gaggle.net"
                                                             response: XbICInviteResponseAccept];
    
    XCTAssert(![response isEqual:self.calendars[0]], @"Should Change the Response");
    XCTAssert([response.method isEqualToString:@"REPLY"], @"Should be a reply");
    
    XbICVEvent * vEvent = response.subcomponents[0];
    XCTAssertNotNil(vEvent, @"Should have an event");
    
    for (XbICProperty * attendee in vEvent.attendees) {
        if ([(NSString *) attendee.value isEqualToString: @"mailto:ahalls@gaggle.net"]) {
            XCTAssert([attendee.parameters[@"PARTSTAT"] isEqualToString:@"ACCEPT"], @"Should Accept");
        }
    }
    

}

- (void)test_InviteDeclineResponse
{
    XbICVCalendar * response = [XbICInvite inviteResponseFromCalendar: self.calendars[0]
                                                            fromEmail: @"mailto:ahalls@gaggle.net"
                                                             response: XbICInviteResponseDecline];
    
    XCTAssert(![response isEqual:self.calendars[0]], @"Should Change the Response");
    XCTAssert([response.method isEqualToString:@"REPLY"], @"Should be a reply");
    
    XbICVEvent * vEvent = response.subcomponents[0];
    XCTAssertNotNil(vEvent, @"Should have an event");
    
    for (XbICProperty * attendee in vEvent.attendees) {
        if ([(NSString *) attendee.value isEqualToString: @"mailto:ahalls@gaggle.net"]) {
            XCTAssert([attendee.parameters[@"PARTSTAT"] isEqualToString:@"DECLINE"], @"Should Accept");
        }
    }
    
    
}

- (void)test_InviteTenativeResponse
{
    XbICVCalendar * response = [XbICInvite inviteResponseFromCalendar: self.calendars[0]
                                                            fromEmail: @"mailto:ahalls@gaggle.net"
                                                             response: XbICInviteResponseTenative];
    
    XCTAssert(![response isEqual:self.calendars[0]], @"Should Change the Response");
    XCTAssert([response.method isEqualToString:@"REPLY"], @"Should be a reply");
    
    XbICVEvent * vEvent = response.subcomponents[0];
    XCTAssertNotNil(vEvent, @"Should have an event");
    
    for (XbICProperty * attendee in vEvent.attendees) {
        if ([(NSString *) attendee.value isEqualToString: @"mailto:ahalls@gaggle.net"]) {
            XCTAssert([attendee.parameters[@"PARTSTAT"] isEqualToString:@"TENATIVE"], @"Should Accept");
        }
    }
    
    
}

//- (void)testExample
//{
//  XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
