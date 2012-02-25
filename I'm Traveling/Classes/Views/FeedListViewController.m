//
//  FeedListView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedListViewController.h"
#import "RegionViewController.h"
#import "Const.h"
#import "Utils.h"
#import "FeedObject.h"

@interface FeedListViewController (Private)

- (void)deselectAlignButtons;
- (void)addFeed:(FeedObject *)feedObj;
- (void)loadFeedsFrom:(NSInteger)from to:(NSInteger)to;

@end


@implementation FeedListViewController

enum {
	kTagNewButton = 0,
	kTagPopularButton = 1,
	kTagFollowingButton = 2
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		// left
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *regionButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[regionButton setBackgroundImage:[[UIImage imageNamed:@"button_region.png"] retain] forState:UIControlStateNormal];
		[regionButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[regionButton addTarget:self action:@selector(onRegionButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *regionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regionButton];
		regionBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		
		// title
		UIView *alignButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 226.0, 31.0 )];
		
		UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 75.0, 31.0 )];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new.png"] retain] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateHighlighted];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateDisabled];
		[newButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		newButton.tag = kTagNewButton;
		[alignButtons addSubview:newButton];
		[newButton sendActionsForControlEvents:UIControlEventTouchDown];
		
		UIButton *popularButton = [[UIButton alloc] initWithFrame:CGRectMake( 75.0, 0, 75.0, 31.0 )];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular.png"] retain] forState:UIControlStateNormal];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular_selected.png"] retain] forState:UIControlStateHighlighted];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular_selected.png"] retain] forState:UIControlStateDisabled];
		[popularButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		popularButton.tag = kTagPopularButton;
		[alignButtons addSubview:popularButton];
		
		UIButton *followingButton = [[UIButton alloc] initWithFrame:CGRectMake( 150.0, 0, 76.0, 31.0 )];
		[followingButton setImage:[[UIImage imageNamed:@"button_following.png"] retain] forState:UIControlStateNormal];
		[followingButton setImage:[[UIImage imageNamed:@"button_following_selected.png"] retain] forState:UIControlStateHighlighted];
		[followingButton setImage:[[UIImage imageNamed:@"button_following_selected.png"] retain] forState:UIControlStateDisabled];
		[followingButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		followingButton.tag = kTagFollowingButton;
		[alignButtons addSubview:followingButton];
		
		
		// right
		UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		rightSpacer.width = 4;
		
		UIButton *mapButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[mapButton setBackgroundImage:[[UIImage imageNamed:@"button_map.png"] retain] forState:UIControlStateNormal];
		[mapButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[mapButton addTarget:self action:@selector( onMapButtonTouch ) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *mapBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
		mapBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, regionBarButtonItem, nil];
		self.navigationItem.titleView = alignButtons;
		self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightSpacer, mapBarButtonItem, nil];
		
		self.webView.frame = CGRectMake( 0, 0, 320, 367 );
		
		_feedListObjects = [[NSMutableDictionary alloc] init];
		
		_mapViewController = [[MapViewController alloc] init];
		
		
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];	
}
 */

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	if( !loaded )
	{
		//	[self loadHtmlFile:@"feed_list"];
		[self loadRemotePage:HTML_INDEX];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
	[self reloadWebView];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"feed_detail"] )
	{
		float originalOffset = webView.scrollView.contentOffset.y;
		
		float offset = [[arguments objectAtIndex:1] floatValue];
		
		UIGraphicsBeginImageContext( CGSizeMake( 320, offset ) );
		[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *upperImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.webView.scrollView.contentOffset = CGPointMake( 0, webView.scrollView.contentOffset.y + offset );
		
		UIGraphicsBeginImageContext( CGSizeMake( 320, self.webView.scrollView.contentSize.height - offset ) );
		[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *lowerImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.webView.scrollView.contentOffset = CGPointMake( 0, originalOffset );
		
		FeedDetailViewController *detailViewController = [FeedDetailViewController viewController];
		[detailViewController setUpperImageView:[[UIImageView alloc] initWithImage:upperImage] lowerImageView:[[UIImageView alloc] initWithImage:lowerImage] lowerImageViewOffset:offset];
		detailViewController.ref = 0;
		[detailViewController activateWithFeedObject:[_feedListObjects objectForKey:[NSNumber numberWithInteger:[[arguments objectAtIndex:0] integerValue]]]];
		[self.navigationController pushViewController:detailViewController animated:NO];
	}
}

#pragma mark - UIPullDownWebViewController

- (void)reloadWebView
{
	[self loadURL:[NSString stringWithFormat:@"%@?order_type=%d&from=%d&to=%d", API_FEED_LIST, _orderType, 0, 10]];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSArray *feeds = [Utils parseJSON:result];
	for( NSDictionary *feed in feeds )
	{
		FeedObject *feedObj = [[FeedObject alloc] init];
		feedObj.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		feedObj.userId = [[feed objectForKey:@"user_id"] integerValue];
		feedObj.name = [feed objectForKey:@"name"];
		feedObj.profileImageURL = [[NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, feedObj.userId] retain];
		feedObj.place = [feed objectForKey:@"place"];
		feedObj.region = [feed objectForKey:@"region"];
		feedObj.time = [feed objectForKey:@"time"];
		feedObj.pictureURL = [[NSString stringWithFormat:@"%@%d_%d.jpg", API_FEED_IMAGE, feedObj.userId, feedObj.feedId] retain];
		feedObj.review = [feed objectForKey:@"review"];
		feedObj.numLikes = [[feed objectForKey:@"num_likes"] integerValue];
		feedObj.numComments = [[feed objectForKey:@"num_comments"] integerValue];
		feedObj.latitude = [[feed objectForKey:@"latitude"] doubleValue];
		feedObj.longitude = [[feed objectForKey:@"longitude"] doubleValue];
		[self addFeed:feedObj];
	}
	
	[self webViewDidFinishReloading];
	
	loaded = YES;
}

#pragma mark - selectors

- (void)onRegionButtonTouch
{
	RegionViewController *regionViewController = [[RegionViewController alloc] init];
	[self.navigationController pushViewController:regionViewController animated:YES];
}

- (void)onMapButtonTouch
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
	[self.navigationController pushViewController:_mapViewController animated:NO];
	[UIView commitAnimations];
}

- (void)onAlignButtonTouch:(id)sender
{
	[self deselectAlignButtons];
	
	UIButton *button = (UIButton *)sender;
	button.highlighted = YES;
	button.enabled = NO;
	
	switch( button.tag )
	{
		// new
		case 0:
			_orderType = 0;
			break;
		
		// popular
		case 1:
			_orderType = 1;
			break;
		
		// following
		case 2:
			_orderType = 2;
			break;
	}
	
	[self reloadWebView];
}

#pragma mark - Javascript Functions

- (void)addFeed:(FeedObject *)feedObj
{
	[_feedListObjects setObject:feedObj forKey:[NSNumber numberWithInteger:feedObj.feedId]];
	
	NSString *func = [[NSString stringWithFormat:@"addFeed(%d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   feedObj.feedId,
					   feedObj.userId,
					   feedObj.profileImageURL,
					   feedObj.name,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.pictureURL,
					   feedObj.review,
					   feedObj.numLikes,
					   feedObj.numComments] retain];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
//	NSLog( @"%@", func );
}

#pragma mark - utils

- (void)deselectAlignButtons
{
	for( int i = 0; i < 3; i++ )
	{
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).highlighted = NO;
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).enabled = YES;
	}
}

@end