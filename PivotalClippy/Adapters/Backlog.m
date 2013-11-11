#import "Backlog.h"
#import "URLFetcher.h"
#import "Story.h"
#import "Preferences.h"

@interface Backlog ()
@property (nonatomic) id <URLFetcher> fetcher;
@property (nonatomic) id <Repository> prefsRepo;
@property (nonatomic) NSPredicate *predicate;
@end

@implementation Backlog
@synthesize delegate;

- (id)initWithURLFetcher:(id <URLFetcher>)fetcher
   preferencesRepository:(id <Repository>)prefsRepo
{
    self = [super init];
    if (self) {
        self.fetcher = fetcher;
        self.prefsRepo = prefsRepo;
    }
    return self;
}

- (void)fetchFirstStoryInProgressWhere:(NSPredicate *)predicate
{
    self.predicate = predicate; // TODO: tie predicate to request
    [self.prefsRepo fetchItem];
}

#pragma mark - <RepositoryDelegate>

- (void)repository:(id <Repository>)prefsRepo
      didFetchItem:(Preferences *)prefs
{
    [self.fetcher fetchFromURL:[self urlWithProjectID:prefs.projectID]
                       headers:@{@"X-Tracker-Token": prefs.token}];
}

#pragma mark - <URLFetcherDelegate>

- (void)URLFetcher:(id <URLFetcher>)fetcher
    didFetchObject:(NSArray *)rawStories
{
    NSMutableArray *stories = [NSMutableArray array];
    [rawStories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [stories addObject:[[Story alloc] initWithStoryID:obj[@"id"]
                                                     name:obj[@"name"]]];
    }];
    [stories filterUsingPredicate:self.predicate];

    if (stories.count > 0) {
        [self.delegate repository:self
                     didFetchItem:[stories firstObject]];
    } else {
        [self.delegate repository:self didFailToFetchWhere:self.predicate];
    }
}

- (void)URLFetcher:(id<URLFetcher>)fetcher
didFailToFetchWithError:(NSError *)error
{
    [self.delegate repository:self
          didFailToFetchWhere:self.predicate];
}

#pragma mark - <NSObject>

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSURL *)urlWithProjectID:(NSString *)projectID
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/"
                           "services/v5/projects/%@/stories?with_state=started",
                           projectID];
    return [NSURL URLWithString:urlString];
}

@end
