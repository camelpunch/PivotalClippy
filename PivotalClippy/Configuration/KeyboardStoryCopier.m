#import "KeyboardStoryCopier.h"
#import "KeyDetector.h"
#import "Backlog.h"
#import "Copier.h"
#import "PreferencesRepository.h"
#import "Notifier.h"
#import "StoryController.h"
#import "JSONFetcher.h"

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
        storyController = [[StoryController alloc] initWithCopier:copier
                                                         notifier:notifier];
        JSONFetcher *fetcher = [[JSONFetcher alloc] init];
        prefsRepo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool"];
        backlog = [[Backlog alloc] initWithURLFetcher:fetcher
                                preferencesRepository:prefsRepo];
        fetcher.delegate = backlog;
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
        copier.delegate = storyController;

        // TODO: un-hardcode story name - we probably get the predicate from the UI
        [backlog fetchFirstStoryInProgressWhere:[NSPredicate predicateWithFormat:@"name = 'Eligible story'"]];
    }]];
}

@end
