#import <Foundation/Foundation.h>

@class User;
@interface Story : NSObject <NSCopying>

@property (copy, nonatomic, readonly) NSNumber *storyID;
@property (copy, nonatomic, readonly) NSNumber *ownerID;
@property (copy, nonatomic, readonly) NSString *name;

- (id)initWithStoryID:(NSNumber *)aStoryID
                 name:(NSString *)aName
                owner:(User *)aUser;

@end
