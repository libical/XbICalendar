//
//  XbICFile.m
//

#import "XbICFile.h"
#import "NSError+XbICError.h"

@interface XbICFile ()

@property (nonatomic, copy) NSString * pathname;
@property (nonatomic, strong) NSError *error;

@property (nonatomic, strong) XbICComponent *icsFileRoot;

@end

@implementation XbICFile


- (instancetype)initWithPathname:(NSString *)pathname {
    
    self = [super init];
    if (self) {
        self.pathname = pathname;
     }
    
    return self;
    
}


+ (instancetype)fileWithPathname:(NSString *)pathname {
    
    return [[XbICFile alloc]initWithPathname:pathname];
    
}


- (XbICComponent *) read {

    NSError * lError;

    NSString * caldata = [NSString stringWithContentsOfFile:self.pathname
                                                   encoding:NSUTF8StringEncoding
                                                      error: &lError];

  self.error = lError;

    if (caldata) {
        
        icalcomponent *root = icalparser_parse_string([caldata cStringUsingEncoding: NSUTF8StringEncoding]);
   
        if (root) {
            self.icsFileRoot = [XbICComponent componentWithIcalComponent: root];

            icalrestriction_check(root);
            int errors = icalcomponent_count_errors(root);
            if (errors) {
             self.error = [NSError errorWithCode: XbICErrorCodeBaseICSFileErrors
                                         message: [NSString stringWithFormat:@"Calendar file contains %d erros", errors]];
            }
            icalcomponent_free(root);
        }
    }

    return self.icsFileRoot;
}


- (BOOL) writeVCalendar: (XbICVCalendar *) vCalendar {
    
    NSString * buffer = [vCalendar stringSerializeComponent];
    
    NSError * lError;
    if (![buffer writeToFile:self.pathname atomically:YES  encoding: NSUTF8StringEncoding error: &lError]) {
        self.error = lError;
        return NO;
    }
    
    return YES;
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
        object.error = [self.error copyWithZone:zone];
    }
    
    return object;
}

@end
