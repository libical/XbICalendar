//
//  NSError+XbICError.h
//  XbICalendar
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, XbICErrorCode) {
  XbICErrorCodeBase = 9000,
  XbICErrorCodeBaseICSFileErrors
};


@interface NSError (XbICError)

+ (NSError*) errorWithCode:(NSUInteger)value message:(NSString*)message;

@end
