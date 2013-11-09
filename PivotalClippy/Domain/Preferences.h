#import <Foundation/Foundation.h>

@interface Preferences : NSObject <NSCopying>

@property (copy, nonatomic, readonly) NSString *username;
@property (copy, nonatomic, readonly) NSString *token;
@property (copy, nonatomic, readonly) NSString *projectID;

- (id)initWithUsername:(NSString *)aUsername
                 token:(NSString *)aToken
             projectID:(NSString *)aProjectID;

@end
