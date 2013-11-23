@import Foundation;

@interface KeyDetector : NSObject

- (id)initWithKey:(NSString *)aKey
        modifiers:(NSUInteger)someModifiers
    whenActivated:(void (^)())block;

- (void)handle:(NSEvent *)anEvent;

@end
