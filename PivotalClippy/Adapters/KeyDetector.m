#import "KeyDetector.h"

@implementation KeyDetector {
    NSString *key;
    NSUInteger modifiers;
}

- (id)initWithKey:(NSString *)aKey
        modifiers:(NSUInteger)someModifiers
{
    self = [super init];
    if (self) {
        key = aKey;
        modifiers = someModifiers;
    }
    return self;
}

- (void (^)(NSEvent *))handler:(void(^)())handlerBlock
{
    return ^(NSEvent *incomingEvent) {
        if ((incomingEvent.modifierFlags & modifiers) == modifiers &&
            [incomingEvent.charactersIgnoringModifiers isEqualToString:key]) {
            handlerBlock();
        }
    };
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
