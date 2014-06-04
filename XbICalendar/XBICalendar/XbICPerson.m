//
//  XbICPerson.m
//

#import "XbICPerson.h"

@implementation XbICPerson
-(NSString *) emailAddress {
    return (NSString *) self.value;
}
-(NSString *) name {
    return self.parameters[@"CN"];
    
}
-(BOOL) RSVP {
    NSString * value = self.parameters[@"RSVP"];
    return [value isEqualToString:@"TRUE"] ||
           [value isEqualToString:@"1"];
}

@end
