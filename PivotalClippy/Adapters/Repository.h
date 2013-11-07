#import <Foundation/Foundation.h>

@protocol Repository;
@protocol RepositoryDelegate <NSObject>

@optional

- (void)repository:(id <Repository>)aRepository
      didFetchItem:(id)anItem;

- (void)repository:(id<Repository>)aRepository
        didPutItem:(id)anItem;

@end

@protocol Repository <NSObject>

@optional

@property (weak, nonatomic) id <RepositoryDelegate> delegate;

- (void)fetchItem;
- (void)put:(id)anItem;

@end
