#import <Foundation/Foundation.h>
#import "Repository.h"

@interface Notifier : NSObject <RepositoryDelegate, NSUserNotificationCenterDelegate>

- (id)initWithNotificationCenter:(NSUserNotificationCenter *)aCenter;

@end
