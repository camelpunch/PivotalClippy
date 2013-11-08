#import <XCTest/XCTest.h>
#import "PollingDelegate.h"
#import "Backlog.h"
#import "Story.h"
#import "Preferences.h"
#import "NSNumber+TimeExpiry.h"

@interface BacklogTest : XCTestCase
@end

@implementation BacklogTest {
    PollingDelegate *delegate;
    Backlog *backlog;
    Story *eligibleStory;
    Preferences *prefs;
    NSDate *start;
}

- (void)testCallsDelegateOnSuccessfulGET
{
    backlog = [[Backlog alloc] init];
    eligibleStory = [[Story alloc] initWithStoryID:@59622372
                                              name:@"Eligible story"];
    delegate = [[PollingDelegate alloc] init];
    backlog.delegate = delegate;

    prefs = [[Preferences alloc] initWithUsername:@"brucie"
                                            token:@"unrestricted-project-token-sadly-doesn't-matter"
                                        projectID:@"943206"];

    [backlog repository:nil didFetchItem:prefs];
    start = [NSDate date];
    while (!delegate.receivedItem && [@5 secondsNotYetPassedSince:start]) { [@1 secondWait]; }

    XCTAssertEqualObjects(eligibleStory, delegate.receivedItem);
}

@end
