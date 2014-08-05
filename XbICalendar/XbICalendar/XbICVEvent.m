//
//  XbICVEvent.m
//

#import "XbICVEvent.h"
#import "XbICInvite.h"

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
-(NSNumber *) sequence {
    NSArray * properties = [self propertiesOfKind:ICAL_SEQUENCE_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_SEQUENCE_PROPERTY");
        return nil;
    }
    return (NSNumber *)[((XbICProperty *)properties[0]) value];
    
}
-(NSString *) UID {
    NSArray * properties = [self propertiesOfKind:ICAL_UID_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_UID_PROPERTY");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}

-(NSString *) location {
    NSArray * properties = [self propertiesOfKind:ICAL_LOCATION_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_LOCATION_PROPERTY");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}

-(NSString *) summary {
    NSArray * properties = [self propertiesOfKind:ICAL_SUMMARY_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_SUMMARY_PROPERTY");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}
-(NSString *) status {
    NSArray * properties = [self propertiesOfKind:ICAL_STATUS_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_STATUS_PROPERTY");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}
-(NSString *) description {
    NSArray * properties = [self propertiesOfKind:ICAL_DESCRIPTION_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_STATUS_PROPERTY");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}

-(XbICPerson *) organizer {
    NSArray * properties = [self propertiesOfKind:ICAL_ORGANIZER_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"ICAL_ORGANIZER_PROPERTY");
        return nil;
    }
    return properties[0];
}


-(NSArray *) attendees {
    return [self propertiesOfKind:ICAL_ATTENDEE_PROPERTY];
}

static NSString * mailto = @"mailto";
-(NSString *) stringFixUpEmail: email {
    
    if ([email hasPrefix:mailto]) {
        return email;
    }
    return [NSString stringWithFormat:@"mailto:%@", email];
}

-(NSString *) stringInviteResponse: (XbICInviteResponse) response  {
    switch (response) {
        case XbICInviteResponseAccept:
            return @"ACCEPT";
            break;
        case XbICInviteResponseDecline:
            return @"DECLINE";
            break;
        case XbICInviteResponseTenative:
            return @"TENATIVE";
            break;

        default:
            return @"UNKNOWN";
            break;
    }
}

- (void) updateAttendeeWithEmail: (NSString *) email withResponse: (XbICInviteResponse) response {
    NSArray  * attendees = self.attendees;
    for (XbICProperty * attendee in  attendees) {
        
        if ([(NSString *)attendee.value isEqualToString:[self stringFixUpEmail:email]]) {
            NSMutableDictionary * parameters = [attendee.parameters mutableCopy];
            
            parameters[@"PARTSTAT"] = [self stringInviteResponse:response];
            
            attendee.parameters = [NSDictionary dictionaryWithDictionary:parameters];
            
        }
        
    }
}

@end
