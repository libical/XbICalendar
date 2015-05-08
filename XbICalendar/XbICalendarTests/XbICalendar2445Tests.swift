//
//  File.swift
//  XbICalendar
//
//  Created by Andrew Halls on 10/1/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//
import UIKit
import XCTest

class XbICalendar2445TestsSwift: XbICalendarIcsTest {

  override func icsFileNameUnderTest() -> String! {
    return "2445"
  }

 func test_initialization() {
  XCTAssertNotNil(self.rootComponent, "Initialization");
  XCTAssertEqual(self.calendars.count, 6, "Expected 6 calendars");
  }

  func test_calendar_method ()
  {
    let vCalendar: XbICVCalendar = self.calendars[2] as XbICVCalendar;
    XCTAssertEqual(vCalendar.method(), "PUBLISH", "Unexpected method");
  }

 func test_event_with_start_date ()
  {
    let vEvent:  XbICVEvent  = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:0) as  XbICVEvent;

    self.assertUtcDateString("19970714T170000Z",
      isEqualToDate:vEvent.dateStart(),
      withFailureMessage:"event dateStart is incorrect");
  }


 func test_event_with_end_date()
  {
    let vEvent:  XbICVEvent  = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:0) as  XbICVEvent;

   self.assertUtcDateString("19970715T035959Z",
      isEqualToDate: vEvent.dateEnd(),
      withFailureMessage:"event dateEnd is incorrect");
  }

  func test_event_with_timestamp()
  {
    XCTAssertTrue(self.events.count > 0, "Expected top level events");
    let vEvent: XbICVEvent = self.events[0] as XbICVEvent

    self.assertUtcDateString("19970901T130000Z",
    isEqualToDate:vEvent.dateStamp(),
    withFailureMessage:"event dateStamp is incorrect");

  }

  func test_event_with_summary()
  {
    XCTAssertTrue(self.events.count >= 2, "Expected top level events");
    let vEvent: XbICVEvent = self.events[1] as XbICVEvent

    XCTAssertEqual(vEvent.summary(), "Laurel is in sensitivity awareness class.", "event summary is incorrect");
  }


 func test_event_with_organizer()
  {
    let vEvent: XbICVEvent = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:2) as XbICVEvent

    XCTAssertEqual(vEvent.organizer().emailAddress(), "MAILTO:jdoe@host1.com", "Unexpected event organizer");

  }

  func test_event_with_uid()
  {
  let vEvent: XbICVEvent = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:2) as XbICVEvent

  XCTAssertEqual(vEvent.UID(), "uid3@host1.com", "Unexpected event UID");
  }

  func test_event_with_sequence()
  {
    let vEvent: XbICVEvent = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:2) as XbICVEvent

    XCTAssertEqual(vEvent.sequences().count, 1, "Unexpected sequence");
  }

  func test_event_with_multiline_description()
  {
 let vEvent: XbICVEvent = self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:2) as XbICVEvent

  XCTAssertEqual(vEvent.description(), "Discuss how we can test c&s interoperability\\nusing iCalendar and other IETF standards.", "Unexpected description");
  }

  func test_event_with_location ()
  {
  let vEvent: XbICVEvent =  self.componentAtIndex(0, kind:ICAL_VEVENT_COMPONENT, ofCalendarAtIndex:2) as XbICVEvent
  
  XCTAssertEqual(vEvent.location(), "LDB Lobby", "Unexpected location");
  }


}
