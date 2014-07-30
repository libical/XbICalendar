//
//  XbICComponent.h
//

#import "ical.h"

@interface XbICComponent : NSObject

@property (nonatomic, strong) NSArray * subcomponents;

@property (nonatomic, strong) NSArray * properties;

@property (nonatomic, assign) icalcomponent_kind kind;


+(instancetype)componentWithIcalComponent: (icalcomponent *) c;

+(instancetype) componentWithString: (NSString *) content;

- (NSArray *) propertiesOfKind: (icalproperty_kind) kind;

- (NSArray *) componentsOfKind: (icalcomponent_kind) kind;

-(instancetype) firstComponentOfKind: (icalcomponent_kind) kind;

-(icalcomponent *) icalBuildComponent;

-(NSString *) stringSerializeComponent;




@end
