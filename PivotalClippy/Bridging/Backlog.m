#import "User.h"
#import "Backlog.h"
#import "Story.h"
#import "Preferences.h"
#import "KSPromise.h"
#import "KSDeferred.h"

@interface Backlog ()
@property (nonatomic) id <URLFetcher> fetcher;
@property (nonatomic) id <Repository> prefsRepo;
@end

@implementation Backlog

- (id)initWithURLFetcher:(id<URLFetcher>)fetcher
   preferencesRepository:(id<Repository>)prefsRepo
{
    self = [super init];
    if (self) {
        self.fetcher = fetcher;
        self.prefsRepo = prefsRepo;
    }
    return self;
}

- (KSPromise *)fetchCurrentStoryForUser:(User *)aUser
{
    KSDeferred *deferred = [KSDeferred defer];

    __weak __typeof(self) weakSelf = self;
    [[self.prefsRepo fetch]

     then:^id(Preferences *prefs) {
         NSURL *url = [weakSelf urlWithProjectID:prefs.projectID];
         NSDictionary *headers = @{@"X-TrackerToken": prefs.token};
         [[weakSelf.fetcher fetchFromURL:url
                                 headers:headers]

          then:^id(NSArray *rawStories) {
              NSArray *stories = [weakSelf hydratedStories:rawStories
                                                   ownedBy:aUser];

              if (stories.count > 0) {
                  [deferred resolveWithValue:stories[0]];
              } else {
                  [deferred rejectWithError:[weakSelf emptyResponseError]];
              }

              return nil;
          }

          error:^id(NSError *error) {
              [deferred rejectWithError:error];
              return nil;
          }];

         return nil;
     }

     error:nil];

    return deferred.promise;
}

#pragma mark - <NSObject>

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSError *)emptyResponseError
{
    return [NSError errorWithDomain:@"com.camelpunch.www"
                               code:0
                           userInfo:@{NSLocalizedDescriptionKey: @"No stories in progress"}];
}

- (NSURL *)urlWithProjectID:(NSString *)projectID
{
    NSString *urlString = [NSString stringWithFormat:@"https://www.pivotaltracker.com/"
                           "services/v5/projects/%@/stories?with_state=started",
                           projectID];
    return [NSURL URLWithString:urlString];
}

- (NSArray *)hydratedStories:(NSArray *)rawStories
                     ownedBy:(User *)anOwner
{
    NSMutableArray *stories = [NSMutableArray array];
    [rawStories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = [[User alloc] initWithID:obj[@"owned_by_id"]
                                     username:nil];
        [stories addObject:[[Story alloc] initWithStoryID:obj[@"id"]
                                                     name:obj[@"name"]
                                                    owner:user]];
    }];
    
    NSPredicate *ownerMatches =
    [NSPredicate predicateWithFormat:@"ownerID = %@", anOwner.userID];

    NSArray *filteredStories = [stories filteredArrayUsingPredicate:ownerMatches];
    return filteredStories;
}

@end
