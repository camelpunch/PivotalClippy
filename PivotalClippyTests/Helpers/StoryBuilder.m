#import "StoryBuilder.h"
#import "Story.h"

@interface StoryBuilder ()

@property (nonatomic) NSNumber *storyID;
@property (nonatomic) NSString *name;
@property (nonatomic) User *owner;

@end

@implementation StoryBuilder

- (id)storyID:(NSNumber *)aStoryID
{
    self.storyID = aStoryID;
    return self;
}

- (id)name:(NSString *)aName
{
    self.name = aName;
    return self;
}

- (id)owner:(User *)aUser
{
    self.owner = aUser;
    return self;
}

- (Story *)build
{
    return [[Story alloc] initWithStoryID:self.storyID
                                     name:self.name
                                    owner:self.owner];
}

@end
