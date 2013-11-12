#import <XCTest/XCTest.h>
#import "UserRepository.h"
#import "User.h"
#import "EmptyPromises.h"
#import "Preferences.h"
#import "KSDeferred.h"
#import "URLFetcher.h"

@interface UserRepositoryTest : XCTestCase
@end

@implementation UserRepositoryTest {
    EmptyPromiseRepo *prefsRepo;
    EmptyPromiseURLFetcher *urlFetcher;
    Preferences *prefs;
    UserRepository *userRepo;
    User *user;
}

- (void)setUp
{
    [super setUp];
    prefsRepo = [EmptyPromiseRepo new];
    urlFetcher = [EmptyPromiseURLFetcher new];
}

- (void)testCallsTrackerAPIWithTokenAndMeURL
{
    userRepo = [[UserRepository alloc] initWithPreferencesRepository:prefsRepo
                                                          urlFetcher:urlFetcher];
    [userRepo fetch];

    prefs = [[Preferences alloc] initWithUsername:@"johnsmith" token:@"asdf" projectID:@"56789"];
    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    XCTAssertEqualObjects(urlFetcher.headers, @{@"X-TrackerToken": @"asdf"});
    XCTAssertEqualObjects(urlFetcher.url, [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v5/me"]);
}

- (void)testHydratesUserFromPreferencesRepoAndTrackerAPI
{
    userRepo = [[UserRepository alloc] initWithPreferencesRepository:prefsRepo
                                                          urlFetcher:urlFetcher];
    KSPromise *promise = [userRepo fetch];

    prefs = [[Preferences alloc] initWithUsername:@"johnsmith" token:@"asdf" projectID:@"56789"];
    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    [urlFetcher.fetchDeferred resolveWithValue:@{@"id": @12345,
                                                 @"username": @"johnsmith"}];

    user = [[User alloc] initWithID:@12345
                           username:@"johnsmith"];
    XCTAssertEqualObjects(promise.value, user);
}

@end
