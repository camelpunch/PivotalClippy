#import <Foundation/Foundation.h>
#import "Repository.h"
#import "KSPromise.h"

@class User;
@protocol UserNotification;
@interface StoryController : NSObject

- (id)initWithCopier:(id<Repository>)aCopier
            notifier:(id<UserNotification>)aNotifier
      userRepository:(id<Repository>)aUserRepo
             backlog:(id<StoryRepository>)aBacklog;

- (void)copyCurrentUsersStory;

@end
