//
//  LoadingQueue.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 22..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingQueue : NSObject
{
	NSMutableArray *_loadingQueue;
	NSInteger maxIndex;
}

@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) NSInteger firstIndex;
@property (nonatomic, assign) NSInteger maxIndex;

- (void)addFeedIndex:(NSInteger)index;
- (void)removeLoadedFeedFromLoadingQueue;
- (void)removeAllObjects;

@end
