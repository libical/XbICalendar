//
//  XbICalendarTests.m
//  XbICalendarTests
//
//  Created by Andrew Halls on 5/26/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
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

- (void)test_FileMissing
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"test" ofType:@"ics"];
    XbICFile * file = [[XbICFile alloc] initWithPathname:path];
    
    // Need To verify the file was opened
    
    [file read];
    
    [file save];
    
}

- (void)test_2445_ics {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"2445" ofType:@"ics"];
    XbICFile * file = [[XbICFile alloc] initWithPathname:path];

    [file read];
    
}

- (void)test_invite_ics {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"invite" ofType:@"ics"];
    XbICFile * file = [[XbICFile alloc] initWithPathname:path];
    
    [file read];
    

}


@end
