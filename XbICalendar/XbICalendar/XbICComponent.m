//
//  XbICComponent.m
//

#import "XbICComponent.h"
#import "XbICVCalendar.h"
#import "XbICVEvent.h"


@interface XbICComponent ()


@end

@implementation XbICComponent

-(instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype) componentFactory: (icalcomponent *) c {
    XbICComponent * component;
    switch ( icalcomponent_isa(c)) {
        case ICAL_VCALENDAR_COMPONENT:
            component = [[XbICVCalendar alloc] init];
            break;
            
        case ICAL_VEVENT_COMPONENT:
            component = [[XbICVEvent alloc] init];
            break;
            
        default:
            component = [[XbICComponent alloc]init];
            break;
    }
    return component;
}
+(instancetype)componentWithIcalComponent: (icalcomponent *) c {
    
    XbICComponent * component = [XbICComponent componentFactory: c];

    if (component) {
        component.kind = icalcomponent_isa(c);
        NSMutableArray * propertyList = [[NSMutableArray alloc] init];
        NSMutableArray * childComponentList = [[NSMutableArray alloc] init];
        icalproperty* p = icalcomponent_get_first_property(c, ICAL_ANY_PROPERTY);
        
        while (p) {
            
            XbICProperty * property = [XbICProperty propertyWithIcalProperty: p];
            
            if (property) {
                [propertyList addObject:property];
            }
            
            p = icalcomponent_get_next_property(c, ICAL_ANY_PROPERTY);
            
        }
        
        component.properties = [NSArray arrayWithArray: propertyList];
        
        icalcomponent * child_c = icalcomponent_get_first_component(c, ICAL_ANY_COMPONENT);
        
        while (child_c) {
            
            XbICComponent * childComponent = [XbICComponent componentWithIcalComponent:child_c];
            
            if (childComponent) {
                [childComponentList addObject: childComponent];
            }
            child_c = icalcomponent_get_next_component(c,ICAL_ANY_COMPONENT);
        }
        
        component.subcomponents = [NSArray arrayWithArray: childComponentList];
        
    }
    
    return component;
}

- (NSArray *) propertiesOfKind: (icalproperty_kind) kind {
    NSMutableArray * results =[[NSMutableArray alloc] init];
    
    for (XbICProperty * property in self.properties) {
        if (property.kind == kind) {
            [results addObject: property];
        }
    }
    
    return results;
}

- (NSArray *) componentsOfKind: (icalcomponent_kind) kind {
    NSMutableArray * results =[[NSMutableArray alloc] init];
    
    for (XbICComponent * component in self.subcomponents) {
        if (component.kind == kind) {
            [results addObject: component];
        }
    }
    
    return results;
}


#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Key: %d",
            NSStringFromClass([self class]), self, self.kind];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    XbICComponent *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        object.subcomponents = [self.subcomponents copyWithZone: zone];
        object.properties = [self.properties copyWithZone:zone];
        
    }
    
    return object;
}


@end
