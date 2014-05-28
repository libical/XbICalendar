//
//  XbICVEvent.h
//


@interface XbICVEvent : XbICComponent

-(NSDate *) dateStart;
-(NSDate *) dateEnd;
-(NSDate *) dateStamp;
-(NSDate *) dateCreated;
-(NSDate *) dateLastModified;
-(NSTimeZone *) timeZone;
//-(XbICPerson *) organizer;
-(NSString *) UID;
-(NSArray *) Attendees;
-(NSString *) location;
-(NSNumber *) sequence;
-(NSString *) status;
-(NSString *) confirmed;

@end
