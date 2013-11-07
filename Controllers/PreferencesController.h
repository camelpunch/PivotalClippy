#import <Cocoa/Cocoa.h>
#import "Repository.h"

@interface PreferencesController : NSWindowController <RepositoryDelegate, NSWindowDelegate>

@property (weak) IBOutlet NSTextField *username;
@property (weak) IBOutlet NSTextField *token;
@property (weak) IBOutlet NSTextField *projectID;

- (id)initWithRepository:(id <Repository>)aRepo;

- (IBAction)usernameDidBlur:(id)sender;
- (IBAction)tokenDidBlur:(id)sender;
- (IBAction)projectIDDidBlur:(id)sender;

@end
