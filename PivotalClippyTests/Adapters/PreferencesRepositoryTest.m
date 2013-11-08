#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Preferences.h"
#import "PreferencesRepository.h"

@interface PreferencesRepositoryTest : XCTestCase
@end

@implementation PreferencesRepositoryTest {
    Preferences *prefs;
    PreferencesRepository *repo;
    id delegate;
}

- (void)testStoresAndRetrievesPreferencesAcrossInstances
{
    prefs = [[Preferences alloc] initWithUsername:@"admin"
                                            token:[[NSProcessInfo new] globallyUniqueString]
                                        projectID:@"890890"];

    repo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool Tests"];
    [repo put:prefs];

    repo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool Tests"];
    delegate = [OCMockObject mockForProtocol:@protocol(RepositoryDelegate)];
    repo.delegate = delegate;

    [[delegate expect] repository:repo didFetchItem:prefs];
    [repo fetchItem];
    [delegate verify];
}

@end
