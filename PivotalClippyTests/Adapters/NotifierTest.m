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
    [notifier repository:nil didPutItem:@"some string"];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"subtitle == '\"some string\" copied to clipboard'"];
    NSArray *matchingNotifications = [center.deliveredNotifications filteredArrayUsingPredicate:predicate];
    XCTAssertEqualObjects(@1, @(matchingNotifications.count));
}

@end
