@import Foundation;

@interface NSNumber (TimeExpiry)

- (BOOL)secondsNotYetPassedSince:(NSDate *)start;
- (void)secondWait;

@end
