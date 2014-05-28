//
//  XbICVEvent.m
//

#import "XBICalendar.h"

@implementation XbICVEvent

-(NSDate *) dateStart {
    NSArray * properties = [self propertiesOfKind:ICAL_DTSTART_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_DTSTART_PROPERTY");
        return nil;
    }
    return (NSDate *)[((XbICProperty *)properties[0]) value];

}

-(NSDate *) dateEnd {
    NSArray * properties = [self propertiesOfKind:ICAL_DTEND_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_DTEND_PROPERTY");
        return nil;
    }
    return (NSDate *)[((XbICProperty *)properties[0]) value];
    
}

-(NSDate *) dateStamp {
    NSArray * properties = [self propertiesOfKind:ICAL_DTSTAMP_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_DTSTAMP_PROPERTY");
        return nil;
    }
    return (NSDate *)[((XbICProperty *)properties[0]) value];
    
}

-(NSDate *) dateCreated {
    NSArray * properties = [self propertiesOfKind:ICAL_CREATED_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_CREATED_PROPERTY");
        return nil;
    }
    return (NSDate *)[((XbICProperty *)properties[0]) value];
    
}

-(NSDate *) dateLastModified {
    NSArray * properties = [self propertiesOfKind:ICAL_LASTMODIFIED_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_LASTMODIFIED_PROPERTY");
        return nil;
    }
    return (NSDate *)[((XbICProperty *)properties[0]) value];
    
}


/*

 -(NSTimeZone *) timeZone;
 //-(XbICPerson *) organizer;
 -(NSString *) UID;
 -(NSArray *) Attendees;
 -(NSString *) location;
 -(NSNumber *) sequence;
 -(NSString *) status;
 -(NSString *) confirmed
 */

@end
