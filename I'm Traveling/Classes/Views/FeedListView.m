//
//  FeedListView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedListView.h"
#import "FeedDetailView.h"
#import "RegionView.h"
#import "Const.h"
#import "SBJson.h"

@interface FeedListView (Private)

- (void)deselectAlignButtons;

- (void)addFeed:(NSString *)feedId :(NSString *)userId :(NSString *)profileImgUrl :(NSString *)name :(NSString *)place :(NSString *)time :(NSString *)region :(NSString *)pictureUrl :(NSString *)review :(NSString *)numLikes :(NSString *)numComments;
- (void)removeAllFeeds;

@end


@implementation FeedListView

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
		messagePrefix = @"imtraveling:";
		
		// left
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *regionButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[regionButton setBackgroundImage:[[UIImage imageNamed:@"button_region.png"] retain] forState:UIControlStateNormal];
		[regionButton setFrame:CGRectMake( 0.0f, 0.0f, 25.0f, 25.0f )];
		[regionButton addTarget:self action:@selector(onRegionButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *regionBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:regionButton];
		regionBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		
		// title
		UIView *alignButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 226.0, 31.0 )];
		
		UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 75.0, 31.0 )];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new.png"] retain] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateHighlighted];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateDisabled];
		[newButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
		newButton.tag = kTagNewButton;
		[alignButtons addSubview:newButton];
		[newButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		
		UIButton *popularButton = [[UIButton alloc] initWithFrame:CGRectMake( 75.0, 0, 75.0, 31.0 )];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular.png"] retain] forState:UIControlStateNormal];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular_selected.png"] retain] forState:UIControlStateHighlighted];
		[popularButton setImage:[[UIImage imageNamed:@"button_popular_selected.png"] retain] forState:UIControlStateDisabled];
		[popularButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
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
		[mapButton setFrame:CGRectMake( 0.0f, 0.0f, 25.0f, 25.0f )];
		[mapButton addTarget:self action:@selector( onMapButtonTouch ) forControlEvents:UIControlEventTouchDown];
		
		UIBarButtonItem *mapBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:mapButton];
		mapBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, regionBarButtonItem, nil];
		self.navigationItem.titleView = alignButtons;
		self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightSpacer, mapBarButtonItem, nil];
		
		self.webView.frame = CGRectMake( 0, 0, 320, 367 );
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

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
//	[self loadHtmlFile:@"feed_list"];
	
	[self loadURL:URL_FEED_LIST];
}

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

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self reloadWebView];
}

- (void)messageFromWebView:(NSString *)msg
{
	NSArray *args = [msg componentsSeparatedByString:@":"];
	NSString *page = [args objectAtIndex:0];
	if( [page isEqualToString:@"feed_detail"] )
	{
		NSLog( @"feed_detail" );
		FeedDetailView *detail = [[FeedDetailView alloc] init];
		detail.feedId = [args objectAtIndex:1];
		[self.navigationController pushViewController:detail animated:YES];
	}
}

#pragma mark - pull to refresh web view

- (void)reloadWebView
{
	NSLog( @"reload webview" );
	
	[self removeAllFeeds];
	
	NSString *json = [self getHtmlFromUrl:[NSString stringWithFormat:@"%@", API_FEED_LIST]];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSMutableArray *feeds = [parser objectWithString:json];
	
	for( int i = 0; i < feeds.count; i++ )
	{
		NSMutableDictionary *feed = [feeds objectAtIndex:i];
		
		NSString *feedId = [feed objectForKey:@"FeedID"];
		NSString *userId = [feed objectForKey:@"UserID"];
		NSString *profileImgUrl = [NSString stringWithFormat:@"%@%@.jpg", API_PROFILE_IMAGE, userId];
		NSString *name = [feed objectForKey:@"Name"];
		NSString *place = [feed objectForKey:@"Place"];
		NSString *time = [feed objectForKey:@"Time"];
		NSString *region = [feed objectForKey:@"Region"];
		NSString *pictureUrl = [NSString stringWithFormat:@"%@%@_%@_%@", API_FEED_PICTURE, userId, feedId, [feed objectForKey:@"PicUrl"]];
		NSString *review = [feed objectForKey:@"Review"];
		NSString *numLikes = [feed objectForKey:@"Num_Likes"];
		NSString *numComments = [feed objectForKey:@"Num_Comments"];
		
		[self addFeed:feedId :userId :profileImgUrl :name :place :time :region :pictureUrl :review :numLikes :numComments];
	}
	
	[self webViewDidFinishReloading];
}

#pragma mark - selectors

- (void)onRegionButtonTouch
{
	RegionView *regionView = [[RegionView alloc] init];
	[self.navigationController pushViewController:regionView animated:YES];
}

- (void)onMapButtonTouch
{
	NSLog( @"map" );
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
			break;
		
		// popular
		case 2:
			break;
		
		// following
		case 1:
			break;
	}
}

- (void)alertMsg:(NSString *)msg:(NSString *)title
{
	[[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:nil] show];
}

#pragma mark - utils

- (void)selectAlignButton:(UIButton *)button
{
	button.selected = YES;
}

- (void)deselectAlignButtons
{
	for( int i = 0; i < 3; i++ )
	{
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).highlighted = NO;
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).enabled = YES;
	}
}

#pragma mark - javascript functions

- (void)addFeed:(NSString *)feedId :(NSString *)userId :(NSString *)profileImgUrl :(NSString *)name :(NSString *)place :(NSString *)time :(NSString *)region :(NSString *)pictureUrl :(NSString *)review :(NSString *)numLikes :(NSString *)numComments
{
	// addFeed(feed_id, user_id profile_image_url, name, place, time, region, picture_url, review, num_likes, num_comments)
	NSString *func = [NSString stringWithFormat:@"addFeed(%@, %@, '%@', '%@', '%@', '%@', '%@', '%@', '%@', %@, %@);", feedId, userId, profileImgUrl, name, place, time, region, pictureUrl, review, numLikes, numComments];
//	NSLog( @"%@", func );
	[webView stringByEvaluatingJavaScriptFromString:func];
}

- (void)removeAllFeeds
{
	NSLog( @"removeAllFeeds" );
	[webView stringByEvaluatingJavaScriptFromString:@"removeAllFeeds();"];
}

@end