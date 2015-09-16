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

-(void) dealloc {
  self.value = nil;
  self.parameters = nil;
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
                property.value = [property recurFromValue: v];
                break;
                
            case ICAL_UTCOFFSET_VALUE:
                property.value = [property utcoffsetFromValue: v];
                break;
                
            case ICAL_PERIOD_VALUE:
                property.value = [property periodFromValue:v];
                break;
                
            case ICAL_DURATION_VALUE:
                property.value = [property durationFromValue: v];
                break;
                
            case ICAL_REQUESTSTATUS_VALUE:
                property.value = [property requeststatusFromValue: v];
                break;
                
            case ICAL_X_VALUE:
                property.value = [property stringFromValue: v];
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
                                                     encoding:NSUTF8StringEncoding];
        
        NSArray * arr = [keyvaluepair componentsSeparatedByString:@"="];
        
        if (arr.count > 1) {
            [parameters setObject: arr[1] forKey:arr[0]];
        }
        
        pm = icalproperty_get_next_parameter(p, ICAL_ANY_PARAMETER);
        
    }
    
    return [NSDictionary dictionaryWithDictionary:parameters];
    
}

#pragma mark - Value Primatives

-(NSDate *) datetimeFromValue: (icalvalue *) v parameters: (NSDictionary *) parameters {
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
    NSDate * date =[calendar dateFromComponents: components];
    return date;
    
}

-(NSDate *) dateFromValue: (icalvalue *) v {
    return [self.dateFormatter dateFromString: [self stringFromValue:v]];
}

-(icaltimetype ) icaltimetypeFromObject:(id) date isDate:(BOOL) isDate {
    icaltimetype   t = icaltime_null_time();
    if ([date isKindOfClass:[NSDate class]]) {
        unsigned unitFlags = (isDate) ? NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit :
        NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit |NSTimeZoneCalendarUnit ;
        
        NSCalendar * calendar = [NSCalendar currentCalendar];
        [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDateComponents *components = [calendar components:unitFlags fromDate:date];
        t.year =  (int)[components year];
        t.month = (int)[components month];
        t.day =   (int)[components day];
        t.hour =  (int)[components hour];
        t.minute = (int)[components minute];
        t.second = (int)[components second];
        
        t.is_date = isDate;
        
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
    return [NSString stringWithCString: icalvalue_as_ical_string(v) encoding: NSUTF8StringEncoding];
}

-(NSDictionary *) recurFromValue: (icalvalue *) v {
    struct icalrecurrencetype ical_recur = icalvalue_get_recur(v);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSNumber numberWithInt:ical_recur.freq] forKey:@"freq"];
    [dictionary setObject:[self datetimeFromTimeType:ical_recur.until] forKey:@"until"];
    [dictionary setObject:[NSNumber numberWithInt:ical_recur.count] forKey:@"count"];
    [dictionary setObject:[NSNumber numberWithShort:ical_recur.interval] forKey:@"interval"];
    [dictionary setObject:[NSNumber numberWithInt:ical_recur.week_start] forKey:@"week_start"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_second count:ICAL_BY_SECOND_SIZE] forKey:@"by_second"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_minute count:ICAL_BY_MINUTE_SIZE] forKeyedSubscript:@"by_minute"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_hour count:ICAL_BY_HOUR_SIZE] forKeyedSubscript:@"by_hour"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_day count:ICAL_BY_DAY_SIZE] forKeyedSubscript:@"by_day"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_month_day count:ICAL_BY_MONTHDAY_SIZE] forKeyedSubscript:@"by_month_day"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_year_day count:ICAL_BY_YEARDAY_SIZE] forKeyedSubscript:@"by_year_day"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_week_no count:ICAL_BY_WEEKNO_SIZE] forKeyedSubscript:@"by_week_no"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_month count:ICAL_BY_MONTH_SIZE] forKeyedSubscript:@"by_month"];
    [dictionary setObject:[self arrayFromCShortArray:ical_recur.by_set_pos count:ICAL_BY_SETPOS_SIZE] forKeyedSubscript:@"by_set_pos"];
    if (ical_recur.rscale) {
        [dictionary setObject:[NSString stringWithCString: ical_recur.rscale encoding: NSUTF8StringEncoding] forKey:@"rscale"];
    }
    [dictionary setObject:[NSNumber numberWithInt:ical_recur.skip] forKey:@"skip"];
    
    return dictionary;
}

