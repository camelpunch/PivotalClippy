#import <Foundation/Foundation.h>

@interface User : NSObject

@property (copy, nonatomic, readonly) NSNumber *userID;
@property (copy, nonatomic, readonly) NSString *username;

- (id)initWithID:(NSNumber *)userID
        username:(NSString *)username;

- (BOOL)isEqualToUser:(User *)other;

@end
