//
//  XbICVEvent.m
//

#import "XbICVEvent.h"
#import "XbICInvite.h"

@implementation XbICVEvent

-(instancetype) initWithIcalComponent:  (icalcomponent *) c {
  self = [super initWithIcalComponent: c];
  if (self) {

  }
  return self;
}

-(NSDate *) dateStart {
    return (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTART_PROPERTY] value];
}

-(NSDate *) dateEnd {
    return (NSDate *)[[self firstPropertyOfKind:ICAL_DTEND_PROPERTY] value];
}

-(NSDate *) dateStamp {
    return (NSDate *)[[self firstPropertyOfKind:ICAL_DTSTAMP_PROPERTY] value];
}

-(NSDate *) dateCreated {
    return (NSDate *)[[self firstPropertyOfKind:ICAL_CREATED_PROPERTY] value];
}

-(NSDate *) dateLastModified {
    return (NSDate *)[[self firstPropertyOfKind:ICAL_LASTMODIFIED_PROPERTY] value];
}

-(NSArray *) sequences {
    NSArray * properties =  [self propertiesOfKind:ICAL_SEQUENCE_PROPERTY];
    NSMutableArray * sequences = [NSMutableArray array];
    
    for (XbICProperty * sequence in properties) {
        [sequences addObject:sequence.value];
    }
    
    return sequences;
}

-(NSString *) UID {
    return (NSString *)[[self firstPropertyOfKind:ICAL_UID_PROPERTY] value];
}

-(NSString *) location {

    return (NSString *)[[self firstPropertyOfKind:ICAL_LOCATION_PROPERTY] value];
}

-(NSString *) summary {
    return (NSString *)[[self firstPropertyOfKind:ICAL_SUMMARY_PROPERTY] value];
}

-(NSString *) status {
    return (NSString *)[[self firstPropertyOfKind:ICAL_STATUS_PROPERTY] value];
}

-(NSString *) description {
    return (NSString *)[[self firstPropertyOfKind:ICAL_DESCRIPTION_PROPERTY] value];
}

-(XbICPerson *) organizer {
    return (XbICPerson *)[self firstPropertyOfKind:ICAL_ORGANIZER_PROPERTY];
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
        case XbICInviteResponseUnknown:
        default:
            return @"UNKNOWN";
            break;
    }
}

-(XbICInviteResponse) responseInviteFromString: (NSString *) status {

  if ([status isEqualToString:@"ACCEPT"] || [status isEqualToString:@"ACCEPTED"] || [status isEqualToString:@"YES"]) {
    return XbICInviteResponseAccept;
  }
  if ([status isEqualToString:@"DECLINE"] || [status isEqualToString:@"DECLINED"] || [status isEqualToString:@"NO"]) {
    return XbICInviteResponseDecline;
  }
  if ([status isEqualToString:@"TENATIVE"] || [status isEqualToString:@"TENATIVED"] || [status isEqualToString:@"MAYBE"]) {
    return XbICInviteResponseTenative;
  }

    return XbICInviteResponseUnknown;
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


- (XbICInviteResponse) lookupAttendeeStatusForEmail: (NSString *) email {
  NSArray  * attendees = self.attendees;
  for (XbICProperty * attendee in  attendees) {

    if ([(NSString *)attendee.value isEqualToString:[self stringFixUpEmail:email]]) {

      NSDictionary * parameters = attendee.parameters;

      return [self responseInviteFromString: parameters[@"PARTSTAT"]];
    }
  }
  return XbICInviteResponseUnknown;
}

@end
