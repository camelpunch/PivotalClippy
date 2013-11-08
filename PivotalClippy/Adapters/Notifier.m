#import "Notifier.h"

@implementation Notifier {
    NSUserNotificationCenter *center;
}

- (id)initWithNotificationCenter:(NSUserNotificationCenter *)aCenter
{
    self = [super init];
    if (self) {
        center = aCenter;
        center.delegate = self;
    }
    return self;
}

- (void)repository:(id<Repository>)aRepository
        didPutItem:(id)anItem
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Tracker Story ID copied";
    notification.subtitle = [NSString stringWithFormat:@"%@ copied to clipboard", anItem];
    [center deliverNotification:notification];
}

@end
