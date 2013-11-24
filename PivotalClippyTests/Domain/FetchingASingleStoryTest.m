@import XCTest;
#import <OCMock/OCMock.h>
#import "URLFetcher.h"
#import "Backlog.h"
#import "Preferences.h"
#import "Story.h"
#import "Constants.h"
#import "EmptyPromises.h"
#import "KSDeferred.h"
#import "User.h"
#import "StoryBuilder.h"

@interface FetchingASingleStoryTest : XCTestCase
@end

@implementation FetchingASingleStoryTest {
    Backlog *backlog;

    EmptyPromiseRepo *prefsRepo;
    Preferences *prefs;
    Story *story;
    StoryBuilder *storyBuilder;
    User *user;
    NSURL *expectedURL; 
}

- (void)setUp
{
    [super setUp];
    prefsRepo = [EmptyPromiseRepo new];
    prefs = [[Preferences alloc] initWithUsername:@"brucie"
                                            token:@"returnedtoken"
                                        projectID:@"12345"];
    storyBuilder = [StoryBuilder new];
}

- (void)testStoriesURLIsFetchedWhenPreferencesReturn
{
    id fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];
    backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                            preferencesRepository:prefsRepo];

    user = [[User alloc] initWithID:@1234
                           username:@"brucie"];
    [backlog fetchCurrentStoryForUser:user];

    expectedURL = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v5/projects/12345/stories?with_state=started"];
    [[fetcher expect] fetchFromURL:expectedURL
                           headers:@{@"X-TrackerToken": @"returnedtoken"}];
    [prefsRepo.fetchDeferred resolveWithValue:prefs];
    [fetcher verify];
}

- (void)testFirstMatchingStoryIsDeliveredWhenStoriesResponseContainsStories
{
    id fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];
    backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                            preferencesRepository:prefsRepo];

    KSDeferred *deferredURLFetch = [KSDeferred defer];
    [[[fetcher stub] andReturn:deferredURLFetch.promise]
     fetchFromURL:OCMOCK_ANY
     headers:OCMOCK_ANY];

    user = [[User alloc] initWithID:@1234 username:@"brucie"];
    KSPromise *storyPromise = [backlog fetchCurrentStoryForUser:user];

    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    story = [[[[storyBuilder
                storyID:@65432]
               name:@"sudo make me a sandwich"]
              owner:user]
             build];

    [deferredURLFetch resolveWithValue:@[@{@"id": @54321,
                                           @"name": @"make me a sandwich",
                                           @"owned_by_id": @4321},
                                         @{@"id": @65432,
                                           @"name": @"sudo make me a sandwich",
                                           @"owned_by_id": @1234}]];

    XCTAssertEqualObjects(storyPromise.value, story);
}

- (void)testGeneratesErrorWhenThereAreNoStoriesInResponse
{
    id fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];

    backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                            preferencesRepository:prefsRepo];

    KSDeferred *deferredURLFetch = [KSDeferred defer];
    [[[fetcher stub] andReturn:deferredURLFetch.promise]
     fetchFromURL:OCMOCK_ANY
     headers:OCMOCK_ANY];

    user = [[User alloc] initWithID:@543423 username:@"jim"];
    KSPromise *storyPromise = [backlog fetchCurrentStoryForUser:user];

    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    [deferredURLFetch resolveWithValue:@[]];

    XCTAssert(storyPromise.error);
    XCTAssertEqualObjects(storyPromise.error.localizedDescription,
                          @"No stories in progress");
}

- (void)testPassesErrorThroughWhenStoriesResourceNotFound
{
    id fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];

    backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                            preferencesRepository:prefsRepo];

    KSDeferred *deferredURLFetch = [KSDeferred defer];
    [[[fetcher stub] andReturn:deferredURLFetch.promise]
     fetchFromURL:OCMOCK_ANY
     headers:OCMOCK_ANY];

    user = [[User alloc] initWithID:@543423 username:@"jim"];
    KSPromise *storyPromise = [backlog fetchCurrentStoryForUser:user];

    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    NSError *error = [NSError errorWithDomain:@"somedomain"
                                         code:0
                                     userInfo:@{}];
    [deferredURLFetch rejectWithError:error];
    
    XCTAssertEqualObjects(storyPromise.error, error);
}

@end
