#import <XCTest/XCTest.h>
#import "KeyDetector.h"

@interface KeyDetectorTest : XCTestCase
@end

@implementation KeyDetectorTest

- (void)testCallsBlockWhenConfiguredKeyIsPressed
{
    NSUInteger smash = (NSCommandKeyMask |
                        NSControlKeyMask |
                        NSAlternateKeyMask |
                        NSShiftKeyMask);
    KeyDetector *detector = [[KeyDetector alloc] initWithKey:@"S"
                                                   modifiers:smash];

    __block BOOL called = NO;
    [detector handler:^{ called = YES; }]([self syntheticKeyPress:@"S" modifiers:smash]);

    XCTAssert(called);
}

#pragma mark - Private

- (NSEvent *)syntheticKeyPress:(NSString *)key
                     modifiers:(NSUInteger)modifiers
{
    return [NSEvent keyEventWithType:NSKeyDown
                            location:(NSPoint){0,0}
                       modifierFlags:modifiers
                           timestamp:NSTimeIntervalSince1970
                        windowNumber:0
                             context:nil
                          characters:key
         charactersIgnoringModifiers:key
                           isARepeat:NO
                             keyCode:1];
}

@end
