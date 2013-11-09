#import <XCTest/XCTest.h>

@protocol ValueSemantics <NSObject>

- (void)testHasImmutableProperties;
- (void)testEqualWithSameProperties;
- (void)testEqualWithNilProperties;
- (void)testNotEqualWithDifferentProperties;
- (void)testNotEqualToDifferentClass;
- (void)testCopyable;

@end
