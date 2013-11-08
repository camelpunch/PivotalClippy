#import <Foundation/Foundation.h>

@interface NSNumber (TimeExpiry)

- (BOOL)secondsNotYetPassedSince:(NSDate *)start;
- (void)secondWait;

@end
