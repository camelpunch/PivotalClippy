#import <Foundation/Foundation.h>

@interface Story : NSObject <NSCopying>

@property (copy, nonatomic, readonly) NSNumber *storyID;
@property (copy, nonatomic, readonly) NSString *name;

- (id)initWithStoryID:(NSNumber *)aStoryID
                 name:(NSString *)aName;

@end
