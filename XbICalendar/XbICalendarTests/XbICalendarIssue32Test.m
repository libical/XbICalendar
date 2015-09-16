//
//  XbICalendarIssue32Test.m
//  XbICalendar
//

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import "XbICalendarIcsTest.h"

@interface XbICalendarIssue32Test : XbICalendarIcsTest
@end

@implementation XbICalendarIssue32Test

- (NSString *)icsFileNameUnderTest
{
  return @"issue_32";
}

- (void)test_checkforErrors
{
  XCTAssertNotNil(self.rootComponent, @"Initialization");
  XCTAssertEqual([self.calendars count], 1, @"Expected 1 calendars");

  XCTAssertNotNil(self.error, @"Expect an Error");
  XCTAssertEqual(9001, [[self error] code], @"Expected error code");
}


@end