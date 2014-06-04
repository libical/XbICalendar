//
//  XbICFile.h
//
#import "ical.h"
#import "XbICComponent.h"

/**
 The XbICFile class provides an interface to read and write ICalendar (ICS) files.
 */
@interface XbICFile : NSObject <NSCopying>

/**
 Property that stores the full path name of the underlaying file.
 */
@property (nonatomic, readonly) NSString *path;


/**
 Initializes an XbICFile instance and sets the filename.
 
 @param filename The name of the underlaying file.
 @return A new XbICFile instance initialized with the corresponding filename.
 */
- (instancetype)initWithPathname:(NSString *)filename;

/**
 Convenience initializer for creating an NMSFTPFile instance with a defined filename.
 
 @param filename The name of the underlaying file.
 @return A new XbICFile instance initialized with the corresponding filename.
 */
+ (instancetype)fileWithPathname:(NSString *)filename;

/**

 */
- (XbICComponent *) read;


/**
 
 */
- (BOOL) save;

/**
 */
- (XbICComponent *) vCalendar;

@end


