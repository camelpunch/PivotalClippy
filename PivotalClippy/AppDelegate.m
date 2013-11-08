#import "AppDelegate.h"
#import "KeyDetector.h"
#import "Backlog.h"
#import "StoryController.h"
#import "PreferencesController.h"
#import "PreferencesRepository.h"
#import "Copier.h"
#import "Notifier.h"

@interface KeyboardStoryCopier : NSObject
- (void)monitorKeyPress;
@end

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
        backlog = [[Backlog alloc] init];
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

@implementation AppDelegate {
    PreferencesController *prefsController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self accessibilityMessage];

    PreferencesRepository *guiPrefsRepo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool"];
    prefsController = [[PreferencesController alloc] initWithRepository:guiPrefsRepo];
    guiPrefsRepo.delegate = prefsController;

    KeyboardStoryCopier *fetcher = [[KeyboardStoryCopier alloc] init];
    [fetcher monitorKeyPress];
}

- (IBAction)openPreferences:(id)sender
{
    [prefsController showWindow:nil];
}

#pragma mark - Private

- (void)accessibilityMessage
{
    if (AXIsProcessTrusted()) return;

    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSCriticalAlertStyle;
    alert.messageText =
    @"You need to enable accessibility control "
    "for this app in your Security & Privacy System Preferences.";
    [alert runModal];
}

@end
