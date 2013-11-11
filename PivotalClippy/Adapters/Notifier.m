#import "Notifier.h"

@implementation Notifier {
    NSUserNotificationCenter *center;
}

- (id)initWithNotificationCenter:(NSUserNotificationCenter *)aCenter
{
    self = [super init];
    if (self) {
        center = aCenter;
    }
    return self;
}

- (void)notifyWithTitle:(NSString *)aTitle
               subtitle:(NSString *)aSubtitle
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = aTitle;
    notification.subtitle = aSubtitle;
    [center deliverNotification:notification];
}

@end
