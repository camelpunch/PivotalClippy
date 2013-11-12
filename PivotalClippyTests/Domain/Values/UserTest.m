#import <XCTest/XCTest.h>
#import "ValueSemantics.h"
#import "User.h"

@interface UserTest : XCTestCase <ValueSemantics>
@end

@implementation UserTest {
    User *a, *b;
}

- (void)testHasImmutableProperties
{
    NSMutableString *username = [NSMutableString stringWithString:@"jim"];
    a = [[User alloc] initWithID:@123
                        username:username];
    [username appendString:@"hi!"];
    XCTAssertEqualObjects(a.username, @"jim");
}

- (void)testEqualWithSameProperties
{
    a = [[User alloc] initWithID:@123
                        username:@"jim"];
    b = [[User alloc] initWithID:@123
                        username:@"jim"];

    XCTAssertEqualObjects(a, b);
}

- (void)testNotEqualWithDifferentProperties
{
    a = [[User alloc] initWithID:@321
                        username:@"bob"];
    b = [[User alloc] initWithID:@123
                        username:@"bob"];

    XCTAssertNotEqualObjects(a, b);

    b = [[User alloc] initWithID:@321
                        username:@"jim"];
    XCTAssertNotEqualObjects(a, b);
}

- (void)testEqualWithNilProperties
{
    a = [[User alloc] initWithID:nil
                        username:nil];
    b = [[User alloc] initWithID:nil
                        username:nil];

    XCTAssertEqualObjects(a, b);

    a = [[User alloc] initWithID:nil
                        username:nil];
    b = [[User alloc] initWithID:nil
                        username:@"ASDF"];

    XCTAssertNotEqualObjects(a, b);

    a = [[User alloc] initWithID:nil
                        username:nil];
    b = [[User alloc] initWithID:@1
                        username:nil];

    XCTAssertNotEqualObjects(a, b);
}

- (void)testNotEqualToDifferentClass
{
    a = [[User alloc] initWithID:nil
                        username:nil];
    XCTAssertNotEqualObjects(a, [NSObject new]);
}

- (void)testCopyable
{
    a = [[User alloc] initWithID:@321
                        username:@"bob"];
    XCTAssertEqualObjects([a copy], a);
}

- (void)testDoesNotRecognizeInit
{
    XCTAssertThrows([[User alloc] init]);
}

@end
