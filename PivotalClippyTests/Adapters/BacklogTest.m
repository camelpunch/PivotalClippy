#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "RecordingDelegate.h"
#import "Backlog.h"
#import "Story.h"
#import "Preferences.h"
#import "NSNumber+TimeExpiry.h"

@interface BacklogTest : XCTestCase
@end

@implementation BacklogTest {
    id delegate;
    id fetcher;
    NSURL *url;
    Backlog *backlog;
    Story *eligibleStory;
    Preferences *prefs;
}

- (void)testRequestsJSON
{
    fetcher = [OCMockObject mockForProtocol:@protocol(URLFetcher)];
    backlog = [[Backlog alloc] initWithURLFetcher:fetcher];

    prefs = [[Preferences alloc] initWithUsername:@"brucie"
                                            token:@"sometoken"
                                        projectID:@"99999"];

    url = [NSURL URLWithString:
           @"https://www.pivotaltracker.com/"
           "services/v5/projects/99999/stories?filter=mywork%3Abrucie+state%3Astarted&limit=1"];

    [[fetcher expect] fetchFromURL:url headers:@{@"X-Tracker-Token": @"sometoken"}];
    [backlog repository:nil didFetchItem:prefs];
    [fetcher verify];
}

- (void)testCallsDelegateOnSuccessfulResponse
{
    backlog = [[Backlog alloc] initWithURLFetcher:nil];
    eligibleStory = [[Story alloc] initWithStoryID:@59622372
                                              name:@"Eligible story"];
    delegate = [OCMockObject mockForProtocol:@protocol(RepositoryDelegate)];
    backlog.delegate = delegate;

    prefs = [[Preferences alloc] initWithUsername:@"brucie"
                                            token:@"unrestricted-project-token-sadly-doesn't-matter"
                                        projectID:@"943206"];
    [backlog repository:nil didFetchItem:prefs];

    [[delegate expect] repository:backlog didFetchItem:eligibleStory];
    [backlog URLFetcher:nil didFetchObject:@[@{@"name": @"Eligible story", @"id": @59622372}]];
    [delegate verify];
}

@end
