#import <XCTest/XCTest.h>
#import "Copier.h"
#import "KSDeferred.h"

@interface CopierTest : XCTestCase
@end

@implementation CopierTest {
    NSPasteboard *pasteboard;
    Copier *copier;
}

- (void)testOverwritesContentsOfConfiguredPasteboardWithProvidedText
{
    pasteboard = [NSPasteboard pasteboardWithUniqueName];
    [pasteboard writeObjects:@[@"existing content"]];

    copier = [[Copier alloc] initWithPasteboard:pasteboard];
    KSPromise *promise = [copier put:@"new content"];
    NSArray *itemsCopied = [pasteboard readObjectsForClasses:@[[NSString class]] options:nil];

    XCTAssertEqualObjects(@[@"new content"], itemsCopied);
    XCTAssertEqualObjects(promise.value, @"new content");
}

- (void)testCopiesNumbersAsStrings
{
    pasteboard = [NSPasteboard pasteboardWithUniqueName];
    copier = [[Copier alloc] initWithPasteboard:pasteboard];
    KSPromise *promise = [copier put:@12345];
    NSArray *itemsCopied = [pasteboard readObjectsForClasses:@[[NSString class]] options:nil];

    XCTAssertEqualObjects(itemsCopied, @[@"12345"]);
    XCTAssertEqualObjects(promise.value, @"12345");
}

- (void)testRaisesExceptionWhenPuttingNil
{
    copier = [[Copier alloc] initWithPasteboard:nil];
    XCTAssertThrowsSpecific([copier put:nil], NothingToCopy);
}

@end
