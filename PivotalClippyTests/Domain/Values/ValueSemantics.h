@import XCTest;

@protocol ValueSemantics <NSObject>

- (void)testHasImmutableProperties;
- (void)testEqualWithSameProperties;
- (void)testEqualWithNilProperties;
- (void)testNotEqualWithDifferentProperties;
- (void)testNotEqualToDifferentClass;
- (void)testCopyable;
- (void)testDoesNotRecognizeInit;

@end
