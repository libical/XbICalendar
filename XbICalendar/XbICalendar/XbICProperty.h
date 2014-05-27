//
//  XbICProperty.h
//

#import <Foundation/Foundation.h>

@interface XbICProperty : NSObject

@property (nonatomic, copy) NSString * key;
@property (nonatomic, copy) NSObject * value;
@property (nonatomic, copy) NSDictionary * parameters;
@property (nonatomic, assign) icalproperty_kind kind;


//-(instancetype) initWithKey: (NSString *) key value: (NSObject *) value parameters: (NSDictionary *) parameters;
//+(instancetype) propertyWithKey: (NSString *) key value: (NSObject *) value parameters: (NSDictionary *) parameters;
+(instancetype) propertyWithIcalProperty: (icalproperty *) p;

@end
