#import "ResponseHandler.h"
#import "KSDeferred.h"
#import "Constants.h"


@implementation ResponseHandler

- (KSPromise *)handleResponse:(NSURLResponse *)aResponse
                       object:(id)anObject
{
    KSDeferred *deferred = [KSDeferred defer];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;

    if (httpResponse.statusCode == 200) {
        [deferred resolveWithValue:anObject];
    } else {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Couldn't access resource",
                                   NSLocalizedFailureReasonErrorKey: @"You probably don't have permission."};
        NSError *fetcherError = [NSError errorWithDomain:ERROR_DOMAIN
                                                    code:FETCHER_ERROR_NOT_FOUND
                                                userInfo:userInfo];
        [deferred rejectWithError:fetcherError];
    }

    return deferred.promise;
}

@end
