#import <Foundation/Foundation.h>
#import "Repository.h"

@interface StoryController : NSObject <RepositoryDelegate>

- (id)initWithCopier:(id <Repository>)aCopier;

@end
