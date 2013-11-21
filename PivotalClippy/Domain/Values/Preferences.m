#import "Preferences.h"
@import ObjectiveC.message;

@interface Preferences ()

@property (copy, nonatomic, readwrite) NSString *username;
@property (copy, nonatomic, readwrite) NSString *token;
@property (copy, nonatomic, readwrite) NSString *projectID;

@end

@implementation Preferences

- (id)initWithUsername:(NSString *)aUsername
                 token:(NSString *)aToken
             projectID:(NSString *)aProjectID
{
    self = [super init];
    if (self) {
        self.username = aUsername;
        self.token = aToken;
        self.projectID = aProjectID;
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

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[self class]] &&
    [self isEqualToPreferences:object];
}

- (BOOL)isEqualToPreferences:(Preferences *)other
{
    return [self equalityForOther:other selector:@selector(username)] &&
    [self equalityForOther:other selector:@selector(token)] &&
    [self equalityForOther:other selector:@selector(projectID)];
}

#pragma mark - Private

- (BOOL)equalityForOther:(id)other
                selector:(SEL)selector
{
    NSString *a = objc_msgSend(self, selector);
    NSString *b = objc_msgSend(other, selector);
    return [a isEqual:b] || !(a || b);
}

@end
