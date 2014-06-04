//
//  XbICVEvent.h
//

#import "ical.h"
#import "XbICComponent.h"
#import "XbICPerson.h"


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
-(NSNumber *) sequence;
-(NSString *) status;
-(NSString *) summary;

@end
