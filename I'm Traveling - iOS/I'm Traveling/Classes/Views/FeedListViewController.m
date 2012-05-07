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
#import "ImTravelingNavigationController.h"
#import "ProfileViewController.h"
#import "DejalActivityView.h"

@interface FeedListViewController (Private)

- (void)deselectAlignButtons;
- (FeedObject *)createFeedFromDictionary:(NSDictionary *)feed;
- (void)addFeed:(FeedObject *)feedObj top:(BOOL)top;
- (void)addFeed:(FeedObject *)feedObj;
- (void)addFeedTop:(FeedObject *)feedObj;
- (void)loadFeedsFrom:(NSInteger)from to:(NSInteger)to;

@end


@implementation FeedListViewController

enum {
	kTagNewButton = 0,
	kTagPopularButton = 1,
	kTagFollowingButton = 2
};

- (id)init
{
    if( self = [super init] )
	{
		// left
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *regionButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[regionButton setBackgroundImage:[UIImage imageNamed:@"button_region.png"] forState:UIControlStateNormal];
		[regionButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[regionButton addTarget:self action:@selector(onRegionButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *regionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regionButton];
		regionBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, regionBarButtonItem, nil];
		[leftSpacer release];
		[regionBarButtonItem release];
		
		
		// title
		UIView *alignButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 228, 31 )];
		
		UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 76, 31 )];
		newButton.tag = kTagNewButton;
		newButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		newButton.titleEdgeInsets = UIEdgeInsetsMake( 0, 4, 0, 0 );
		[newButton setTitle:NSLocalizedString( @"NEW", @"" ) forState:UIControlStateNormal];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left.png"] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left_selected.png"] forState:UIControlStateHighlighted];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left_selected.png"] forState:UIControlStateDisabled];
		[newButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		[alignButtons addSubview:newButton];
		newButton.highlighted = YES;
		newButton.enabled = NO;
		[newButton release];
		
		UIButton *popularButton = [[UIButton alloc] initWithFrame:CGRectMake( 76, 0, 76, 31 )];
		popularButton.tag = kTagPopularButton;
		popularButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		[popularButton setTitle:NSLocalizedString( @"POPULAR", @"" ) forState:UIControlStateNormal];
		[popularButton setBackgroundImage:[UIImage imageNamed:@"button_bar_center.png"] forState:UIControlStateNormal];
		[popularButton setBackgroundImage:[UIImage imageNamed:@"button_bar_center_selected.png"] forState:UIControlStateHighlighted];
		[popularButton setBackgroundImage:[UIImage imageNamed:@"button_bar_center_selected.png"] forState:UIControlStateDisabled];
		[popularButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		[alignButtons addSubview:popularButton];
		[popularButton release];
		
		UIButton *followingButton = [[UIButton alloc] initWithFrame:CGRectMake( 149, 0, 76, 31 )];
		followingButton.tag = kTagFollowingButton;
		followingButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		followingButton.titleEdgeInsets = UIEdgeInsetsMake( 0, -4, 0, 0 );
		[followingButton setTitle:NSLocalizedString( @"FOLLOWING", @"" ) forState:UIControlStateNormal];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right.png"] forState:UIControlStateNormal];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right_selected.png"] forState:UIControlStateHighlighted];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right_selected.png"] forState:UIControlStateDisabled];
		[followingButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		[alignButtons addSubview:followingButton];
		[followingButton release];
		
		self.navigationItem.titleView = alignButtons;
		[alignButtons release];
		
		
		// right
		UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		rightSpacer.width = 4;
		
		UIButton *mapButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[mapButton setBackgroundImage:[[UIImage imageNamed:@"button_map.png"] retain] forState:UIControlStateNormal];
		[mapButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[mapButton addTarget:self action:@selector( onMapButtonTouch ) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *mapBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
		mapBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightSpacer, mapBarButtonItem, nil];
		
		self.webView.frame = CGRectMake( 0, 0, 320, 367 );
		self.webView.backgroundColor = [UIColor darkGrayColor];
		
		_feedListObjects = [[NSMutableDictionary alloc] init];
		
		_mapViewController = [[MapViewController alloc] init];
		
		[self loadPage:HTML_INDEX];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Loading

- (void)loadFeedsFrom:(NSInteger)from to:(NSInteger)to
{
	NSLog( @"load %d ~ %d", _feedListObjects.count, _feedListObjects.count + 10 );
	
	loading = YES;
	[self loadURL:[NSString stringWithFormat:@"%@?order_type=%d&from=%d&to=%d", API_FEED_LIST, _orderType, from, to]];
}


#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self performSelector:@selector(clearAndReloadWebView) withObject:nil afterDelay:0.5];
}

- (void)clearAndReloadWebView
{
	[self clear];
	[self reloadWebView];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"feed_detail"] )
	{
		NSLog( @"detail" );
		NSDate *date = [NSDate date];
		
		[self startBusy];
		
		CGFloat originalOffset = webView.scrollView.contentOffset.y;
		
		CGFloat offset = [[arguments objectAtIndex:1] floatValue];
//		CGFloat height = [[arguments objectAtIndex:2] floatValue];
		UIImage *upperImage;
		
		if( offset > 0 )
		{
			// Upper Image
			CGSize upperImageSize = CGSizeMake( 320, offset );
			
			if( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] )
			{
				if( [[UIScreen mainScreen] scale] == 2.0 )
					UIGraphicsBeginImageContextWithOptions( upperImageSize, NO, 2.0 );
				
				else
					UIGraphicsBeginImageContext( upperImageSize );
			}
			else
			{
				UIGraphicsBeginImageContext( upperImageSize );
			}
			
			[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
			upperImage = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
		}
		else
		{
			upperImage = [[UIImage alloc] init];
		}
		
		// Lower Image
		self.webView.scrollView.contentOffset = CGPointMake( 0, webView.scrollView.contentOffset.y + offset );
		
		CGRect originalFrame = self.webView.frame;
		CGRect frame = originalFrame;
		frame.origin.y -= ABS( offset );
		frame.size.height = 367 + ABS( offset );
		self.webView.frame = frame;
		
		CGSize lowerImageSize = CGSizeMake( 320, 600 );
		
		if( [[UIScreen mainScreen] respondsToSelector:@selector(scale)] )
		{
			if( [[UIScreen mainScreen] scale] == 2.0 )
				UIGraphicsBeginImageContextWithOptions( lowerImageSize, NO, 2.0 );
			
			else
				UIGraphicsBeginImageContext( lowerImageSize );
		}
		else
		{
			UIGraphicsBeginImageContext( lowerImageSize );
		}
		
		[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIImage *lowerImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		self.webView.scrollView.contentOffset = CGPointMake( 0, originalOffset );
		self.webView.frame = originalFrame;
		
		FeedDetailViewController *detailViewController = [[FeedDetailViewController alloc] initFromListWithFeed:[_feedListObjects objectForKey:[NSNumber numberWithInteger:[[arguments objectAtIndex:0] integerValue]]] upperImage:upperImage lowerImage:lowerImage lowerImageViewOffset:offset];		
		[self.navigationController pushViewController:detailViewController animated:NO];
		[detailViewController release];
		
		NSLog( @"interval : %f", [[NSDate date] timeIntervalSinceDate:date] );
	}
	else if( [message isEqualToString:@"create_profile"] )
	{
		ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
		[profileViewController activateWithUserId:[[arguments objectAtIndex:0] integerValue] userName:[Utils decodeURI:[arguments objectAtIndex:1]]];
		[self.navigationController pushViewController:profileViewController animated:YES];
		[profileViewController release];
	}
}

