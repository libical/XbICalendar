//
//  XbICProperty.m
//

#import "XBICalendar.h"

@implementation XbICProperty

-(instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

//-(instancetype) initWithKey: (NSString *) key value: (NSObject *) value parameters: (NSDictionary *) parameters {
//    self = [super init];
//    if (self) {
//        self.key = key;
//        self.value = value;
//        self.parameters = parameters;
//    }
//    return  self;
//}
//+(instancetype) propertyWithKey: (NSString *) key value: (NSObject *) value parameters: (NSDictionary *) parameters {
//    
//    return [[XbICProperty alloc] initWithKey:key value:value parameters:parameters];
//    
//}

+ (instancetype) propertyFactory: (icalproperty *) p {
    XbICProperty * property;
    switch ( icalproperty_isa(p)) {
        case ICAL_ORGANIZER_PROPERTY:
        case ICAL_OWNER_PROPERTY:
        case ICAL_ATTENDEE_PROPERTY:
            property = [[XbICPerson alloc] init];
            break;
            
        default:
            property = [[XbICProperty alloc] init];
            break;
    }
    return property;
}

+(instancetype) propertyWithIcalProperty: (icalproperty *) p {
    
    XbICProperty * property = [XbICProperty propertyFactory:p];
    
    if (property) {
        
        property.parameters = [property parametersWithIcalProperty: p];
    
        property.kind = icalproperty_isa(p);
   
        icalvalue* v =  icalproperty_get_value (p);
        
        
        switch (property.kind) {
            case ICAL_ACKNOWLEDGED_PROPERTY:
            case ICAL_COMPLETED_PROPERTY:
            case ICAL_CREATED_PROPERTY:
            case ICAL_DATEMAX_PROPERTY :
            case ICAL_DATEMIN_PROPERTY:
            case ICAL_DTEND_PROPERTY:
            case ICAL_DTSTAMP_PROPERTY:
            case ICAL_DTSTART_PROPERTY:
            case ICAL_DUE_PROPERTY:
            case ICAL_EXDATE_PROPERTY:
            case ICAL_LASTMODIFIED_PROPERTY:
            case ICAL_MAXDATE_PROPERTY:
            case ICAL_MINDATE_PROPERTY:
            case ICAL_RECURRENCEID_PROPERTY:
                property.value = [property dateFromValue: v parameters: property.parameters];
                break;
                
            case ICAL_SEQUENCE_PROPERTY:
                property.value = [property numberFromIntValue: v];
                break;
                
            case ICAL_XLICERROR_PROPERTY:
                NSLog(@"Error: %d, %@", property.kind, [property stringFromValue:v]);
                break;
                
            default:
                property.value = [property stringFromValue: v];
                break;
        }
        
    }
    

    
    return property;
    
}

-(NSDictionary *) parametersWithIcalProperty: (icalproperty *) p {
    
    NSMutableDictionary * parameters = [[NSMutableDictionary alloc] init];
    
    icalparameter *pm = icalproperty_get_first_parameter(p, ICAL_ANY_PARAMETER);
    
    while (pm) {
        
        NSString * keyvaluepair = [NSString stringWithCString:icalparameter_as_ical_string(pm)
                                                  encoding:NSASCIIStringEncoding];
        
        NSArray * arr = [keyvaluepair componentsSeparatedByString:@"="];
        
        if (arr.count > 1) {
            [parameters setObject: arr[1] forKey:arr[0]];
        }

        pm = icalproperty_get_next_parameter(p, ICAL_ANY_PARAMETER);
    
    }
                                                         
    
    
    return [NSDictionary dictionaryWithDictionary:parameters];
    
}

#pragma mark - Value Primatives

-(NSDate *) dateFromValue: (icalvalue *) v parameters: (NSDictionary *) parameters{
    struct icaltimetype t = icalvalue_get_datetime(v);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:t.year];
    [components setMonth: t.month];
    [components setDay:t.day];
    [components setHour:t.hour];
    [components setMinute: t.minute];
    [components setSecond: t.second];
    
    if (t.is_utc) {
        [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    else {
        
        NSString * tzid = parameters[@"TZID"];
        if (tzid) {
            NSTimeZone * tz = [NSTimeZone timeZoneWithName:tzid];
            [components setTimeZone: tz];
        }
        else {
            [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
            
        }
    }

   
   // t.is_daylight
   // t.is_date
    
    return [calendar dateFromComponents: components];
    
}

-(NSNumber *) numberFromIntValue: (icalvalue *) v {
    
    return [NSNumber numberWithInt: icalvalue_get_integer(v)];
    
}


-(NSString *) stringFromValue: (icalvalue *) v {
    return [NSString stringWithCString: icalvalue_as_ical_string(v) encoding: NSASCIIStringEncoding];
}


#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Key: %@, Value: %@, Parameters: %@",
            NSStringFromClass([self class]), self, self.key, self.value, self.parameters];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    XbICProperty *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        object.value = [self.key copyWithZone:zone];
        
        if ([self.value respondsToSelector:@selector(copyWithZone:)]) {
            object.value = [(id) self.value copyWithZone:zone];
        }
        else {
            object.value = self.value;
        }
        
        object.parameters = [self.parameters copyWithZone:zone];
    }
    
    return object;
}


@end
