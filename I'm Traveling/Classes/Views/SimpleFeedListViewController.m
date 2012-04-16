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
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[backButton setBackgroundImage:[UIImage imageNamed:@"button_back.png"] forState:UIControlStateNormal];
		[backButton setFrame:CGRectMake( 0.0f, 0.0f, 50.0f, 31.0f )];
		[backButton addTarget:self action:@selector(backButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		backBarButtonItem.style = UIBarButtonItemStyleBordered;
		[backButton release];
		
		self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSpacer, backBarButtonItem, nil];
		[leftSpacer release];
		[backBarButtonItem release];
		
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
		[feedDetailViewController release];
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
