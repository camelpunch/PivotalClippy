#import "User.h"

@interface User ()
@property (copy, nonatomic) NSNumber *userID;
@property (copy, nonatomic) NSString *username;
@end

@implementation User

- (id)initWithID:(NSNumber *)userID
        username:(NSString *)username
{
    self = [super init];
    if (self) {
        self.userID = userID;
        self.username = username;
    }
    return self;
}

#pragma mark - <NSObject>

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[User class]] &&
    [self isEqualToUser:object];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"User #%@, '%@'", self.userID, self.username];
}

- (id)copy
{
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Private

- (BOOL)isEqualToUser:(User *)other
{
    return
    ([self.userID isEqualToNumber:other.userID] ||
     !(self.userID || other.userID)) &&
    ([self.username isEqualToString:other.username] ||
     !(self.username || other.username));
}

@end
