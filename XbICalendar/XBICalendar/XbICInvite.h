//
//  XbICInvite.h
//  XbICalendar
//
//  Created by Andrew Halls on 8/5/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "ical.h"
#import "XbICVCalendar.h"

typedef NS_ENUM(NSInteger, XbICInviteResponse) {
    XbICInviteResponseUnknown = -1,
    XbICInviteResponseAccept,
    XbICInviteResponseDecline,
    XbICInviteResponseTenative
};

@interface XbICInvite : NSObject

+(XbICVCalendar *) inviteResponseFromCalendar: (XbICVCalendar *) calendar
                                    fromEmail: (NSString *) email
                                     response:(XbICInviteResponse) response;

+(XbICInviteResponse) responseForCalendar:(XbICVCalendar *) calendar
                                 forEmail:(NSString *) email;

@end
