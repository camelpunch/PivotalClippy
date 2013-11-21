@import XCTest;
#import <OCMock/OCMock.h>
#import "Repository.h"
#import "PreferencesController.h"
#import "Preferences.h"
#import "EmptyPromises.h"
#import "KSDeferred.h"

@interface PreferencesControllerTest : XCTestCase
@end

@implementation PreferencesControllerTest {
    PreferencesController *controller;
    Preferences *prefs;
    EmptyPromiseRepo *prefsRepo;
}

- (void)setUp
{
    [super setUp];
    prefsRepo = [EmptyPromiseRepo new];
}

- (void)testShowsPreferencesInTextFields
{
    controller = [[PreferencesController alloc] initWithRepository:prefsRepo];
    prefs = [[Preferences alloc] initWithUsername:@"bobby"
                                            token:@"mytoken"
                                        projectID:@"234234"];
    [controller loadWindow];
    [controller windowDidLoad];
    [prefsRepo.fetchDeferred resolveWithValue:prefs];

    XCTAssertEqualObjects(controller.username.stringValue, @"bobby");
    XCTAssertEqualObjects(controller.token.stringValue, @"mytoken");
    XCTAssertEqualObjects(controller.projectID.stringValue, @"234234");
}

- (void)testStoresPreferencesOnFieldBlur
{
    id mockPrefsRepo = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[PreferencesController alloc] initWithRepository:mockPrefsRepo];
    [controller loadWindow];

    prefs = [[Preferences alloc] initWithUsername:@"myusername"
                                            token:@"mytoken"
                                        projectID:@"123123"];

    controller.username.stringValue = @"myusername";
    controller.token.stringValue = @"mytoken";
    controller.projectID.stringValue = @"123123";

    [[mockPrefsRepo expect] put:prefs];
    [controller usernameDidBlur:nil];
    [mockPrefsRepo verify];

    [[mockPrefsRepo expect] put:prefs];
    [controller tokenDidBlur:nil];
    [mockPrefsRepo verify];

    [[mockPrefsRepo expect] put:prefs];
    [controller projectIDDidBlur:nil];
    [mockPrefsRepo verify];
}

- (void)testStoresPreferencesWhenWindowCloses
{
    id mockPrefsRepo = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[PreferencesController alloc] initWithRepository:mockPrefsRepo];
    [controller loadWindow];

    controller.username.stringValue = @"myusername";
    controller.token.stringValue = @"mytoken";
    controller.projectID.stringValue = @"567567";

    [[mockPrefsRepo expect] put:[[Preferences alloc] initWithUsername:@"myusername"
                                                       token:@"mytoken"
                                                   projectID:@"567567"]];
    [controller windowWillClose:nil];
    [mockPrefsRepo verify];
}

@end
