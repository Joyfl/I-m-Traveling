//
//  LoadingQueue.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 22..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "LoadingQueue.h"

@implementation LoadingQueue

@synthesize firstIndex, maxIndex;

- (id)init
{
	if( self = [super init] )
	{
		_loadingQueue = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addFeedIndex:(NSInteger)index
{
	if( 0 <= index && index < self.maxIndex )
		[_loadingQueue addObject:[NSNumber numberWithInt:index]];
}

- (void)removeLoadedFeedFromLoadingQueue
{
	if( _loadingQueue.count > 0 )
		[_loadingQueue removeObjectAtIndex:0];
}

- (void)removeAllObjects
{
	[_loadingQueue removeAllObjects];
}

- (NSInteger)count
{
	return _loadingQueue.count;
}

- (NSInteger)firstIndex
{
	if( _loadingQueue.count == 0 ) return NSNotFound;
	return [[_loadingQueue objectAtIndex:0] integerValue];
}

@end
