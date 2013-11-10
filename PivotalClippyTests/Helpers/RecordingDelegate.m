#import "RecordingDelegate.h"

@protocol Repository;

@implementation RecordingDelegate

- (void)repository:(id <Repository>)aRepository
      didFetchItem:(id)anItem
{
    _receivedItem = anItem;
}

- (void)URLFetcher:(id<URLFetcher>)fetcher
    didFetchObject:(id)object
{
    _receivedItem = object;
}

@end
