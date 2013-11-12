#import "EmptyPromises.h"
#import "KSDeferred.h"


@implementation EmptyPromiseStoryRepo

- (id)init
{
    self = [super init];
    if (self) {
        _deferred = [KSDeferred defer];
    }
    return self;
}

- (KSPromise *)fetchCurrentStoryForUser:(User *)aUser
{
    return self.deferred.promise;
}

@end


@implementation EmptyPromiseRepo

- (id)init
{
    self = [super init];
    if (self) {
        _fetchDeferred = [KSDeferred defer];
        _putDeferred = [KSDeferred defer];
    }
    return self;
}

- (KSPromise *)fetch
{
    return self.fetchDeferred.promise;
}

- (KSPromise *)put:(id)anItem
{
    return self.putDeferred.promise;
}

@end


@implementation EmptyPromiseURLFetcher

- (id)init
{
    self = [super init];
    if (self) {
        _fetchDeferred = [KSDeferred defer];
    }
    return self;
}

- (KSPromise *)fetchFromURL:(NSURL *)url headers:(NSDictionary *)headers
{
    _url = url;
    _headers = headers;
    return self.fetchDeferred.promise;
}

@end


@implementation EmptyPromiseResponseHandler

- (id)init
{
    self = [super init];
    if (self) {
        _deferred = [KSDeferred defer];
    }
    return self;
}

#pragma mark - <URLResponseHandler>

- (KSPromise *)handleResponse:(NSHTTPURLResponse *)aResponse
                       object:(id)anObject
{
    _response = aResponse;
    _obj = anObject;
    if (self.resolveImmediately) {
        [self.deferred resolveWithValue:anObject];
    } else if (self.rejectImmediately) {
        [self.deferred rejectWithError:[NSError errorWithDomain:@"fakedomain" code:0 userInfo:@{}]];
    }
    return self.deferred.promise;
}

@end