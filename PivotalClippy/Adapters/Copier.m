#import "Copier.h"
#import "KSDeferred.h"

@implementation NothingToCopy
@end

@implementation Copier {
    NSPasteboard *pasteboard;
}

- (id)initWithPasteboard:(NSPasteboard *)aPasteboard
{
    self = [super init];
    if (self) {
        pasteboard = aPasteboard;
    }
    return self;
}

- (KSPromise *)put:(id)copyable
{
    if (!copyable)
        @throw [NothingToCopy exceptionWithName:@"Nothing to copy"
                                         reason:@"Provided string was nil"
                                       userInfo:nil];
    [pasteboard clearContents];
    NSString *stringifiedValue = [NSString stringWithFormat:@"%@", copyable];
    [pasteboard writeObjects:@[stringifiedValue]];

    KSDeferred *deferred = [KSDeferred defer];
    [deferred resolveWithValue:stringifiedValue];

    return deferred.promise;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
