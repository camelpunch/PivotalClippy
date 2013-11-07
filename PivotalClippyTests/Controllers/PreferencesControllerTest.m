#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Repository.h"
#import "PreferencesController.h"
#import "Preferences.h"

@interface PreferencesControllerTest : XCTestCase
@end

@implementation PreferencesControllerTest {
    PreferencesController *controller;
    Preferences *prefs;
    id repo;
}

- (void)testFetchesPreviouslyStoredPreferences
{
    repo = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[PreferencesController alloc] initWithRepository:repo];
    [controller loadWindow];

    [[repo expect] fetchItem];
    [controller windowDidLoad];
    [repo verify];
}

- (void)testShowsPreferencesInTextFields
{
    controller = [[PreferencesController alloc] initWithRepository:nil];
    prefs = [[Preferences alloc] initWithUsername:@"bobby"
                                            token:@"mytoken"
                                        projectID:@"234234"];
    [controller loadWindow];

    [controller repository:nil didFetchItem:prefs];

    XCTAssertEqualObjects(@"bobby", controller.username.stringValue);
    XCTAssertEqualObjects(@"mytoken", controller.token.stringValue);
    XCTAssertEqualObjects(@"234234", controller.projectID.stringValue);
}

- (void)testStoresPreferencesOnFieldBlur
{
    repo = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[PreferencesController alloc] initWithRepository:repo];
    [controller loadWindow];

    prefs = [[Preferences alloc] initWithUsername:@"myusername"
                                            token:@"mytoken"
                                        projectID:@"123123"];

    controller.username.stringValue = @"myusername";
    controller.token.stringValue = @"mytoken";
    controller.projectID.stringValue = @"123123";

    [[repo expect] put:prefs];
    [controller usernameDidBlur:nil];
    [repo verify];

    [[repo expect] put:prefs];
    [controller tokenDidBlur:nil];
    [repo verify];

    [[repo expect] put:prefs];
    [controller projectIDDidBlur:nil];
    [repo verify];
}

- (void)testStoresPreferencesWhenWindowCloses
{
    repo = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[PreferencesController alloc] initWithRepository:repo];
    [controller loadWindow];

    controller.username.stringValue = @"myusername";
    controller.token.stringValue = @"mytoken";
    controller.projectID.stringValue = @"567567";

    [[repo expect] put:[[Preferences alloc] initWithUsername:@"myusername"
                                                       token:@"mytoken"
                                                   projectID:@"567567"]];
    [controller windowWillClose:nil];
    [repo verify];
}

@end
