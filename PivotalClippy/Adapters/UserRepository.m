#import "UserRepository.h"
#import "User.h"
#import "URLFetcher.h"
#import "KSDeferred.h"
#import "Preferences.h"


@interface UserRepository ()

@property (nonatomic) id<Repository> prefsRepo;
@property (nonatomic) id<URLFetcher> urlFetcher;

@end


@implementation UserRepository

- (id)initWithPreferencesRepository:(id<Repository>)aPrefsRepo
                         urlFetcher:(id<URLFetcher>)aUrlFetcher
{
    self = [super init];
    if (self) {
        self.prefsRepo = aPrefsRepo;
        self.urlFetcher = aUrlFetcher;
    }
    return self;
}

- (KSPromise *)fetch
{
    KSDeferred *deferred = [KSDeferred defer];

    __weak __typeof(self) weakSelf = self;
    [[self.prefsRepo fetch]

     then:^id(Preferences *prefs) {
         NSURL *url = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v5/me"];
         [[weakSelf.urlFetcher fetchFromURL:url
                                    headers:@{@"X-TrackerToken": prefs.token}]

          then:^id(NSDictionary *rawUser) {
              [deferred resolveWithValue:
               [[User alloc] initWithID:rawUser[@"id"]
                               username:rawUser[@"username"]]];
              return nil;
          }

          error:nil];

         return nil;
     }

     error:nil];

    return deferred.promise;
}

@end
