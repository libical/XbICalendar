//
//  XbICInvite.m
//  XbICalendar
//
//  Created by Andrew Halls on 8/5/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "XbICInvite.h"
#import "XbICVEvent.h"

@implementation XbICInvite

+(XbICVCalendar *) inviteResponseFromCalendar: (XbICVCalendar *) calendar
                                    fromEmail: (NSString *) email
                                     response:(XbICInviteResponse) response {
    
    XbICVCalendar * newCalendar = [calendar copy];
    [newCalendar setMethod:@"REPLY"];
    
    XbICVEvent * event = (XbICVEvent *) [newCalendar firstComponentOfKind:ICAL_VEVENT_COMPONENT];
    if (event) {
        [event updateAttendeeWithEmail:email withResponse:response];
    }
    
    return newCalendar;
}

@end
