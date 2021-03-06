#import "ValueSemantics.h"
#import "Preferences.h"

@interface PreferencesTest : XCTestCase <ValueSemantics>
@end

@implementation PreferencesTest {
    Preferences *a;
    Preferences *b;
}

#pragma mark - <ValueSemantics>

- (void)testHasImmutableProperties
{
    NSMutableString *changingToken = [NSMutableString stringWithString:@"originaltoken"];
    a = [[Preferences alloc] initWithUsername:@"abc"
                                        token:changingToken
                                    projectID:@"asdfasdf"];
    [changingToken appendString:@"mutated"];
    XCTAssertEqualObjects(@"originaltoken", a.token);
}

- (void)testEqualWithSameProperties
{
    a = [[Preferences alloc] initWithUsername:@"abc"
                                        token:@"def"
                                    projectID:@"asdfasdf"];
    b = [[Preferences alloc] initWithUsername:@"abc"
                                        token:@"def"
                                    projectID:@"asdfasdf"];

    XCTAssertEqualObjects(a, b);
}

- (void)testEqualWithNilProperties
{
    a = [[Preferences alloc] initWithUsername:nil
                                        token:nil
                                    projectID:nil];
    b = [[Preferences alloc] initWithUsername:nil
                                        token:nil
                                    projectID:nil];

    XCTAssertEqualObjects(a, b);
}

- (void)testNotEqualWithDifferentProperties
{
    a = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"bbb"
                                    projectID:@"ccc"];
    b = [[Preferences alloc] initWithUsername:@"bbb"
                                        token:@"bbb"
                                    projectID:@"ccc"];
    XCTAssertNotEqual(a, b);

    a = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"bbb"
                                    projectID:@"ccc"];
    b = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"ccc"
                                    projectID:@"ccc"];
    XCTAssertNotEqual(a, b);

    a = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"bbb"
                                    projectID:@"ccc"];
    b = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"bbb"
                                    projectID:@"ddd"];
    XCTAssertNotEqual(a, b);
}

- (void)testNotEqualToDifferentClass
{
    a = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"def"
                                    projectID:@"asdf"];

    XCTAssertNotEqual(a, [NSObject new]);
}

- (void)testCopyable
{
    a = [[Preferences alloc] initWithUsername:@"aaa"
                                        token:@"def"
                                    projectID:@"fds"];

    XCTAssertEqualObjects(a, [a copy]);
}

- (void)testDoesNotRecognizeInit
{
    XCTAssertThrows([[Preferences alloc] init]);
}

@end
