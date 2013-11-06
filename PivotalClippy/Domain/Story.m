#import "Story.h"

@interface Story ()

@property (copy, nonatomic, readwrite) NSNumber *storyID;
@property (copy, nonatomic, readwrite) NSString *name;

@end

@implementation Story

- (id)initWithStoryID:(NSNumber *)aStoryID
                 name:(NSString *)aName
{
    self = [super init];
    if (self) {
        self.storyID = aStoryID;
        self.name = aName;
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    return [object isKindOfClass:[self class]] && [self isEqualToStory:object];
}

- (BOOL)isEqualToStory:(Story *)otherStory
{
    return ([self.storyID isEqualToNumber:otherStory.storyID] || !(self.storyID || otherStory.storyID)) &&
    ([self.name isEqualToString:otherStory.name] || !(self.name || otherStory.name));
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Story '%@' with ID %@", self.name, self.storyID];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Private

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
