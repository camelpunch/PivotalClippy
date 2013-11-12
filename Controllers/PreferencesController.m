#import "PreferencesController.h"
#import "Preferences.h"
#import "KSDeferred.h"

@implementation PreferencesController {
    id <Repository> repo;
}

- (id)initWithRepository:(id <Repository>)aRepo
{
    self = [super initWithWindowNibName:@"PreferencesController"];
    if (self) {
        repo = aRepo;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [[repo fetch]

     then:^id(Preferences *prefs) {
         [self.username setStringValue:prefs.username];
         [self.token setStringValue:prefs.token];
         [self.projectID setStringValue:prefs.projectID];
         return nil;
     }

     error:nil];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - <NSWindowDelegate>

- (void)windowWillClose:(NSNotification *)notification
{
    [self updatePrefs];
}

#pragma mark - <IBAction>

- (IBAction)usernameDidBlur:(id)sender
{
    [self updatePrefs];
}

- (IBAction)tokenDidBlur:(id)sender
{
    [self updatePrefs];
}

- (IBAction)projectIDDidBlur:(id)sender
{
    [self updatePrefs];
}

#pragma mark - Private

- (void)updatePrefs
{
    [repo put:[[Preferences alloc] initWithUsername:self.username.stringValue
                                              token:self.token.stringValue
                                          projectID:self.projectID.stringValue]];
}

@end
