#import "KeyDetector.h"

@interface KeyDetector ()
@property (nonatomic) NSString *key;
@property (nonatomic) NSUInteger modifiers;
@property (nonatomic, copy) void (^whenActivated)(NSEvent *);
@end

@implementation KeyDetector

- (id)initWithKey:(NSString *)aKey
        modifiers:(NSUInteger)someModifiers
    whenActivated:(void (^)())block
{
    self = [super init];
    if (self) {
        self.key = aKey;
        self.modifiers = someModifiers;
        self.whenActivated = block;
    }
    return self;
}

- (void)handle:(NSEvent *)anEvent
{
    if ((anEvent.modifierFlags & self.modifiers) == self.modifiers &&
        [anEvent.charactersIgnoringModifiers isEqualToString:self.key]) {
        self.whenActivated(anEvent);
    }
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
