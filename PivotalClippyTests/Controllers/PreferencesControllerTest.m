#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Repository.h"
#import "PreferencesController.h"

@interface PreferencesControllerTest : XCTestCase
@end

@implementation PreferencesControllerTest {
    id repo;
    PreferencesController *controller;
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

@end
