#import "Backlog.h"
#import "Story.h"
#import "Preferences.h"

@implementation Backlog
@synthesize delegate;

#pragma mark - <RepositoryDelegate>

- (void)repository:(id <Repository>)prefsRepo
      didFetchItem:(Preferences *)prefs
{
    NSURLSessionConfiguration *config =
    [NSURLSessionConfiguration defaultSessionConfiguration];

    [config setHTTPAdditionalHeaders:@{@"X-Tracker-Token": prefs.token}];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    Backlog * __weak weakSelf = self;
    [[session dataTaskWithURL:[self urlWithProjectID:prefs.projectID storyOwner:prefs.username]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSArray *rawStories = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];
                NSDictionary *rawStory = rawStories[0];
                Story *story = [[Story alloc] initWithStoryID:rawStory[@"id"]
                                                         name:rawStory[@"name"]];
                [weakSelf.delegate repository:weakSelf
                                 didFetchItem:story];
            }] resume];
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
