#import "ValueSemantics.h"
#import "Story.h"

@interface StoryTest : XCTestCase <ValueSemantics>
@end

@implementation StoryTest {
    Story *a;
    Story *b;
}

#pragma mark - <ValueSemantics>

- (void)testHasImmutableProperties
{
    NSMutableString *changingString = [NSMutableString stringWithString:@"Andrew"];
    a = [[Story alloc] initWithStoryID:@123
                                  name:changingString];
    [changingString appendString:@" Bruce"];
    XCTAssertEqualObjects(@"Andrew", a.name);
}

- (void)testEqualWithSameProperties
{
    a = [[Story alloc] initWithStoryID:@123
                                  name:@"Foo"];
    b = [[Story alloc] initWithStoryID:@123
                                  name:@"Foo"];

    XCTAssertEqualObjects(a, b);
}

- (void)testEqualWithNilProperties
{
    a = [[Story alloc] initWithStoryID:nil
                                  name:nil];
    b = [[Story alloc] initWithStoryID:nil
                                  name:nil];

    XCTAssertEqualObjects(a, b);
}

- (void)testNotEqualWithDifferentProperties
{
    a = [[Story alloc] initWithStoryID:@234
                                  name:@"same"];
    b = [[Story alloc] initWithStoryID:@456
                                  name:@"same"];

    XCTAssertNotEqualObjects(a, b);

    a = [[Story alloc] initWithStoryID:@234
                                  name:@"wildy"];
    b = [[Story alloc] initWithStoryID:@234
                                  name:@"different"];

    XCTAssertNotEqualObjects(a, b);
}

- (void)testNotEqualToDifferentClass
{
    a = [[Story alloc] initWithStoryID:@234
                                  name:@"same"];
    NSObject *other = [[NSObject alloc] init];
    XCTAssertNotEqual(a, other);
}

- (void)testCopyable
{
    a = [[Story alloc] initWithStoryID:@123
                                  name:@"Foo"];
    b = [a copy];

    XCTAssertEqualObjects(a, b);
}

@end
