#import <Foundation/Foundation.h>
#import "Repository.h"

@protocol UserNotification;
@interface StoryController : NSObject <RepositoryDelegate>

- (id)initWithCopier:(id<Repository>)aCopier
            notifier:(id<UserNotification>)aNotifier;

@end
