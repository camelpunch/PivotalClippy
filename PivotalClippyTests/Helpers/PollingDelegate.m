#import "PollingDelegate.h"

@protocol Repository;

@implementation PollingDelegate

- (void)repository:(id <Repository>)aRepository
      didFetchItem:(id)anItem
{
    _receivedItem = anItem;
}

@end
