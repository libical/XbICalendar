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

-(icaltimetype ) icaltimetypeFromObject:(id) date {
    icaltimetype   t = icaltime_today();
    if ([date isKindOfClass:[NSDate class]]) {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:unitFlags fromDate:date];
    t.year =  (int)[components year];
    t.month = (int)[components month];
    t.day =   (int)[components day];
    t.hour =  (int)[components hour];
    t.minute = (int)[components minute];
    t.second = (int)[components second];
    
    icaltime_set_timezone(&t, icaltimezone_get_utc_timezone());
    }
    else {
        NSLog(@"Error: invalid date format");
    }
    return t;
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

//- (icalvalue *)valueForAttachFalue {
//    icalvalue *value = nil;
//
//        icalattach *attach;
//        
//        attach = icalattach_new_from_url ([self cstringFromObject: self.value]);
//        if (!attach) return value;
//        value = icalvalue_new_attach (attach);
//        icalattach_unref (attach);
//
//    return value;
//}

-(icalvalue *) icalBuildValue {
    icalvalue * value;
    switch (self.valueKind) {
            
        case ICAL_DATETIME_VALUE:
            value = icalvalue_new_datetime([self icaltimetypeFromObject: self.value]);
            break;

        case ICAL_INTEGER_VALUE:
            value = icalvalue_new_integer( [self integerFromObject: self.value]);
        //    break;
            
        case ICAL_DATE_VALUE:

            value = icalvalue_new_date([self icaltimetypeFromObject:self.value]);
            break;
            
        case ICAL_RECUR_VALUE:
            
#warning Needs work
         //   break;
            
        case ICAL_UTCOFFSET_VALUE:
            
#warning Needs work
//break;
            
        case ICAL_PERIOD_VALUE:
            
#warning Needs work
//break;
        case ICAL_DURATION_VALUE:
            
#warning Needs work
          //  break;
        case ICAL_REQUESTSTATUS_VALUE:
            
#warning Needs work
          //  break;
            
            
        case ICAL_NO_VALUE:
#warning Needs Work

         //   break;
            
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
            value = icalvalue_new_from_string(self.valueKind, [self cstringFromObject:self.value]);
            
            default:
             value = icalvalue_new_string([(NSString *)self.value cStringUsingEncoding:(NSASCIIStringEncoding)]);
            break;
    }
    
    return value;
}
-(icalproperty *) icalBuildProperty {
    icalproperty * ical_property = icalproperty_new(self.kind);
    icalproperty_set_value(ical_property, [self icalBuildValue]);
    
    for (NSString * key in self.parameters) {
        NSString * value = self.parameters[key];
        
        icalparameter * ical_parameter =
            icalparameter_new_from_string([self cstringFromObject:[NSString stringWithFormat:@"%@=%@", key, value]]);
        
        icalproperty_add_parameter(ical_property, ical_parameter);
        
    }
    
    return ical_property;
    
}
    
#pragma mark - Helper Methods
-(const char *) cstringFromObject: (id) string {
    if ([string isKindOfClass:[NSString class]]) {
           return [(NSString *)string cStringUsingEncoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"Error: unknown type");
        return "";
    }
}

-(int) integerFromObject: (id) number {
    int result = 0;
    if ([number isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber *) number intValue];
    }
    return result;
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
-(BOOL) isEqual: (XbICProperty *) property {
    
    if (self.kind != property.kind) {
        return NO;
    }
    if (self.valueKind != property.valueKind) {
        return NO;
    }
    
    if ([self.value isKindOfClass:[NSString class]]) {
        if (![(NSString *)self.value isEqualToString: (NSString *) property.value ]) {
            return NO;
        }
        
    } else if ([self.value isKindOfClass:[NSDate class]]) {
        if (![(NSDate *) self.value isEqualToDate:(NSDate *) property.value]) {
            return NO;
        }
    }
    else {
        if (![self.value isEqual:property.value]) {
            return NO;
        }
    }
    
    if (![self.parameters isEqualToDictionary:property.parameters]) {
        return NO;
    }
        
    return YES;
}

@end
