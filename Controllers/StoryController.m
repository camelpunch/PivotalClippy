#import "StoryController.h"
#import "Story.h"
#import "UserNotification.h"
#import "User.h"

@interface StoryController ()

@property (nonatomic) id<Repository> copier;
@property (nonatomic) id<StoryRepository> backlog;
@property (nonatomic) id<Repository> userRepo;
@property (nonatomic) id<UserNotification> notifier;

@end

@implementation StoryController

- (id)initWithCopier:(id<Repository>)aCopier
            notifier:(id<UserNotification>)aNotifier
      userRepository:(id<Repository>)aUserRepo
             backlog:(id<StoryRepository>)aBacklog
{
    self = [super init];
    if (self) {
        self.copier = aCopier;
        self.backlog = aBacklog;
        self.notifier = aNotifier;
        self.userRepo = aUserRepo;
    }
    return self;
}

- (void)initiateCopy
{
    __weak id<StoryRepository> backlog = self.backlog;
    __weak id<Repository> copier = self.copier;
    __weak id<UserNotification> notifier = self.notifier;

    [[self.userRepo fetch]

     then:^id(User *user) {
         [[backlog fetchCurrentStoryForUser:user]

          then:^id(Story *story) {
              [[copier put:story.storyID]

               then:^id(NSString *copiedText) {
                   [notifier notifyWithTitle:@"Tracker Story ID copied"
                                    subtitle:[NSString stringWithFormat:@"%@ (%@)",
                                              copiedText, story.name]];
                   return nil;
               }

               error:^id(NSError *error) {
                   return nil;
               }];

              return nil;
          }

          error:^id(NSError *error) {
              [notifier notifyWithTitle:@"Could not copy Tracker Story ID"
                               subtitle:error.localizedDescription];
              return nil;
          }];

         return nil;
     }

     error:^id(NSError *error) {
         [notifier notifyWithTitle:@"Could not copy Tracker Story ID"
                          subtitle:@"Couldn't fetch Tracker user"];
         return nil;
     }];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
