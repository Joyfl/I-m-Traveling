//
//  ProfileView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ProfileViewController.h"
#import "SettingsManager.h"
#import "Const.h"
#import "Utils.h"


@implementation ProfileViewController

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor darkGrayColor];
		
		_coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, -85, 320, 320 )];
		[_coverImageView setImage:[UIImage imageNamed:@"cover_temp.jpg"]];
		[self.view addSubview:_coverImageView];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		_scrollView.delegate = self;
		[self.view addSubview:_scrollView];
		_scrollView.contentSize = CGSizeMake( 320, 368 );
		
		self.webView.frame = CGRectMake( 0, 97, 320, 471 );
		self.webView.backgroundColor = [UIColor clearColor];
		self.webView.opaque = NO;
		self.webView.scrollView.scrollEnabled = NO;
		[self loadPage:HTML_INDEX];
		[_scrollView addSubview:self.webView];
		
		user = [[UserObject alloc] init];
    }
    return self;
}

- (void)setUserId:(NSInteger)userId
{
	user.userId = userId;
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
	if( !created )
	{
//		[_webView clear];
//		[self prepareProfile];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UIWebViewController

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
	[self prepareProfile];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"profile_following"] )
	{
		
	}
	else if( [message isEqualToString:@"profile_followers"] )
	{
		
	}
	else if( [message isEqualToString:@"profile_trips"] )
	{
		
	}
}


#pragma mark -
#pragma mark Profile

- (void)prepareProfile
{
	if( user.complete )
	{
		[self createProfile];
	}
	else
	{
		[self loadProfile];
	}
	
	created = YES;
}

- (void)loadProfile
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_PROFILE, user.userId]];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *u = [Utils parseJSON:result];
	user.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, user.userId];
	user.name = [u objectForKey:@"name"];
	user.nation = [u objectForKey:@"nation"];
	user.numFeeds = [[u objectForKey:@"num_feeds"] integerValue];
	user.numTrips = [[u objectForKey:@"num_trips"] integerValue];
	user.numFollowers = [[u objectForKey:@"num_followers"] integerValue];
	user.numFollowings = [[u objectForKey:@"num_followings"] integerValue];
	user.complete = YES;
	
	[self createProfile];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect frame = _coverImageView.frame;
	
	if( _scrollView.contentOffset.y > 0 )
	{
		frame.origin.y = -85 - _scrollView.contentOffset.y;
	}
	else
	{
		if( _scrollView.contentOffset.y > -170 )
			frame.origin.y = -85 - _scrollView.contentOffset.y / 2;
		else
			frame.origin.y = -170 - _scrollView.contentOffset.y;
	}
	
	_coverImageView.frame = frame;
}


#pragma mark -
#pragma mark JavaScript Function

- (void)createProfile
{
	[self clear];
	
	NSString *func = [NSString stringWithFormat:@"createProfile(%d, '%@', '%@', '%@', %d, '%@', %d, '%@', %d, '%@', %d, %d )",
					  user.userId,
					  user.profileImageURL,
					  user.name,
					  user.nation,
					  user.numTrips,
					  NSLocalizedString( @"TRIPS", @"" ),
					  user.numFollowers,
					  NSLocalizedString( @"FOLLOWING", @"" ),
					  user.numFollowings,
					  NSLocalizedString( @"FOLLOWERS", @"" ),
					  /*notice*/0,
					  0];
	
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	
	//	NSLog( @"%@", func );
}

@end
