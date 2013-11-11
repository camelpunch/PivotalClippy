#import "StoryController.h"
#import "Story.h"
#import "UserNotification.h"

@interface StoryController ()

@property (nonatomic) id<Repository> copier;
@property (nonatomic) id<UserNotification> notifier;

@end

@implementation StoryController

- (id)initWithCopier:(id<Repository>)aCopier
            notifier:(id<UserNotification>)aNotifier
{
    self = [super init];
    if (self) {
        self.copier = aCopier;
        self.notifier = aNotifier;
    }
    return self;
}

#pragma mark - <RepositoryDelegate>

#pragma mark Backlog

- (void)repository:(id<Repository>)backlog
      didFetchItem:(Story *)story
{
    [self.copier put:[story.storyID stringValue]];
}

#pragma mark Copier

- (void)repository:(id<Repository>)copier
        didPutItem:(NSString *)storyID
{
    [self.notifier notifyWithTitle:@"Tracker Story ID copied"
                          subtitle:[NSString stringWithFormat:@"'%@' copied to clipboard", storyID]];
}

- (void)repository:(id<Repository>)aRepository
didFailToFetchWhere:(NSPredicate *)predicate
{
    [self.notifier notifyWithTitle:@"Could not copy Tracker Story ID"
                          subtitle:@"Perhaps you're not allowed?"];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
