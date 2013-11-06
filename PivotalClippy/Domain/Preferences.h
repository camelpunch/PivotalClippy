#import <Foundation/Foundation.h>

@interface Preferences : NSObject <NSCopying>

@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic, readonly) NSString *token;
@property (strong, nonatomic, readonly) NSString *projectID;

- (id)initWithUsername:(NSString *)aUsername
                 token:(NSString *)aToken
             projectID:(NSString *)aProjectID;

@end
