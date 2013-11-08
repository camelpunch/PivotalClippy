#import "StoryController.h"
#import "Story.h"

@implementation StoryController {
    id <Repository> copier;
}

- (id)initWithCopier:(id <Repository>)aCopier
{
    self = [super init];
    if (self) {
        copier = aCopier;
    }
    return self;
}

#pragma mark - NSObject

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - <RepositoryDelegate>

- (void)repository:(id<Repository>)backlog
      didFetchItem:(Story *)story
{
    [copier put:[story.storyID stringValue]];
}

@end
