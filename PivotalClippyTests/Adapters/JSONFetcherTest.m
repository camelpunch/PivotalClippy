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

@end
