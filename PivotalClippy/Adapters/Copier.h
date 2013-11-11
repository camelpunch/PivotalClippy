#import <Foundation/Foundation.h>
#import "Repository.h"

@interface NothingToCopy : NSException
@end

@interface Copier : NSObject <Repository>

- (id)initWithPasteboard:(NSPasteboard *)aPasteboard;

@end