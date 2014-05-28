//
//  XbICVCalendar.h
//  XbICalendar
//


@interface XbICVCalendar : XbICComponent

+(instancetype) vCalendarFromFile: (NSString *) pathname;

-(NSString *) version;
-(NSString *) method;


@end
