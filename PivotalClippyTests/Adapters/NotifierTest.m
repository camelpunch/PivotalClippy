#import <XCTest/XCTest.h>
#import "Notifier.h"

@interface NotifierTest : XCTestCase
@end

@implementation NotifierTest {
    NSUserNotificationCenter *center;
    Notifier *notifier;
}

- (void)testDeliversUserNotification
{
    center = [NSUserNotificationCenter defaultUserNotificationCenter];
    [center removeAllDeliveredNotifications];
    notifier = [[Notifier alloc] initWithNotificationCenter:center];
    [notifier notifyWithTitle:@"Professor Yaffle" subtitle:@"and the mice"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"title == 'Professor Yaffle' AND "
                              @"subtitle == 'and the mice'"];
    NSArray *matchingNotifications = [center.deliveredNotifications filteredArrayUsingPredicate:predicate];
    XCTAssertEqualObjects(@1, @(matchingNotifications.count));
}

@end
