//
//  PullToRefreshTableViewController.h
//  TableViewPull
//
//  Created by Jesse Collis on 1/07/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

//
//  PullToRefreshWebViewController.h
//  WebViewPull
//
//  Created by Xoul on 1/22/12.
//  Copyright 2010 Xoul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWebViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface UIPullDownWebViewController : UIWebViewController <UIWebViewDelegate, UIScrollViewDelegate>
{
	EGORefreshTableHeaderView *refreshHeaderView;

	BOOL _reloading;
}

@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) EGORefreshTableHeaderView *refreshHeaderView;

- (void)reloadWebView;
- (void)webViewDidFinishReloading;


@end
