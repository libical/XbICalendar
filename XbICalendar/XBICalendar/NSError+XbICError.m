//
//  NSError+XbICError.m
//  XbICalendar
//
//  Created by Andrew Halls on 9/16/15.
//  Copyright (c) 2015 GaltSoft. All rights reserved.
//

#import "NSError+XbICError.h"

#define XbICalendarErrorDomain @"XbICalendar"


@implementation NSError (XbICError)

+ (NSError*) errorWithCode:(NSUInteger)code message:(NSString*)message {

return [NSError errorWithDomain: XbICalendarErrorDomain
                           code:code
                       userInfo: @{NSLocalizedDescriptionKey: message}
       ];

}

@end
