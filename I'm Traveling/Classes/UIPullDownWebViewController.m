//
//  PullToRefreshTableViewController.m
//  TableViewPull
//
//  Created by Jesse Collis on 1/07/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import "EGORefreshTableHeaderView.h"


@implementation UIPullDownWebViewController

@synthesize reloading=_reloading;
@synthesize refreshHeaderView;


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	webView.scrollView.delegate = self;
	
	if (refreshHeaderView == nil) {
		refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.webView.bounds.size.height, 320.0f, self.webView.bounds.size.height)];
		refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		refreshHeaderView.bottomBorderThickness = 1.0;
		[webView.scrollView addSubview:refreshHeaderView];
		webView.scrollView.showsVerticalScrollIndicator = YES;
		[refreshHeaderView release];
	}
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */


#pragma mark -
#pragma mark ScrollView Callbacks
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
		
		[self performSelector:@selector(reloadWebView) withObject:nil afterDelay:1.0];
		
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		
		webView.scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}

#pragma mark -
#pragma mark refreshHeaderView Methods

- (void)reloadWebView
{
	NSLog(@"Please override reloadTableViewDataSource");
}

- (void)webViewDidFinishReloading
{
	_reloading = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	webView.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
	[UIView commitAnimations];
	
	[refreshHeaderView setCurrentDate];
	[refreshHeaderView setState:EGOOPullRefreshNormal];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
	refreshHeaderView=nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

