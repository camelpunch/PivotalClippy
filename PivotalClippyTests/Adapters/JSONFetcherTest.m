#import <XCTest/XCTest.h>
#import "JSONFetcher.h"
#import "RecordingDelegate.h"
#import "NSNumber+TimeExpiry.h"

@interface JSONFetcherTest : XCTestCase

@property (nonatomic) NSURL *url;

@end

@implementation JSONFetcherTest {
    JSONFetcher *fetcher;
    RecordingDelegate *delegate;
    NSDate *start;
}

- (void)testFetchesJSONFromTrackerAPI
{
    delegate = [[RecordingDelegate alloc] init];
    fetcher = [[JSONFetcher alloc] init];
    fetcher.delegate = delegate;

    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.pivotaltracker.com/"
                           "services/v5/projects/943206/stories?filter=%@&limit=1",
                           @"mywork%3Abrucie+state%3Astarted"];

    NSURL *url = [NSURL URLWithString:urlString];
    [fetcher fetchFromURL:url headers:@{@"X-Tracker-Token": @"projectistotallyopen"}];

    start = [NSDate date];
    while (!delegate.receivedItem && [@5 secondsNotYetPassedSince:start]) { [@1 secondWait]; }

    NSArray *names = [delegate.receivedItem valueForKey:@"name"];
    XCTAssertEqualObjects(names, @[@"Eligible story"]);
}

- (void)testDelegateIsToldAbout404
{
    delegate = [[RecordingDelegate alloc] init];
    fetcher = [[JSONFetcher alloc] init];
    fetcher.delegate = delegate;

    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.pivotaltracker.com/"
                           "services/v5/projects/999999/stories?filter=%@&limit=1",
                           @"mywork%3Abrucie+state%3Astarted"];

    NSURL *url = [NSURL URLWithString:urlString];
    [fetcher fetchFromURL:url headers:@{@"X-Tracker-Token": @"notgoingtowork"}];

    start = [NSDate date];
    while (!delegate.receivedItem && [@5 secondsNotYetPassedSince:start]) { [@1 secondWait]; }

    NSError *error = delegate.receivedItem;
    XCTAssertEqualObjects(error.localizedDescription, @"Couldn't access resource");
    XCTAssertEqualObjects(error.localizedFailureReason, @"You probably don't have permission.");
}

- (void)testDelegateIsToldAbout400
{
    delegate = [[RecordingDelegate alloc] init];
    fetcher = [[JSONFetcher alloc] init];
    fetcher.delegate = delegate;

    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.pivotaltracker.com/"
                           "services/v5/projects/943206/stories?with_state=foo"];

    NSURL *url = [NSURL URLWithString:urlString];
    [fetcher fetchFromURL:url headers:@{@"X-Tracker-Token": @"notgoingtowork"}];

    start = [NSDate date];
    while (!delegate.receivedItem && [@5 secondsNotYetPassedSince:start]) { [@1 secondWait]; }

    NSError *error = delegate.receivedItem;
    XCTAssertEqualObjects(error.localizedDescription, @"Couldn't access resource");
    XCTAssertEqualObjects(error.localizedFailureReason, @"You probably don't have permission.");
}

@end
