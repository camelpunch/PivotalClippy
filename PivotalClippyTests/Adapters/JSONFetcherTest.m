@import XCTest;
#import "JSONFetcher.h"
#import "NSNumber+TimeExpiry.h"
#import "KSDeferred.h"
#import "EmptyPromises.h"


@interface JSONFetcherTest : XCTestCase
@end


@implementation JSONFetcherTest {
    JSONFetcher *fetcher;
    EmptyPromiseResponseHandler *handler;
}

- (void)testFetchesSuccessJSONFromTrackerAPI
{
    handler = [EmptyPromiseResponseHandler new];
    handler.resolveImmediately = YES;

    fetcher = [[JSONFetcher alloc] initWithResponseHandler:handler];

    NSString *urlString =
    @"https://www.pivotaltracker.com/"
    @"services/v5/projects/943206/stories?limit=1";

    NSURL *url = [NSURL URLWithString:urlString];
    KSPromise *promise = [fetcher fetchFromURL:url
                                       headers:@{}];
    [promise waitForValueWithTimeout:5];

    XCTAssertEqualObjects(@(handler.response.statusCode), @(200));
    XCTAssertEqualObjects(handler.obj[0][@"story_type"], @"feature");
    XCTAssert(promise.value);
}

- (void)testFetchesErrorJSONFromTrackerAPI
{
    handler = [EmptyPromiseResponseHandler new];
    handler.rejectImmediately = YES;

    fetcher = [[JSONFetcher alloc] initWithResponseHandler:handler];

    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.pivotaltracker.com/"
                           "services/v5/projects/943206/stories?filter=%@&limit=1",
                           @"mywork%3Abrucie+state%3Astarted"];

    NSURL *url = [NSURL URLWithString:urlString];
    KSPromise *promise = [fetcher fetchFromURL:url
                                       headers:@{@"X-TrackerToken": @"deliberatelybadtoken"}];
    [promise waitForValueWithTimeout:5];

    XCTAssertEqualObjects(@(handler.response.statusCode), @(403));
    XCTAssertEqualObjects(handler.obj[@"code"], @"invalid_authentication");
    XCTAssert(promise.error);
}

@end
