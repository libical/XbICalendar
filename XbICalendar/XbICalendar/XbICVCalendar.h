//
//  XbICVCalendar.h
//
#import "ical.h"
#import "XbICComponent.h"

@interface XbICVCalendar : XbICComponent

+(instancetype) vCalendarFromFile: (NSString *) pathname;
+(instancetype) vCalendarFromString: (NSString *) content;

-(NSString *) version;
-(NSString *) method;
-(void) setMethod: (NSString *) newMethod;


@end
