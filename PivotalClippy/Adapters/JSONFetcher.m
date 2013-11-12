#import "JSONFetcher.h"
#import "KSDeferred.h"


@interface JSONFetcher ()

@property (nonatomic) NSURLSessionConfiguration *config;
@property (nonatomic) id<URLResponseHandler> handler;

@end


@implementation JSONFetcher

- (id)initWithResponseHandler:(id<URLResponseHandler>)aHandler
{
    self = [super init];
    if (self) {
        self.config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.handler = aHandler;
    }
    return self;
}

- (KSPromise *)fetchFromURL:(NSURL *)url
                    headers:(NSDictionary *)headers
{
    [self.config setHTTPAdditionalHeaders:headers];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:self.config];

    KSDeferred *deferred = [KSDeferred defer];

    __weak __typeof(self) weakSelf = self;
    NSURLSessionTask *task =
    [session dataTaskWithURL:url
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               id obj = [NSJSONSerialization JSONObjectWithData:data
                                                        options:0
                                                          error:nil];
               [[weakSelf.handler handleResponse:response
                                          object:obj]

                then:^id(id value) {
                    [deferred resolveWithValue:value];
                    return nil;
                }

                error:^id(NSError *error) {
                    [deferred rejectWithError:error];
                    return nil;
                }];
           }];
    [task resume];

    return deferred.promise;
}

#pragma mark - <NSObject>

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