-(struct icalrecurrencetype) icalrecurrencetypeFromObject:(id) recur {
    struct icalrecurrencetype ical_recur = icalrecurrencetype_from_string("");
    
    ical_recur.freq = [recur[@"freq"] intValue];
    ical_recur.until = [self icaltimetypeFromObject:recur[@"until"] isDate:NO];
    ical_recur.count = [recur[@"count"] intValue];
    ical_recur.interval = [recur[@"interval"] intValue];
    ical_recur.week_start = (icalrecurrencetype_weekday)[recur[@"week_start"] intValue];
    [self cshortArrayFromArray:recur[@"by_second"] cshortArray:ical_recur.by_second];
    [self cshortArrayFromArray:recur[@"by_minute"] cshortArray:ical_recur.by_minute];
    [self cshortArrayFromArray:recur[@"by_hour"] cshortArray:ical_recur.by_hour];
    [self cshortArrayFromArray:recur[@"by_day"] cshortArray:ical_recur.by_day];
    [self cshortArrayFromArray:recur[@"by_month_day"] cshortArray:ical_recur.by_month_day];
    [self cshortArrayFromArray:recur[@"by_year_day"] cshortArray:ical_recur.by_year_day];
    [self cshortArrayFromArray:recur[@"by_week_no"] cshortArray:ical_recur.by_week_no];
    [self cshortArrayFromArray:recur[@"by_month"] cshortArray:ical_recur.by_month];
    [self cshortArrayFromArray:recur[@"by_set_pos"] cshortArray:ical_recur.by_set_pos];
    if (recur[@"rscale"]) {
        ical_recur.rscale = (char *)[recur[@"rscale"] cStringUsingEncoding:NSUTF8StringEncoding];
    }
    ical_recur.skip = [recur[@"skip"] intValue];
    
    return ical_recur;
}

-(NSNumber *) utcoffsetFromValue: (icalvalue *) v {
    int ical_utcoffset = icalvalue_get_utcoffset(v);
    
    return [NSNumber numberWithInt:ical_utcoffset];
}

-(NSDictionary *) periodFromValue: (icalvalue *) v {
    struct icalperiodtype ical_period = icalvalue_get_period(v);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[self datetimeFromTimeType:ical_period.start] forKeyedSubscript:@"start"];
    [dictionary setObject:[self datetimeFromTimeType:ical_period.end] forKeyedSubscript:@"end"];
    [dictionary setObject:[self durationFromDurationType:ical_period.duration] forKeyedSubscript:@"duration"];
    
    return dictionary;
}

-(struct icalperiodtype) icalperiodtypeFromObject:(id) period {
    struct icalperiodtype ical_period = icalperiodtype_null_period();
    
    ical_period.start = [self icaltimetypeFromObject:period[@"start"] isDate:NO];
    ical_period.end = [self icaltimetypeFromObject:period[@"end"] isDate:NO];
    ical_period.duration = [self icaldurationtypeFromObject:period[@"duration"]];
    
    return ical_period;
}

-(NSDictionary *) durationFromValue: (icalvalue *) v {
    struct icaldurationtype ical_duration = icalvalue_get_duration(v);
    
    return [self durationFromDurationType:ical_duration];
}

-(struct icaldurationtype) icaldurationtypeFromObject:(id) duration {
    struct icaldurationtype ical_duration = icaldurationtype_from_int([duration[@"is_neg"] intValue]);
    
    ical_duration.is_neg = [duration[@"is_neg"] intValue];
    ical_duration.weeks = [duration[@"weeks"] intValue];
    ical_duration.days = [duration[@"days"] intValue];
    ical_duration.hours = [duration[@"hours"] intValue];
    ical_duration.minutes = [duration[@"minutes"] intValue];
    ical_duration.seconds = [duration[@"seconds"] intValue];
    
    return ical_duration;
}

-(NSDictionary *) requeststatusFromValue: (icalvalue *) v {
    struct icalreqstattype ical_reqstat = icalvalue_get_requeststatus(v);

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    [dictionary setObject:[NSNumber numberWithInteger:ical_reqstat.code] forKey:@"code"];

//    Debug is a pointer into the calling string, not relevant
//    if (ical_reqstat.debug) {
//        [dictionary setObject:[NSString stringWithCString: ical_reqstat.debug encoding: NSUTF8StringEncoding] forKey:@"debug"];
//
//    }

    if (ical_reqstat.desc) {
        [dictionary setObject:[NSString stringWithCString: ical_reqstat.desc encoding: NSUTF8StringEncoding] forKey:@"desc"];
    }

    return dictionary;
}

