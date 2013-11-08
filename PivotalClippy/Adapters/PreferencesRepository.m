#import "PreferencesRepository.h"
#import "Preferences.h"
#import "SSKeychain.h"

@implementation PreferencesRepository {
    NSString *account;
    NSString *service;
}
@synthesize delegate;

- (id)initWithAccount:(NSString *)anAccount
{
    self = [super init];
    if (self) {
        account = anAccount;
        service = @"Pivotal Tracker API";
    }
    return self;
}

- (void)fetchItem
{
    NSString *serializedPrefs = [SSKeychain passwordForService:service
                                                       account:account];
    [self.delegate repository:self
                 didFetchItem:[self deserializedPrefs:serializedPrefs]];
}

- (void)put:(Preferences *)prefs
{
    [SSKeychain setPassword:[self serializedPrefs:prefs]
                 forService:service
                    account:account];
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (NSString *)serializedPrefs:(Preferences *)prefs
{
    return [NSString stringWithFormat:@"%@:%@:%@",
            prefs.username, prefs.token, prefs.projectID];
}

- (Preferences *)deserializedPrefs:(NSString *)serializedPrefs
{
    NSArray *components = [serializedPrefs componentsSeparatedByString:@":"];
    return [[Preferences alloc] initWithUsername:components[0]
                                           token:components[1]
                                       projectID:components[2]];
}

@end
