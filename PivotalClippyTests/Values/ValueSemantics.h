#import <XCTest/XCTest.h>

@protocol ValueSemantics <NSObject>

- (void)testEqualWithSameProperties;
- (void)testEqualWithNilProperties;
- (void)testNotEqualWithDifferentProperties;
- (void)testNotEqualToDifferentClass;
- (void)testCopyable;

@end
