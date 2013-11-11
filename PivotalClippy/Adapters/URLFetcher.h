#import <Foundation/Foundation.h>

@protocol URLFetcherDelegate;
@protocol URLFetcher <NSObject>

@property (nonatomic) id <URLFetcherDelegate> delegate;

- (void)fetchFromURL:(NSURL *)url
             headers:(NSDictionary *)headers;

@end

@protocol URLFetcherDelegate

- (void)URLFetcher:(id<URLFetcher>)fetcher
    didFetchObject:(id)object;

- (void)URLFetcher:(id<URLFetcher>)fetcher
didFailToFetchWithError:(NSError *)error;

@end
