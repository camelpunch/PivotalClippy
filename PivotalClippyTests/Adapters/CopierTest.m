#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "Copier.h"

@interface CopierTest : XCTestCase
@end

@implementation CopierTest {
    NSPasteboard *pasteboard;
    Copier *copier;
    id delegate;
}

- (void)testOverwritesContentsOfConfiguredPasteboardWithProvidedText
{
    pasteboard = [NSPasteboard pasteboardWithUniqueName];
    [pasteboard writeObjects:@[@"existing content"]];

    [[[Copier alloc] initWithPasteboard:pasteboard] put:@"new content"];
    NSArray *items = [pasteboard readObjectsForClasses:@[[NSString class]] options:nil];

    XCTAssertEqualObjects(@[@"new content"], items);
}

- (void)testNotifiesItsDelegate
{
    copier = [[Copier alloc] initWithPasteboard:nil];
    delegate = [OCMockObject mockForProtocol:@protocol(RepositoryDelegate)];
    copier.delegate = delegate;

    [[delegate expect] repository:copier
                       didPutItem:@"some text"];
    [copier put:@"some text"];
    [delegate verify];
}

@end
