//
//  XbICPerson.h
//

#import "ical.h"
#import "XbICProperty.h"

@interface XbICPerson : XbICProperty

-(NSString *) emailAddress;
-(NSString *) name;
-(BOOL) RSVP;


@end
