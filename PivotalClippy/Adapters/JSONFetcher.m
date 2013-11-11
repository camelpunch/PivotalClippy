#import "JSONFetcher.h"
#import "Constants.h"
#import <objc/message.h>

@interface ResponseHandler : NSObject

- (id)initWithFetcher:(id<URLFetcher>)aFetcher;
- (void)handleResponse:(NSURLResponse *)aResponse
                object:(id)anObject
              delegate:(id<URLFetcherDelegate>)aDelegate;

@end

@interface ResponseHandler ()
@property (nonatomic) id<URLFetcher> fetcher;
@property (nonatomic) id<URLFetcherDelegate> delegate;
@end

@implementation ResponseHandler

- (id)initWithFetcher:(id<URLFetcher>)aFetcher
{
    self = [super init];
    if (self) {
        self.fetcher = aFetcher;
    }
    return self;
}

- (void)handleResponse:(NSURLResponse *)aResponse
                object:(id)anObject
              delegate:(id<URLFetcherDelegate>)aDelegate
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    NSString *selectorName = [NSString stringWithFormat:@"handle%@Response:object:delegate:",
                              @(httpResponse.statusCode)];
    SEL selector = NSSelectorFromString(selectorName);
    objc_msgSend(self, selector, httpResponse, anObject, aDelegate);
}

#pragma mark - <NSObject>

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (void)handle200Response:(NSHTTPURLResponse *)aResponse
                   object:(id)anObject
                 delegate:(id<URLFetcherDelegate>)aDelegate
{
    [aDelegate URLFetcher:self.fetcher didFetchObject:anObject];
}

- (void)handle404Response:(NSHTTPURLResponse *)aResponse
                   object:(id)anObject
                 delegate:(id<URLFetcherDelegate>)aDelegate
{
    NSError *fetcherError = [NSError errorWithDomain:ERROR_DOMAIN
                                                code:FETCHER_ERROR_NOT_FOUND
                                            userInfo:@{NSLocalizedDescriptionKey: @"Couldn't access resource",
                                                       NSLocalizedFailureReasonErrorKey: @"You probably don't have permission."}];
    [aDelegate URLFetcher:self.fetcher didFailToFetchWithError:fetcherError];
}

- (void)handle400Response:(NSHTTPURLResponse *)aResponse
                   object:(id)anObject
                 delegate:(id<URLFetcherDelegate>)aDelegate
{
    [self handle404Response:aResponse object:anObject delegate:aDelegate];
}

@end

@interface JSONFetcher ()

@property (nonatomic) NSURLSessionConfiguration *config;
@property (nonatomic) ResponseHandler *handler;

@end

@implementation JSONFetcher
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.handler = [[ResponseHandler alloc] initWithFetcher:self];
    }
    return self;
}

- (void)fetchFromURL:(NSURL *)url
             headers:(NSDictionary *)headers
{
    [self.config setHTTPAdditionalHeaders:headers];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.config];

    JSONFetcher * __weak weakSelf = self;
    NSURLSessionTask *task =
    [session dataTaskWithURL:url
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               id obj = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:nil];
               [self.handler handleResponse:response
                                     object:obj
                                   delegate:weakSelf.delegate];
           }];
    [task resume];
}

@end
