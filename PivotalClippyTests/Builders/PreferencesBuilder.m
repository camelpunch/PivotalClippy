#import "PreferencesBuilder.h"
#import "Preferences.h"

@implementation PreferencesBuilder

- (id)build
{
    return [[Preferences alloc] initWithUsername:self.username
                                           token:self.token
                                       projectID:self.projectID];
}

@end
