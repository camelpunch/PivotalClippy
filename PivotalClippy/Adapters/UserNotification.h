@import Foundation;

@protocol UserNotification <NSObject>

- (void)notifyWithTitle:(NSString *)aTitle
               subtitle:(NSString *)aSubtitle;

@end
