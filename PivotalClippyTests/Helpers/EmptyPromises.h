@import Foundation;
#import "Repository.h"
#import "URLFetcher.h"
#import "URLResponseHandler.h"


@class KSDeferred;
@interface EmptyPromiseStoryRepo : NSObject <StoryRepository>

@property (nonatomic, readonly) KSDeferred *deferred;

@end


@interface EmptyPromiseRepo : NSObject <Repository>

@property (nonatomic, readonly) KSDeferred *fetchDeferred;
@property (nonatomic, readonly) KSDeferred *putDeferred;

@end


@interface EmptyPromiseURLFetcher : NSObject <URLFetcher>

@property (nonatomic, readonly) KSDeferred *fetchDeferred;
@property (nonatomic, readonly) NSURL *url;
@property (nonatomic, readonly) NSDictionary *headers;

@end


@interface EmptyPromiseResponseHandler : NSObject <URLResponseHandler>

@property (nonatomic, readonly) KSDeferred *deferred;
@property (nonatomic, readonly) NSHTTPURLResponse *response;
@property (nonatomic, readonly) id obj;
@property (nonatomic) BOOL resolveImmediately;
@property (nonatomic) BOOL rejectImmediately;

@end