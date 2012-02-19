//
//  FeedDetailWebView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedDetailViewController.h"

@interface FeedDetailWebView : UIWebViewController
{
	FeedDetailViewController *_detailViewController;
}

- (id)initWithFeedDetailViewController:(FeedDetailViewController *)detailViewController;
- (void)createFeedDetail:(FeedObject *)feedObj;

@end
