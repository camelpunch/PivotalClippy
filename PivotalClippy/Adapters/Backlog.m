#import "Backlog.h"
#import "JSONFetcher.h"
#import "Story.h"
#import "Preferences.h"

@interface Backlog ()
@property (nonatomic) JSONFetcher *fetcher;
@end

@implementation Backlog
@synthesize delegate;

- (id)initWithURLFetcher:(id <URLFetcher>)fetcher
{
    self = [super init];
    if (self) {
        self.fetcher = fetcher;
    }
    return self;
}

#pragma mark - <RepositoryDelegate>

- (void)repository:(id <Repository>)prefsRepo
      didFetchItem:(Preferences *)prefs
{
    [self.fetcher fetchFromURL:[self urlWithProjectID:prefs.projectID storyOwner:prefs.username]
                       headers:@{@"X-Tracker-Token": prefs.token}];
}

#pragma mark - <URLFetcherDelegate>

- (void)URLFetcher:(id <URLFetcher>)fetcher
    didFetchObject:(NSArray *)rawStories
{
    NSDictionary *rawStory = rawStories[0];
    Story *story = [[Story alloc] initWithStoryID:rawStory[@"id"]
                                             name:rawStory[@"name"]];
    [self.delegate repository:self
                 didFetchItem:story];
}

#pragma mark - <NSObject>

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSURL *)urlWithProjectID:(NSString *)projectID
                 storyOwner:(NSString *)storyOwner
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/"
                           "services/v5/projects/%@/stories?filter=%@&limit=1",
                           projectID, [self filterWithStoryOwner:storyOwner]];
    return [NSURL URLWithString:urlString];
}

- (NSString *)filterWithStoryOwner:(NSString *)storyOwner
{
    return [NSString stringWithFormat:@"mywork%%3A%@+state%%3Astarted", storyOwner];
}

@end
