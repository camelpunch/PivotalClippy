@import Foundation;

@class Story, User;
@interface StoryBuilder : NSObject

- (id)storyID:(NSNumber *)aStoryID;
- (id)name:(NSString *)aName;
- (id)owner:(User *)aUser;
- (Story *)build;

@end
