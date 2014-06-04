//
//  XbICVCalendar.h
//
#import "ical.h"
#import "XbICComponent.h"

@interface XbICVCalendar : XbICComponent

+(instancetype) vCalendarFromFile: (NSString *) pathname;

-(NSString *) version;
-(NSString *) method;


@end
