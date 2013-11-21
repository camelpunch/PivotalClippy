@import Foundation;
#import "URLFetcher.h"
#import "URLResponseHandler.h"


@interface JSONFetcher : NSObject <URLFetcher>

- (id)initWithResponseHandler:(id<URLResponseHandler>)aHandler;

@end
