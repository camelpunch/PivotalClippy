#import <Foundation/Foundation.h>
#import "UserNotification.h"

@interface Notifier : NSObject <UserNotification>

- (id)initWithNotificationCenter:(NSUserNotificationCenter *)aCenter;

@end
