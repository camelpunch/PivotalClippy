#import <Foundation/Foundation.h>

@class KSPromise, User;
@protocol StoryRepository <NSObject>

- (KSPromise *)fetchCurrentStoryForUser:(User *)aUser;

@end


@class KSPromise;
@protocol Repository <NSObject>

@optional

- (KSPromise *)fetch;
- (KSPromise *)put:(id)anItem;

@end
