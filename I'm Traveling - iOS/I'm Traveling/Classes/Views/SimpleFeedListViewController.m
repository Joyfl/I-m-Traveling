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
#import "ImTravelingBarButtonItem.h"

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
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		
		self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSpacer, backButton, nil];
		[leftSpacer release];
		[backButton release];
		
		_ref = 0;
		_feeds = [feeds retain];
		_lastFeedIndex = lastFeedIndex;
		[self loadPage:HTML_INDEX];
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
		[self loadPage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Bar Selectors

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
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
	/*
	if( [message isEqualToString:@"select_feed"] )
	{
		[self startBusy];
		
		NSInteger feedId = [[arguments objectAtIndex:0] integerValue];
		NSInteger i;
		for( i = 0; i < _feeds.count; i++ )
		{
			if( [[_feeds objectAtIndex:i] feedId] == feedId )
				break;
		}
		
		FeedDetailViewController *feedDetailViewController = [[FeedDetailViewController alloc] initFromSimpleListWithFeedIndex:i];
		[self.navigationController pushViewController:feedDetailViewController animated:YES];
		[feedDetailViewController release];
	}
	*/
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
