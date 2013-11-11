#import "RecordingDelegate.h"

@protocol Repository;

@implementation RecordingDelegate

#pragma mark - <RepositoryDelegate>

- (void)repository:(id <Repository>)aRepository
      didFetchItem:(id)anItem
{
    _receivedItem = anItem;
}

#pragma mark - <URLFetcherDelegate>

- (void)URLFetcher:(id<URLFetcher>)fetcher
    didFetchObject:(id)object
{
    _receivedItem = object;
}

- (void)URLFetcher:(id<URLFetcher>)fetcher
didFailToFetchWithError:(NSError *)error
{
    _receivedItem = error;
}

@end
