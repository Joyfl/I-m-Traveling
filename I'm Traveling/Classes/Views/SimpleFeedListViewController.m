//
//  SimpleFeedListViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SimpleFeedListViewController.h"
#import "Const.h"
#import "FeedDetailViewController.h"
#import "FeedObject.h"

@interface SimpleFeedListViewController ()

- (void)addSimpleFeed:(FeedObject *)feed;
- (void)addUnloadedSimpleFeed:(FeedObject *)feed;
- (void)modifySimpleFeed:(FeedObject *)feed;

@end


@implementation SimpleFeedListViewController

/**
 * From FeedDetailViewController
 */
- (id)initFromFeedDetailViewControllerFeeds:(NSMutableArray *)feeds lastFeedIndex:(NSInteger)lastFeedIndex
{
	if( self = [super init] )
	{
		_ref = 0;
		_feeds = [feeds retain];
		_lastFeedIndex = lastFeedIndex;
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}

/**
 * From Profile
 */
- (id)initFromProfile
{
	if( self = [super init] )
	{
		_ref = 1;
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark UIWebViewController

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
	
	for( FeedObject *feed in _feeds )
	{
		if( feed.complete )
			[self addSimpleFeed:feed];
		else
			[self addUnloadedSimpleFeed:feed];
	}
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"select_feed"] )
	{
		NSInteger feedId = [[arguments objectAtIndex:0] integerValue];
		NSInteger i;
		for( i = 0; i < _feeds.count; i++ )
		{
			if( [[_feeds objectAtIndex:i] feedId] == feedId )
				break;
		}
		
		FeedDetailViewController *feedDetailViewController = [[FeedDetailViewController alloc] initWithFeeds:_feeds];
		feedDetailViewController.ref = 2;
		[feedDetailViewController activateWithFeedIndex:i];
		[self.navigationController pushViewController:feedDetailViewController animated:YES];
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addSimpleFeed:(FeedObject *)feed
{
	NSString *func = [NSString stringWithFormat:@"addSimpleFeed( %d, '%@', '%@', '%@', '%@' )",
					  feed.feedId,
					  feed.pictureURL,
					  feed.place,
					  feed.time,
					  feed.review];
	[webView stringByEvaluatingJavaScriptFromString:func];
}

- (void)addUnloadedSimpleFeed:(FeedObject *)feed
{
	NSString *func = [NSString stringWithFormat:@"addUnloadedSimpleFeed( %d )", feed.feedId];
	[webView stringByEvaluatingJavaScriptFromString:func];
}

- (void)modifySimpleFeed:(FeedObject *)feed
{
	NSString *func = [NSString stringWithFormat:@"modifySimpleFeed( %d, '%@', '%@', '%@', '%@' )",
					  feed.feedId,
					  feed.pictureURL,
					  feed.place,
					  feed.time,
					  feed.review];
	[webView stringByEvaluatingJavaScriptFromString:func];
}

@end
