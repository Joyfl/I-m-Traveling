//
//  FeedDetailWebView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "ImTravelingWebView.h"
#import "FeedObject.h"

@class FeedDetailViewController;

@interface FeedDetailWebView : ImTravelingWebView
{
	FeedDetailViewController *_detailViewController;
	
	BOOL loaded;
	FeedObject *_feed;
}

- (id)initWithFeedDetailViewController:(FeedDetailViewController *)detailViewController;
- (void)createFeedDetail:(FeedObject *)feedObj;

@property (nonatomic, assign) BOOL loaded;

@end