#pragma mark - UIPullDownWebViewController

- (void)reloadWebView
{
	reloading = YES;
	[self loadFeedsFrom:0 to:10];
}

- (void)loadingDidFinish:(NSString *)data
{
	NSDictionary *json = [Utils parseJSON:data];
	if( [self isError:json] )
	{
		NSLog( @"Error" );
		return;
	}
	
	NSArray *feeds = [json objectForKey:@"result"];
	
	// reload일 경우에는 리스트의 위에 로딩한 피드를 역순으로 추가한다.
	if( reloading )
	{
		for( NSInteger i = feeds.count - 1; i >= 0; i-- )
			[self addFeedTop:[self createFeedFromDictionary:[feeds objectAtIndex:i]]];
	}
	else
	{
		for( NSInteger i = 0; i < feeds.count; i++ )	
			[self addFeed:[self createFeedFromDictionary:[feeds objectAtIndex:i]]];
	}
	
	[self webViewDidFinishReloading];
	
	loading = NO;
	reloading = NO;
}

- (FeedObject *)createFeedFromDictionary:(NSDictionary *)feed
{
	FeedObject *feedObj = [[[FeedObject alloc] init] autorelease];
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
	return feedObj;
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


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[super scrollViewDidScroll:scrollView];
	
	if( scrollView.contentOffset.y > scrollView.contentSize.height - 1000 )
	{
		if( !loading )
		{
			reloading = NO;
			[self loadFeedsFrom:_feedListObjects.count to:_feedListObjects.count + 10];
		}
	}
}


#pragma mark - Javascript Functions

- (void)addFeed:(FeedObject *)feedObj top:(BOOL)top
{
	NSNumber *key = [NSNumber numberWithInteger:feedObj.feedId];
	
	// 이미 해당 피드를 가지고 있을 경우 리턴한다.
	if( [_feedListObjects objectForKey:key] != nil )
		return;
	
	[_feedListObjects setObject:feedObj forKey:key];
	
	NSString *functionName = top ? @"addFeedTop" : @"addFeed";
	NSString *func = [NSString stringWithFormat:@"%@(%d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   functionName,
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
					   feedObj.numComments];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
//	NSLog( @"%@", func );
}

- (void)addFeed:(FeedObject *)feedObj
{
	[self addFeed:feedObj top:NO];
}

- (void)addFeedTop:(FeedObject *)feedObj
{
	[self addFeed:feedObj top:YES];
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