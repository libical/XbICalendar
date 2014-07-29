//
//  XbICProperty.m
//

#import "XBICalendar.h"

@interface XbICProperty ()

@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@end


@implementation XbICProperty

-(instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


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
        
        property.valueKind = icalvalue_isa(v);
        
        if (ICAL_XLICERROR_PROPERTY == property.kind) {
            NSLog(@"Error: %d, %@", property.kind, [property stringFromValue:v]);
            
        }
        
        switch (property.valueKind) {

            case ICAL_DATETIME_VALUE:
                property.value = [property datetimeFromValue: v parameters: property.parameters];
                break;
                
            case ICAL_INTEGER_VALUE:
                property.value = [property numberFromIntValue: v];
                break;
            
            case ICAL_DATE_VALUE:
                property.value = [property dateFromValue: v];
                break;

            case ICAL_RECUR_VALUE:
               property.value = [property stringFromValue: v];
#warning Needs work
                break;
                
            case ICAL_UTCOFFSET_VALUE:
                property.value = [property stringFromValue: v];
#warning Needs work
                break;
                
            case ICAL_PERIOD_VALUE:
                property.value = [property stringFromValue: v];
#warning Needs work
                break;
            case ICAL_DURATION_VALUE:
                property.value = [property stringFromValue: v];
#warning Needs work
                break;
            case ICAL_REQUESTSTATUS_VALUE:
                property.value = [property stringFromValue: v];
#warning Needs work
                break;

            
            case ICAL_NO_VALUE:
                property.value = nil;
                break;
            
            case ICAL_ACTION_VALUE:
            case ICAL_ATTACH_VALUE:
            case ICAL_CALADDRESS_VALUE:
            case ICAL_STATUS_VALUE:
            case ICAL_CLASS_VALUE:
            case ICAL_URI_VALUE:
            case ICAL_TEXT_VALUE:
            case ICAL_STRING_VALUE:
            case ICAL_TRANSP_VALUE:
            case ICAL_METHOD_VALUE:
            case ICAL_X_VALUE:
                property.value = [property stringFromValue: v];
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

-(NSDate *) datetimeFromValue: (icalvalue *) v parameters: (NSDictionary *) parameters{
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

-(NSDate *) dateFromValue: (icalvalue *) v {
    return [self.dateFormatter dateFromString: [self stringFromValue:v]];
}

-(NSNumber *) numberFromIntValue: (icalvalue *) v {
    
    return [NSNumber numberWithInt: icalvalue_get_integer(v)];
    
}


-(NSString *) stringFromValue: (icalvalue *) v {
    return [NSString stringWithCString: icalvalue_as_ical_string(v) encoding: NSASCIIStringEncoding];
}

#pragma mark - custom accessors
-(NSDateFormatter *) dateFormatter {
    if (!_dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        self.dateFormatter.dateFormat = @"yyyyMMdd";
    }
    return _dateFormatter;
}

#pragma mark - Serialize

-(icalvalue *) icalBuildValue {
    icalvalue * value;
    switch (self.valueKind) {
//        case ICAL_ACKNOWLEDGED_PROPERTY:
//        case ICAL_COMPLETED_PROPERTY:
//        case ICAL_CREATED_PROPERTY:
//        case ICAL_DATEMAX_PROPERTY :
//        case ICAL_DATEMIN_PROPERTY:
//        case ICAL_DTEND_PROPERTY:
//        case ICAL_DTSTAMP_PROPERTY:
//        case ICAL_DTSTART_PROPERTY:
//        case ICAL_DUE_PROPERTY:
//        case ICAL_EXDATE_PROPERTY:
//        case ICAL_LASTMODIFIED_PROPERTY:
//        case ICAL_MAXDATE_PROPERTY:
//        case ICAL_MINDATE_PROPERTY:
//        case ICAL_RECURRENCEID_PROPERTY:
//            property.value = [property dateFromValue: v parameters: property.parameters];
//            break;
//            
//        case ICAL_SEQUENCE_PROPERTY:
//            property.value = [property numberFromIntValue: v];
//            break;
//            
//        case ICAL_XLICERROR_PROPERTY:
//            NSLog(@"Error: %d, %@", property.kind, [property stringFromValue:v]);
//            break;
        
        case ICAL_STRING_VALUE:
        default:
            value = icalvalue_new_string([(NSString *)self.value cStringUsingEncoding:(NSASCIIStringEncoding)]);
        break;
    }
    
    return value;
}
-(icalproperty *) icalBuildProperty {
    icalproperty * ical_property = icalproperty_new(self.kind);
    icalproperty_set_value(ical_property, [self icalBuildValue]);
    
//    for (XbICProperty * property in self.properties) {
//        
//        icalproperty * ical_property = [property icalBuildProperty];
//        
//        icalcomponent_add_property(ical_component, ical_property);
//        
//    }
    
    return ical_property;

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
