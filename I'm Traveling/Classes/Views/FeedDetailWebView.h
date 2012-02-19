//
//  FeedDetailWebView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedDetailViewController.h"
#import "ImTravelingWebView.h"

@interface FeedDetailWebView : ImTravelingWebView
{
	FeedDetailViewController *_detailViewController;
	FeedObject *feedObject; // 해당 웹뷰가 그리는 Feed의 정보
}

- (id)initWithFeedDetailViewController:(FeedDetailViewController *)detailViewController;
- (void)createFeedDetail:(FeedObject *)feedObj;

@property (nonatomic, retain) FeedObject *feedObject;

@end
