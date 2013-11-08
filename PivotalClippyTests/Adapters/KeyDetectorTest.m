#import <XCTest/XCTest.h>
#import "KeyDetector.h"

@interface KeyDetectorTest : XCTestCase
@end

@implementation KeyDetectorTest {
    KeyDetector *detector;
}

- (void)testCallsBlockWhenConfiguredKeyIsPressed
{
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:self.smash];

    __block BOOL called = NO;
    [detector handler:^{ called = YES; }]([self syntheticKeyPress:@"S" modifiers:self.smash]);

    XCTAssert(called);
}

- (void)testDoesntCallBlockWhenDifferentKeyIsPressed
{
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:NSCommandKeyMask];
    __block BOOL called = NO;
    [detector handler:^{ called = YES; }]([self syntheticKeyPress:@"D" modifiers:NSCommandKeyMask]);

    XCTAssertFalse(called);
}

- (void)testDoesntCallBlockWhenDifferentModifiersAreHeld
{
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:NSCommandKeyMask];
    __block BOOL called = NO;
    [detector handler:^{ called = YES; }]([self syntheticKeyPress:@"S" modifiers:NSControlKeyMask]);

    XCTAssertFalse(called);
}

#pragma mark - Private

- (NSUInteger)smash
{
    return (NSCommandKeyMask |
            NSControlKeyMask |
            NSAlternateKeyMask |
            NSShiftKeyMask);
}

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
