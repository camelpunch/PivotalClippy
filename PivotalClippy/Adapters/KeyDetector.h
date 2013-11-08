#import <Foundation/Foundation.h>

@interface KeyDetector : NSObject

- (id)initWithKey:(NSString *)aKey
        modifiers:(NSUInteger)someModifiers;

- (void (^)(NSEvent *))handler:(void(^)())handlerBlock;

@end
