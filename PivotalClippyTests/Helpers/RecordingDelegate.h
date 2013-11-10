#import <Foundation/Foundation.h>
#import "Repository.h"
#import "URLFetcher.h"

@interface RecordingDelegate : NSObject <RepositoryDelegate, URLFetcherDelegate>

@property (nonatomic, readonly) id receivedItem;

@end
