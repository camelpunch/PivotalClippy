#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "URLFetcher.h"
#import "Backlog.h"
#import "Preferences.h"
#import "Story.h"

@interface FetchingASingleStoryTest : XCTestCase
@end

@implementation FetchingASingleStoryTest {
    id delegate;
    id fetcher;
    id prefsRepo;
    Preferences *prefs;
    NSURL *expectedURL;
    NSDictionary *expectedHeaders;
    Backlog *backlog;
    Story *story;
}

- (void)testTriggeringAStoryFetchFetchesPreferencesFirst
{
    prefsRepo = [OCMockObject mockForProtocol:@protocol(Repository)];
    backlog = [[Backlog alloc] initWithURLFetcher:nil
                            preferencesRepository:prefsRepo];

    [[prefsRepo expect] fetchItem];
    [backlog fetchFirstStoryInProgressWhere:nil];
    [prefsRepo verify];
}

- (void)testURLIsFetchedWhenPreferencesReturn
{
    fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];
    backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                            preferencesRepository:nil];

    prefs = [[Preferences alloc] initWithUsername:@"brucie"
                                            token:@"returnedtoken"
                                        projectID:@"12345"];

    NSPredicate *ownerIsBrucie = [NSPredicate predicateWithFormat:@"owner = 'brucie'"];
    [backlog fetchFirstStoryInProgressWhere:ownerIsBrucie];

    expectedURL = [NSURL URLWithString:@"https://www.pivotaltracker.com/services/v5/projects/12345/stories?with_state=started"];
    [[fetcher expect] fetchFromURL:expectedURL headers:@{@"X-Tracker-Token": @"returnedtoken"}];
    [backlog repository:nil didFetchItem:prefs];
    [fetcher verify];
}

- (void)testFirstMatchingStoryIsPassedToDelegateWhenResponseContainsStories
{
    backlog = [[Backlog alloc] initWithURLFetcher:nil
                            preferencesRepository:nil];
    delegate = [OCMockObject mockForProtocol:@protocol(RepositoryDelegate)];
    backlog.delegate = delegate;
    
    NSPredicate *nameIsSudo = [NSPredicate predicateWithFormat:@"name = 'sudo make me a sandwich'"];
    [backlog fetchFirstStoryInProgressWhere:nameIsSudo];

    story = [[Story alloc] initWithStoryID:@65432 name:@"sudo make me a sandwich"];

    [[delegate expect] repository:backlog didFetchItem:story];
    [backlog URLFetcher:nil didFetchObject:@[@{@"id": @54321,
                                               @"name": @"make me a sandwich"},
                                             @{@"id": @65432,
                                               @"name": @"sudo make me a sandwich"}]];
    [delegate verify];
}

- (void)testDelegateReceivesFailureMessageWhenResponseIsEmpty
{
    backlog = [[Backlog alloc] initWithURLFetcher:nil
                            preferencesRepository:nil];
    delegate = [OCMockObject mockForProtocol:@protocol(RepositoryDelegate)];
    backlog.delegate = delegate;

    NSPredicate *nameIsSudo = [NSPredicate predicateWithFormat:@"name = 'sudo make me a sandwich'"];
    [backlog fetchFirstStoryInProgressWhere:nameIsSudo];

    [[delegate expect] repository:backlog didFailToFetchWhere:nameIsSudo];
    [backlog URLFetcher:nil didFetchObject:@[]];
    [delegate verify];
}

@end
