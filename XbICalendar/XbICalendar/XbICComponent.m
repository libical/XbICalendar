//
//  XbICComponent.m
//  XbICalendar
//
//  Created by Andrew Halls on 5/27/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import "XBICalendar.h"

@interface XbICComponent ()

@property (nonatomic, assign) NSArray * properties;

@end

@implementation XbICComponent

-(instancetype) init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(instancetype)componentWithIcalComponent: (icalcomponent *) c {
    
    XbICComponent * component = [[XbICComponent alloc] init];

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


@end
