#import "KeyboardStoryCopier.h"
#import "KeyDetector.h"
#import "Backlog.h"
#import "Copier.h"
#import "PreferencesRepository.h"
#import "Notifier.h"
#import "StoryController.h"

@implementation KeyboardStoryCopier {
    KeyDetector *keyDetector;
    Backlog *backlog;
    Copier *copier;
    PreferencesRepository *prefsRepo;
    StoryController *storyController;
    Notifier *notifier;
}

- (id)init
{
    self = [super init];
    if (self) {
        copier = [[Copier alloc] initWithPasteboard:[NSPasteboard generalPasteboard]];
        notifier = [[Notifier alloc] initWithNotificationCenter:[NSUserNotificationCenter defaultUserNotificationCenter]];
        storyController = [[StoryController alloc] initWithCopier:copier];
        JSONFetcher *fetcher = [[JSONFetcher alloc] init];
        backlog = [[Backlog alloc] initWithURLFetcher:fetcher];
        fetcher.delegate = backlog;
        prefsRepo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool"];
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
        prefsRepo.delegate = backlog;
        backlog.delegate = storyController;
        copier.delegate = notifier;

        [prefsRepo fetchItem];
    }]];
}

@end
