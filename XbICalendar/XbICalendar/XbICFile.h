//
//  XbICFile.h
//
#import "ical.h"
#import "XbICComponent.h"
#import "XbICVCalendar.h"

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
 Convenience initializer for creating an XbICFile instance with a defined filename.
 
 @param filename The name of the underlaying file.
 @return A new XbICFile instance initialized with the corresponding filename.
 */
+ (instancetype)fileWithPathname:(NSString *)filename;

/**
 Read the ICS data from the file, parsing the file, instatiating
 @return The ICS object structure, nil if there was an error processing the file.
 */
- (XbICComponent *) read;


/**
 Write the given ICS object structure to the file in the ICS file format
 @param vCalendar data structure to write to the file
 */
- (BOOL) writeVCalendar: (XbICVCalendar *) vCalendar;


@end


