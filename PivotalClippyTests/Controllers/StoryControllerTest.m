#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "StoryController.h"
#import "StoryBuilder.h"
#import "UserNotification.h"
#import "User.h"
#import "Story.h"
#import "Backlog.h"
#import "KSDeferred.h"
#import "EmptyPromises.h"


@interface StoryControllerTest : XCTestCase
@end


@implementation StoryControllerTest {
    StoryController *controller;

    StoryBuilder *builder;
    EmptyPromiseRepo *userRepo, *copier;
    EmptyPromiseStoryRepo *backlog;
    Story *story;
    User *user;
}

- (void)setUp
{
    [super setUp];
    builder = [StoryBuilder new];
    story = [[[builder storyID:@54321] name:@"Do good work"] build];
    backlog = [EmptyPromiseStoryRepo new];
    copier = [EmptyPromiseRepo new];
    userRepo = [EmptyPromiseRepo new];
    user = [[User alloc] initWithID:@123 username:@"brucie"];
}

- (void)testFetchesStoryForCurrentUser
{
    id backlogMock = [OCMockObject mockForProtocol:@protocol(StoryRepository)];
    controller = [[StoryController alloc] initWithCopier:nil
                                                notifier:nil
                                          userRepository:userRepo
                                                 backlog:backlogMock];
    [controller copyCurrentUsersStory];

    [[backlogMock expect] fetchCurrentStoryForUser:user];
    [userRepo.fetchDeferred resolveWithValue:user];
    [backlogMock verify];
}

- (void)testCopiesUsersCurrentStoryToClipboard
{
    id copierMock = [OCMockObject mockForProtocol:@protocol(Repository)];
    controller = [[StoryController alloc] initWithCopier:copierMock
                                                notifier:nil
                                          userRepository:userRepo
                                                 backlog:backlog];
    [controller copyCurrentUsersStory];
    [userRepo.fetchDeferred resolveWithValue:nil];

    [[copierMock expect] put:story.storyID];
    [backlog.deferred resolveWithValue:story];
    [copierMock verify];
}

- (void)testSuccessfulCopyShowsAlert
{
    id userNotifierMock = [OCMockObject mockForProtocol:@protocol(UserNotification)];
    controller = [[StoryController alloc] initWithCopier:copier
                                                notifier:userNotifierMock
                                          userRepository:userRepo
                                                 backlog:backlog];
    [controller copyCurrentUsersStory];
    [userRepo.fetchDeferred resolveWithValue:nil];
    [backlog.deferred resolveWithValue:nil];

    [[userNotifierMock expect]
     notifyWithTitle:@"Tracker Story ID copied"
     subtitle:@"'someid' copied to clipboard"];

    [copier.putDeferred resolveWithValue:@"someid"];

    [userNotifierMock verify];
}

- (void)testFailureToFetchStoryShowsAlert
{
    id userNotifierMock = [OCMockObject mockForProtocol:@protocol(UserNotification)];
    controller = [[StoryController alloc] initWithCopier:copier
                                                notifier:userNotifierMock
                                          userRepository:userRepo
                                                 backlog:backlog];
    [controller copyCurrentUsersStory];
    [userRepo.fetchDeferred resolveWithValue:user];
    [backlog.deferred resolveWithValue:story];

    NSError *error = [NSError errorWithDomain:@"ace"
                                         code:0
                                     userInfo:@{}];
    [[userNotifierMock expect]
     notifyWithTitle:@"Could not copy Tracker Story ID"
     subtitle:@"Perhaps you're not allowed?"];

    [copier.putDeferred rejectWithError:error];

    [userNotifierMock verify];
}

@end
