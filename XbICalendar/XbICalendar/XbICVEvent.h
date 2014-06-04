//
//  XbICVEvent.h
//


@interface XbICVEvent : XbICComponent

-(NSDate *) dateStart;
-(NSDate *) dateEnd;
-(NSDate *) dateStamp;
-(NSDate *) dateCreated;
-(NSDate *) dateLastModified;
//-(XbICPerson *) organizer;
-(NSString *) UID;
-(NSArray *) Attendees;
-(NSString *) location;
-(NSString *) description;
-(NSNumber *) sequence;
-(NSString *) status;
-(NSString *) summary;

@end
