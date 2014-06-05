//
//  XbICFile.m
//

#import "XbICFile.h"


@interface XbICFile ()

@property (nonatomic, copy) NSString * pathname;

@property (nonatomic, strong) XbICComponent *icsFileRoot;

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


- (XbICComponent *) read {
    

    NSString * caldata = [NSString stringWithContentsOfFile:self.pathname
                                                   encoding:NSUTF8StringEncoding
                                                      error:NULL];
    
    if (caldata) {
        
        icalcomponent *root = icalparser_parse_string([caldata cStringUsingEncoding:NSUTF8StringEncoding]);
   
        if (root) {
            self.icsFileRoot = [XbICComponent componentWithIcalComponent: root];

            icalcomponent_free(root);
        }
    }
    return self.icsFileRoot;
}


- (BOOL) save {
    
    return NO;
    
}

- (XbICComponent *) vCalendar {
    
    XbICComponent * result = nil;
    
    if (self.icsFileRoot.kind == ICAL_VCALENDAR_COMPONENT) {
        result  = self.icsFileRoot;
    }
    else if (self.icsFileRoot.kind == ICAL_VCALENDAR_COMPONENT){
        
    }
    else {
        NSLog(@"Empty ICS File or invalid component");
    }
    return result;
}


#pragma mark - NSObject Overides
- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> Pathname: %@", NSStringFromClass([self class]), self, self.pathname];
}

- (id)copyWithZone:(NSZone *)zone {
    XbICFile *object = [[[self class] allocWithZone:zone] init];
    
    if (object) {
        object.pathname = [self.pathname copyWithZone:zone];
        object.icsFileRoot = [self.pathname copyWithZone:zone];
    }
    
    return object;
}

@end
