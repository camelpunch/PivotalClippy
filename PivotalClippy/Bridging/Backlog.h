@import Foundation;
#import "Repository.h"
#import "URLFetcher.h"

@class User;
@interface Backlog : NSObject <StoryRepository>

- (id)initWithURLFetcher:(id<URLFetcher>)fetcher
   preferencesRepository:(id<Repository>)prefsRepo;

- (KSPromise *)fetchCurrentStoryForUser:(User *)aUser;

@end
