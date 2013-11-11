#import "Copier.h"

@implementation NothingToCopy
@end

@implementation Copier {
    NSPasteboard *pasteboard;
}
@synthesize delegate;

- (id)initWithPasteboard:(NSPasteboard *)aPasteboard
{
    self = [super init];
    if (self) {
        pasteboard = aPasteboard;
    }
    return self;
}

- (void)put:(NSString *)someText
{
    if (!someText)
        @throw [NothingToCopy exceptionWithName:@"Nothing to copy"
                                         reason:@"Provided string was nil"
                                       userInfo:nil];

    [pasteboard clearContents];
    [pasteboard writeObjects:@[someText]];
    [self.delegate repository:self didPutItem:someText];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
