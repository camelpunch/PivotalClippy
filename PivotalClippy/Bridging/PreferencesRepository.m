#import "PreferencesRepository.h"
#import "Preferences.h"
#import "SSKeychain.h"
#import "KSDeferred.h"

@implementation PreferencesRepository {
    NSString *account;
    NSString *service;
}

- (id)initWithAccount:(NSString *)anAccount
{
    self = [super init];
    if (self) {
        account = anAccount;
        service = @"Pivotal Tracker API";
    }
    return self;
}

- (KSPromise *)fetch
{
    KSDeferred *deferred = [KSDeferred defer];
    NSString *serializedPrefs = [SSKeychain passwordForService:service
                                                       account:account];
    [deferred resolveWithValue:[self deserializedPrefs:serializedPrefs]];
    return deferred.promise;
}

- (KSPromise *)put:(Preferences *)prefs
{
    KSDeferred *deferred = [KSDeferred defer];

    [deferred.promise then:^id(id value) {
        [SSKeychain setPassword:[self serializedPrefs:prefs]
                     forService:service
                        account:account];
        return value;
    } error:nil];

    [deferred resolveWithValue:nil];

    return deferred.promise;
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
