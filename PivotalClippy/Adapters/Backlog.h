#import <Foundation/Foundation.h>
#import "Repository.h"
#import "JSONFetcher.h"

@interface Backlog : NSObject <Repository, RepositoryDelegate, URLFetcherDelegate>

- (id)initWithURLFetcher:(id <URLFetcher>)fetcher
   preferencesRepository:(id <Repository>)prefsRepo;

- (void)fetchFirstStoryInProgressWhere:(NSPredicate *)predicate;

@end
