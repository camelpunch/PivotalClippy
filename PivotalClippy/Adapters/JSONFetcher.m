#import "JSONFetcher.h"

@interface JSONFetcher ()

@property (nonatomic) NSURLSessionConfiguration *config;

@end

@implementation JSONFetcher
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.config = [NSURLSessionConfiguration defaultSessionConfiguration];
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
               [weakSelf.delegate URLFetcher:weakSelf didFetchObject:obj];
           }];
    [task resume];
}

@end
