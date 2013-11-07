#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Repository.h"
#import "PreferencesController.h"
#import "PreferencesBuilder.h"
#import "Preferences.h"

@interface PreferencesControllerTest : XCTestCase
@end

@implementation PreferencesControllerTest {
    PreferencesController *controller;
    id repo;
    PreferencesBuilder *builder;
    Preferences *prefs;
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

    builder = [[PreferencesBuilder alloc] init];
    builder.username = @"myusername";
    builder.token = @"";
    builder.projectID = @"";

    controller.username.stringValue = @"myusername";

    [[repo expect] put:[builder build]];
    [controller usernameDidBlur:nil];
    [repo verify];

    builder.token = @"mytoken";

    controller.token.stringValue = @"mytoken";

    [[repo expect] put:[builder build]];
    [controller tokenDidBlur:nil];
    [repo verify];

    builder.projectID = @"123123";

    controller.projectID.stringValue = @"123123";

    [[repo expect] put:[builder build]];
    [controller projectIDDidBlur:nil];
    [repo verify];
}

@end
