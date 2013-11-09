#import "RecordingDelegate.h"

@protocol Repository;

@implementation RecordingDelegate

- (void)repository:(id <Repository>)aRepository
      didFetchItem:(id)anItem
{
    _receivedItem = anItem;
}

@end
