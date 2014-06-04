//
//  XbICVCalendar.m
//

#import "XbICVCalendar.h"
#import "XbICFile.h"
#import "XbICProperty.h"

@interface XbICVCalendar ()

@end

@implementation XbICVCalendar


#pragma mark - Class Methods

+(instancetype) vCalendarFromFile: (NSString *) pathname  {
    
    XbICFile * file = [XbICFile fileWithPathname:pathname];
    
    XbICVCalendar * vCalendar = (XbICVCalendar *) [file read];
    
    if (vCalendar.kind != ICAL_VCALENDAR_COMPONENT) {
        NSLog(@"Unexpected Component in ICS File");
        return nil;
    }

    if (![[vCalendar version] isEqualToString:@"2.0"] ) {
        NSLog(@"Unexpected ICS File Version");
        return nil;
    }
    
    return vCalendar;
}


#pragma mark - Custom Accessors

-(NSString *) method {
    NSArray * properties = [self propertiesOfKind:ICAL_METHOD_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"Method Error");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}

-(NSString *) version {
    NSArray * properties = [self propertiesOfKind:ICAL_VERSION_PROPERTY];
    if (properties.count != 1 ) {
        NSLog(@"Version Error");
        return nil;
    }
    return (NSString *)[((XbICProperty *)properties[0]) value];
}

#pragma mark - Private Methods




#pragma mark - NSObject Overides
//- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@: %p> Key: %@, Value: %@, Parameters: %@",
//            NSStringFromClass([self class]), self, self.key, self.value, self.parameters];
//}
//
//- (instancetype)copyWithZone:(NSZone *)zone {
//    XbICProperty *object = [[[self class] allocWithZone:zone] init];
//    
//    if (object) {
//        object.value = [self.key copyWithZone:zone];
//        
//        if ([self.value respondsToSelector:@selector(copyWithZone:)]) {
//            object.value = [(id) self.value copyWithZone:zone];
//        }
//        else {
//            object.value = self.value;
//        }
//        
//        object.parameters = [self.parameters copyWithZone:zone];
//    }
//    
//    return object;
//}
//


@end
