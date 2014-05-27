//
//  XbICComponent.h
//  XbICalendar
//
//  Created by Andrew Halls on 5/27/14.
//  Copyright (c) 2014 GaltSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XbICComponent : NSObject

@property (nonatomic, strong) NSArray * subcomponents;

@property (nonatomic, assign) icalcomponent_kind kind;


+(instancetype)componentWithIcalComponent: (icalcomponent *) c;



@end
