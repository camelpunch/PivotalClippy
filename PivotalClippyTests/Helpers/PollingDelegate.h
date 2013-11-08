#import <Foundation/Foundation.h>
#import "Repository.h"

@interface PollingDelegate : NSObject <RepositoryDelegate>

@property (nonatomic, readonly) id receivedItem;

@end