-(struct icalreqstattype) icalreqstattypeFromObject:(id) reqstat {
    struct icalreqstattype ical_reqstat;
    
    ical_reqstat.code = [reqstat[@"code"] intValue];
    ical_reqstat.debug = [reqstat[@"debug"] cStringUsingEncoding:NSUTF8StringEncoding];
    ical_reqstat.desc = [reqstat[@"desc"] cStringUsingEncoding:NSUTF8StringEncoding];
    
    return ical_reqstat;
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
            
        case ICAL_DATETIME_VALUE:
            value = icalvalue_new_datetime([self icaltimetypeFromObject: self.value isDate: NO]);
            break;

        case ICAL_INTEGER_VALUE:
            value = icalvalue_new_integer( [self integerFromObject: self.value]);
            break;
            
        case ICAL_DATE_VALUE:

            value = icalvalue_new_date([self icaltimetypeFromObject:self.value isDate:YES]);
            break;
            
        case ICAL_RECUR_VALUE:
            
            value = icalvalue_new_recur([self icalrecurrencetypeFromObject:self.value]);
            break;
            
        case ICAL_UTCOFFSET_VALUE:
            
            value = icalvalue_new_utcoffset([(NSNumber *)self.value intValue]);
            break;
            
        case ICAL_PERIOD_VALUE:
            
            value = icalvalue_new_period([self icalperiodtypeFromObject:self.value]);
            break;
            
        case ICAL_DURATION_VALUE:
            
            value = icalvalue_new_duration([self icaldurationtypeFromObject:self.value]);
            break;
            
        case ICAL_REQUESTSTATUS_VALUE:
            
            value = icalvalue_new_requeststatus([self icalreqstattypeFromObject:self.value]);
            break;
            
        case ICAL_NO_VALUE:

            value = NULL;
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
            value = icalvalue_new_from_string(self.valueKind, [self cstringFromObject:self.value]);
            break;
            
        default:
             value = icalvalue_new_string([(NSString *)self.value cStringUsingEncoding:(NSUTF8StringEncoding)]);
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
    return [NSString stringWithFormat:@"<%@: %p> Value: %@, Kind:%d, ValueKind: %d, Parameters: %@",
            NSStringFromClass([self class]), self, self.value, self.kind, self.valueKind, self.parameters];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    XbICProperty *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        
        object.kind = self.kind;
        object.valueKind = self.valueKind;
        
        if ([self.value respondsToSelector:@selector(copyWithZone:)]) {
            object.value = [(id) self.value copyWithZone:zone];
        }
        else {
            object.value = self.value;
        }
        
        object.parameters = [[NSDictionary alloc] initWithDictionary:self.parameters copyItems:YES];
        
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

-(NSObject *) datetimeFromTimeType: (icaltimetype) t {
    if ((int)icaltime_as_timet(t) == 0) {
        return [NSNull null];
    }
    
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
        NSString * tzid = icaltime_get_tzid(t) ? [NSString stringWithCString: icaltime_get_tzid(t) encoding: NSUTF8StringEncoding] : nil;
        if (tzid) {
            NSTimeZone * tz = [NSTimeZone timeZoneWithName:tzid];
            [components setTimeZone: tz];
        }
        else {
            [components setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        }
    }
    
    NSDate * date =[calendar dateFromComponents: components];
    return date;
}

-(NSDictionary *) durationFromDurationType: (struct icaldurationtype) ical_duration {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSNumber numberWithInt:ical_duration.is_neg] forKey:@"is_neg"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.weeks] forKey:@"weeks"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.days] forKey:@"days"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.hours] forKey:@"hours"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.minutes] forKey:@"minutes"];
    [dictionary setObject:[NSNumber numberWithInteger:ical_duration.seconds] forKey:@"seconds"];
    
    return dictionary;
}

-(NSArray *) arrayFromCShortArray: (short *)cshortArray count: (int)maxCount {
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < maxCount; i++) {
      if (cshortArray[i] == ICAL_RECURRENCE_ARRAY_MAX) {
        break; // for
      }
        NSNumber *number = [[NSNumber alloc] initWithShort:cshortArray[i]];
        [array addObject:number];
    }
    
    return array;
}

-(void) cshortArrayFromArray: (NSArray *)array cshortArray: (short *)cshortArray {
    for (int i = 0; i < array.count; ++i) {
        cshortArray[i] = [[array objectAtIndex:i] shortValue];
    }
}

@end



