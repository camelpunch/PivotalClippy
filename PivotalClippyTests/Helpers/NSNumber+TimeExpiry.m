#import "NSNumber+TimeExpiry.h"

@implementation NSNumber (TimeExpiry)

- (BOOL)secondsNotYetPassedSince:(NSDate *)start
{
    return [start timeIntervalSinceNow] > -[self integerValue];
}

- (void)secondWait
{
    NSDate *timeout = [NSDate dateWithTimeIntervalSinceNow:[self doubleValue]];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:timeout];
}

@end
