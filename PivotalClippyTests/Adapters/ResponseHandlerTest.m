@import XCTest;
#import "ResponseHandler.h"
#import "KSDeferred.h"


@interface ResponseHandlerTest : XCTestCase
@end


@implementation ResponseHandlerTest

- (void)test200ResolvesPromise
{
    ResponseHandler *handler = [[ResponseHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:200
                                                             HTTPVersion:@"1.1"
                                                            headerFields:@{}];
    KSPromise *promise = [handler handleResponse:response object:@{@"some": @"data"}];

    XCTAssertEqualObjects(promise.value, @{@"some": @"data"});
}

- (void)test404RejectsPromise
{
    ResponseHandler *handler = [[ResponseHandler alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://www.google.com/"];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:404
                                                             HTTPVersion:@"1.1"
                                                            headerFields:@{}];

    KSPromise *promise = [handler handleResponse:response object:@{}];

    XCTAssert(promise.error);
}

@end
