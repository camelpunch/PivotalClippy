#import "AppDelegate.h"
#import "KeyboardStoryCopier.h"
#import "PreferencesController.h"
#import "PreferencesRepository.h"

@implementation AppDelegate {
    PreferencesController *prefsController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self accessibilityMessage];

    PreferencesRepository *guiPrefsRepo = [[PreferencesRepository alloc] initWithAccount:@"StoryTool"];
    prefsController = [[PreferencesController alloc] initWithRepository:guiPrefsRepo];
    guiPrefsRepo.delegate = prefsController;

    KeyboardStoryCopier *copier = [[KeyboardStoryCopier alloc] init];
    [copier monitorKeyPress];
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
