#import <Foundation/Foundation.h>
#import "Repository.h"

@interface PreferencesRepository : NSObject <Repository>

- (id)initWithAccount:(NSString *)anAccount;

@end
