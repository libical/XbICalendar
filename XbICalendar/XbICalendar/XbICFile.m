//
//  XbICFile.m
//

#import "XBICalendar.h"


@interface XbICFile ()

@property (nonatomic, copy) NSString * pathname;

@property (nonatomic, assign) XbICComponent *icsFileRoot;

@end

@implementation XbICFile


- (instancetype)initWithPathname:(NSString *)pathname {
    
    self = [super init];
    if (self) {
        self.pathname = pathname;
        
    
        NSBundle *pluginBundle = [NSBundle bundleForClass: [XbICFile class]];
        NSString *zoneinfoPath = [NSString stringWithFormat: @"%@/zoneinfo", [pluginBundle resourcePath]];
        set_zone_directory((char *)[zoneinfoPath cStringUsingEncoding:NSUTF8StringEncoding]);
        
        //TODO: Need to check this is configured properly
        
    }
    
    return self;
    
}


+ (instancetype)fileWithPathname:(NSString *)pathname {
    
    return [[XbICFile alloc]initWithPathname:pathname];
    
}


- (BOOL) read {
    
    BOOL result = NO;
    
    NSString * caldata = [NSString stringWithContentsOfFile:self.pathname
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    if (caldata) {
        
        icalcomponent *root = icalparser_parse_string([caldata cStringUsingEncoding:NSUTF8StringEncoding]);
   
        if (root) {
            self.icsFileRoot = [XbICComponent componentWithIcalComponent: root];
            result = YES;;
            
            icalcomponent_free(root);
        }
    }
    return result;
}


- (BOOL) save {
    
    return NO;
    
}


#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Pathname: %@", NSStringFromClass([self class]), self, self.pathname];
}

- (id)copyWithZone:(NSZone *)zone {
    XbICFile *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        object.pathname = [self.pathname copyWithZone:zone];
    }
    
    return object;
}

@end
