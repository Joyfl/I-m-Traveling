//
//  FeedListView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPullDownWebViewController.h"
#import "FeedDetailViewController.h"
#import "MapViewController.h"

@interface FeedListViewController : UIPullDownWebViewController
{
	MapViewController *_mapViewController;
	
	UIWebView *subWebView;
	
	NSMutableDictionary *_feedListObjects;
	
	NSInteger _orderType;
}

@end
