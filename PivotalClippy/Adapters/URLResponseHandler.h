@import Foundation;

@class KSPromise;
@protocol URLResponseHandler <NSObject>

- (KSPromise *)handleResponse:(NSURLResponse *)aResponse
                       object:(id)anObject;

@end
