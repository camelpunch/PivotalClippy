#import "Preferences.h"
#import <objc/message.h>

@implementation Preferences

- (id)initWithUsername:(NSString *)aUsername
                 token:(NSString *)aToken
             projectID:(NSString *)aProjectID
{
    self = [super init];
    if (self) {
        _username = aUsername;
        _token = aToken;
        _projectID = aProjectID;
    }
    return self;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Preferences: %@ / %@ / %@", self.username, self.token, self.projectID];
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[self class]] &&
    [self isEqualToPreferences:object];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[Preferences alloc] initWithUsername:self.username
                                           token:self.token
                                       projectID:self.projectID];
}

#pragma mark - Private

- (BOOL)isEqualToPreferences:(Preferences *)other
{
    return [self stringEqualityForOther:other selector:@selector(username)] &&
    [self stringEqualityForOther:other selector:@selector(token)] &&
    [self stringEqualityForOther:other selector:@selector(projectID)];
}

- (BOOL)stringEqualityForOther:(Preferences *)other
                      selector:(SEL)selector
{
    NSString *value1 = objc_msgSend(self, selector);
    NSString *value2 = objc_msgSend(other, selector);
    return [value1 isEqualToString:value2] || !(value1 || value2);
}

@end
