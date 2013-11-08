#import <Foundation/Foundation.h>
#import "Repository.h"

@interface Copier : NSObject <Repository>

- (id)initWithPasteboard:(NSPasteboard *)aPasteboard;

@end
