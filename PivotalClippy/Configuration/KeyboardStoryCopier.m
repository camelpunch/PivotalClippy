#import "KeyboardStoryCopier.h"
#import "KeyDetector.h"
#import "Backlog.h"
#import "Copier.h"
#import "PreferencesRepository.h"
#import "Notifier.h"
#import "StoryController.h"
#import "UserRepository.h"
#import "JSONFetcher.h"
#import "ResponseHandler.h"


@implementation KeyboardStoryCopier {
    KeyDetector *keyDetector;
    Backlog *backlog;
    Copier *copier;
    PreferencesRepository *prefsRepo;
    StoryController *storyController;
    Notifier *notifier;
    UserRepository *userRepo;
}

- (id)init
{
    self = [super init];
    if (self) {
        copier = [[Copier alloc] initWithPasteboard:[NSPasteboard generalPasteboard]];
        notifier = [[Notifier alloc] initWithNotificationCenter:[NSUserNotificationCenter defaultUserNotificationCenter]];
        prefsRepo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool"];

        ResponseHandler *handler = [ResponseHandler new];
        JSONFetcher *userFetcher = [[JSONFetcher alloc] initWithResponseHandler:handler];
        userRepo = [[UserRepository alloc] initWithPreferencesRepository:prefsRepo
                                                              urlFetcher:userFetcher];

        JSONFetcher *storyFetcher = [[JSONFetcher alloc] initWithResponseHandler:handler];
        backlog = [[Backlog alloc] initWithURLFetcher:storyFetcher
                                preferencesRepository:prefsRepo];

        storyController = [[StoryController alloc] initWithCopier:copier
                                                         notifier:notifier
                                                   userRepository:userRepo
                                                          backlog:backlog];

        NSUInteger highSmash = NSCommandKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSShiftKeyMask;
        keyDetector = [[KeyDetector alloc] initWithKey:@"S"
                                             modifiers:highSmash];
    }
    return self;
}

- (void)monitorKeyPress
{
    [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask
                                           handler:[keyDetector handler:^{
        [storyController copyCurrentUsersStory];
    }]];
}

@end
