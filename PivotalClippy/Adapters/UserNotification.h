#import <Foundation/Foundation.h>

@protocol UserNotification <NSObject>

- (void)notifyWithTitle:(NSString *)aTitle
               subtitle:(NSString *)aSubtitle;

@end
