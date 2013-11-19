#import <XCTest/XCTest.h>
#import "Preferences.h"
#import "PreferencesRepository.h"
#import "KSPromise.h"

@interface PreferencesRepositoryTest : XCTestCase
@end

@implementation PreferencesRepositoryTest {
    Preferences *prefs;
    PreferencesRepository *repo;
}

- (void)testStoresAndRetrievesPreferencesAcrossInstances
{
    prefs = [[Preferences alloc] initWithUsername:@"admin"
                                            token:[[NSProcessInfo new] globallyUniqueString]
                                        projectID:@"890890"];

    repo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool Tests"];
    [repo put:prefs];

    repo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool Tests"];
    XCTAssertEqualObjects([repo fetch].value, prefs);
}

@end
