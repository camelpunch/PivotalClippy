#import <Foundation/Foundation.h>
#import "Repository.h"

@interface RecordingDelegate : NSObject <RepositoryDelegate>

@property (nonatomic, readonly) id receivedItem;

@end
