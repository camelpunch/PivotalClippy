#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "StoryController.h"
#import "UserNotification.h"

@interface StoryControllerTest : XCTestCase
@end

@implementation StoryControllerTest {
    id userNotifier;
    StoryController *controller;
}

- (void)testSuccessfulCopyShowsAlert
{
    userNotifier = [OCMockObject mockForProtocol:@protocol(UserNotification)];

    controller = [[StoryController alloc] initWithCopier:nil
                                                notifier:userNotifier];

    [[userNotifier expect] notifyWithTitle:@"Tracker Story ID copied"
                                  subtitle:@"'someid' copied to clipboard"];
    [controller repository:nil didPutItem:@"someid"];
    [userNotifier verify];
}

- (void)testFailureToFetchStoryShowsAlert
{
    userNotifier = [OCMockObject mockForProtocol:@protocol(UserNotification)];

    controller = [[StoryController alloc] initWithCopier:nil
                                                notifier:userNotifier];

    [[userNotifier expect] notifyWithTitle:@"Could not copy Tracker Story ID"
                                  subtitle:@"Perhaps you're not allowed?"];
    [controller repository:nil didFailToFetchWhere:nil];
    [userNotifier verify];
}

@end
