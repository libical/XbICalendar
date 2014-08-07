//
//  XbICVEvent.h
//

#import "ical.h"
#import "XbICComponent.h"
#import "XbICPerson.h"
#import "XbICInvite.h"


@interface XbICVEvent : XbICComponent

-(NSDate *) dateStart;
-(NSDate *) dateEnd;
-(NSDate *) dateStamp;
-(NSDate *) dateCreated;
-(NSDate *) dateLastModified;
-(XbICPerson *) organizer;
-(NSString *) UID;
-(NSArray *) attendees;
-(NSString *) location;
-(NSString *) description;
-(NSArray *) sequences;
-(NSString *) status;
-(NSString *) summary;

- (void) updateAttendeeWithEmail: (NSString *) email withResponse: (XbICInviteResponse) response;
- (XbICInviteResponse) lookupAttendeeStatusForEmail: (NSString *) email;

@end
