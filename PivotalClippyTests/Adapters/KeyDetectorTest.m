@import XCTest;
#import "KeyDetector.h"

@interface KeyDetectorTest : XCTestCase
@end

@implementation KeyDetectorTest {
    KeyDetector *detector;
}

- (void)testCallsBlockWhenConfiguredKeyIsPressed
{
    __block BOOL called = NO;
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:self.smash
                                  whenActivated:^{
                                      called = YES;
                                  }];

    [detector handle:[self syntheticKeyPress:@"S" modifiers:self.smash]];

    XCTAssert(called);
}

- (void)testDoesntCallBlockWhenDifferentKeyIsPressed
{
    __block BOOL called = NO;
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:NSCommandKeyMask
                                  whenActivated:^{
                                      called = YES;
                                  }];
    [detector handle:[self syntheticKeyPress:@"D" modifiers:NSCommandKeyMask]];

    XCTAssertFalse(called);
}

- (void)testDoesntCallBlockWhenDifferentModifiersAreHeld
{
    __block BOOL called = NO;
    detector = [[KeyDetector alloc] initWithKey:@"S"
                                      modifiers:NSCommandKeyMask
                                  whenActivated:^{
                                      called = YES;
                                  }];
    [detector handle:[self syntheticKeyPress:@"S" modifiers:NSControlKeyMask]];

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
