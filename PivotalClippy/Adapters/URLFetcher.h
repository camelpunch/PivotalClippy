#import <Foundation/Foundation.h>

@class KSPromise;
@protocol URLFetcher <NSObject>

- (KSPromise *)fetchFromURL:(NSURL *)url
                    headers:(NSDictionary *)headers;

@end
