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

    XCTAssertEqual(XbICInviteResponseAccept, [XbICInvite responseForCalendar:response forEmail:@"mailto:ahalls@gaggle.net"], @"ACCEPT");

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

    XCTAssertEqual(XbICInviteResponseDecline, [XbICInvite responseForCalendar:response forEmail:@"mailto:ahalls@gaggle.net"], @"DECLINE");
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

    XCTAssertEqual(XbICInviteResponseTenative,
                   [XbICInvite responseForCalendar:response forEmail:@"mailto:ahalls@gaggle.net"], @"TENATIVE");



    
}

- (void)test_responseForCalendar
{
  XCTAssertEqual(XbICInviteResponseUnknown, [XbICInvite responseForCalendar:self.calendars[0]
                                                                   forEmail:@"mailto:ahalls@gaggle.net"], @"UNKNOWN");


}

//- (void)testExample
//{
//  XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

@end
