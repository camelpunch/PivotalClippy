#import <Foundation/Foundation.h>
#import "Repository.h"

@protocol URLFetcher;
@interface UserRepository : NSObject <Repository>

- (id)initWithPreferencesRepository:(id<Repository>)aPrefsRepo
                         urlFetcher:(id<URLFetcher>)aUrlFetcher;

@end
