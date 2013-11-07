#import <Foundation/Foundation.h>
#import "Builder.h"

@interface PreferencesBuilder : NSObject <Builder>

@property (strong, nonatomic, readwrite) NSString *username;
@property (strong, nonatomic, readwrite) NSString *token;
@property (strong, nonatomic, readwrite) NSString *projectID;

@end
