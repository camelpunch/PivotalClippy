#import "ValueSemantics.h"
#import "Story.h"
#import "StoryBuilder.h"

@interface StoryTest : XCTestCase <ValueSemantics>
@end

@implementation StoryTest {
    StoryBuilder *builder;
    Story *a;
    Story *b;
}

- (void)setUp
{
    [super setUp];
    builder = [StoryBuilder new];
}

#pragma mark - <ValueSemantics>

- (void)testHasImmutableProperties
{
    NSMutableString *changingString = [NSMutableString stringWithString:@"Andrew"];
    a = [[[builder
           storyID:@123]
          name:changingString]
         build];
    [changingString appendString:@" Bruce"];
    XCTAssertEqualObjects(@"Andrew", a.name);
}

- (void)testEqualWithSameProperties
{
    [[builder
      storyID:@123]
     name:@"Foo"];

    XCTAssertEqualObjects([builder build],
                          [builder build]);
}

- (void)testEqualWithNilProperties
{
    XCTAssertEqualObjects([builder build],
                          [builder build]);
}

- (void)testNotEqualWithDifferentProperties
{
    a = [[[builder storyID:@234] name:@"same"] build];
    b = [[builder storyID:@456] build];

    XCTAssertNotEqualObjects(a, b);

    a = [[builder name:@"wildly"] build];
    b = [[builder name:@"different"] build];

    XCTAssertNotEqualObjects(a, b);
}

- (void)testNotEqualToDifferentClass
{
    XCTAssertNotEqual([builder build], [NSObject new]);
}

- (void)testCopyable
{
    a = [[[builder storyID:@123] name:@"Foo"] build];
    b = [a copy];

    XCTAssertEqualObjects(a, b);
}

- (void)testDoesNotRecognizeInit
{
    XCTAssertThrows([[Story alloc] init]);
}

@end
