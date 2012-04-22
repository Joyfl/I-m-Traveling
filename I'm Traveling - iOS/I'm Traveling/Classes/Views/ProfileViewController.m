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
#import "TripObject.h"


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
		
		self.webView.frame = CGRectMake( 0, 97, 320, 270 );
		self.webView.backgroundColor = [UIColor clearColor];
		self.webView.opaque = NO;
		self.webView.scrollView.scrollEnabled = NO;
		[self loadPage:HTML_INDEX];
		[_scrollView addSubview:self.webView];
		
		user = [[UserObject alloc] init];
		trips = [[NSMutableArray alloc] init];
		followers = [[NSMutableArray alloc] init];
		followings = [[NSMutableArray alloc] init];
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

/*
- (void)viewDidAppear:(BOOL)animated
{
	
}
*/

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
	if( [message isEqualToString:@"profile_trips"] )
	{
		currentTab = 0;
		[self clearTabContents];
		[self prepareTrips];
	}
	else if( [message isEqualToString:@"profile_following"] )
	{
		currentTab = 1;
		[self clearTabContents];
		[self prepareFollowings];
	}
	else if( [message isEqualToString:@"profile_followers"] )
	{
		currentTab = 2;
		[self clearTabContents];
		[self prepareFollowers];
	}
}


#pragma mark -
#pragma mark Prepare

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
}

- (void)prepareTrips
{
	if( loadingProgress > 1 )
		[self createTrips];	
}

- (void)prepareFollowings
{
	if( loadingProgress > 2 )
		[self createFollowings];
}

- (void)prepareFollowers
{
	if( loadingProgress > 3 )
		[self createFollowers];
}


#pragma mark -
#pragma mark Load

- (void)loadProfile
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_PROFILE, user.userId]];
}

- (void)loadTrips
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_TRIP_LIST, user.userId]];
}

- (void)loadFollowings
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_FOLLOWING_LIST, user.userId]];
}

- (void)loadFollowers
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_FOLLOWERS_LIST, user.userId]];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSLog( @"process : %d, tab : %d", loadingProgress, currentTab );
	
	switch( loadingProgress++ )
	{
		case 0:
		{
			NSDictionary *json = [Utils parseJSON:result];
			user.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, user.userId];
			user.name = [json objectForKey:@"name"];
			user.nation = [json objectForKey:@"nation"];
			user.numFeeds = [[json objectForKey:@"num_feeds"] integerValue];
			user.numTrips = [[json objectForKey:@"num_trips"] integerValue];
			user.numFollowers = [[json objectForKey:@"num_followers"] integerValue];
			user.numFollowings = [[json objectForKey:@"num_followings"] integerValue];
			user.complete = YES;
			
			[self createProfile];
			[self loadTrips];
			
			break;
		}
			
		case 1:
		{
			NSArray *json = [Utils parseJSON:result];
			for( NSDictionary *t in json )
			{
				TripObject *trip = [[TripObject alloc] init];
				trip.tripId = [[t objectForKey:@"trip_id"] integerValue];
				trip.title = [t objectForKey:@"trip_title"];
				trip.startDate = [t objectForKey:@"start_date"];
				trip.endDate = [t objectForKey:@"end_date"];
				trip.summary = [t objectForKey:@"summary"];
				trip.numFeeds = [[t objectForKey:@"num_feeds"] integerValue];
				[trips addObject:trip];
				[trip release];
			}
			
			if( currentTab == 0 )
			{
				[self prepareTrips];
				[self stopBusy];
			}
			
//			[self loadFollowings];
#warning temp code
			[self loadingDidFinish:@"[{\"dest_id\":1, \"dest_name\":\"진재규\"}, {\"dest_id\":3, \"dest_name\":\"설진석\"}]"];
			
			break;
		}
			
		case 2:
		{
			NSArray *json = [Utils parseJSON:result];
			for( NSDictionary *u in json )
			{
				UserObject *following = [[UserObject alloc] init];
				following.userId = [[u objectForKey:@"dest_id"] integerValue];
				following.name = [u objectForKey:@"dest_name"];
				following.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, following.userId];
				[followings addObject:following];
				[following release];
			}
			
			if( currentTab == 1 )
			{
				[self prepareFollowings];
				[self stopBusy];
			}
			
#warning temp code
			[self loadingDidFinish:@"[{\"src_id\":4, \"src_name\":\"우철규\"}]"];
			
			break;
		}
			
		case 3:
		{
			NSArray *json = [Utils parseJSON:result];
			for( NSDictionary *u in json )
			{
				UserObject *follower = [[UserObject alloc] init];
				follower.userId = [[u objectForKey:@"src_id"] integerValue];
				follower.name = [u objectForKey:@"src_name"];
				follower.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, follower.userId];
				[followers addObject:follower];
				[follower release];
			}
			
			if( currentTab == 2 )
			{
				[self prepareFollowers];
				[self stopBusy];
			}
			
			break;
		}
			
		case 4:
		{
			[self stopBusy];
			break;
		}
	}
}


#pragma mark -
#pragma mark Create

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

- (void)createTrips
{
	for( TripObject *trip in trips )
	{
		NSString *func = [NSString stringWithFormat:@"addSimpleTrip( %d, '%@', '%@', '%@', '%@', '%@', %d );",
						  trip.tripId,
						  @"http://imtraveling.joyfl.kr/feed/2_5.jpg",
						  trip.title,
						  trip.startDate,
						  trip.endDate,
						  trip.summary,
						  trip.numFeeds];
		[self.webView stringByEvaluatingJavaScriptFromString:func];
	}
	
	[self resizeContentHeight];
}

- (void)createFollowings
{
	for( UserObject *following in followings )
	{
		NSString *func = [NSString stringWithFormat:@"addPerson( %d, '%@', '%@', '%@', %d );",
						  following.userId,
						  following.profileImageURL,
						  following.name,
						  /*following.nation*/@"KOR",
						  1];
		[self.webView stringByEvaluatingJavaScriptFromString:func];
	}
	
	[self resizeContentHeight];
}

- (void)createFollowers
{
	for( UserObject *follower in followers )
	{
		NSString *func = [NSString stringWithFormat:@"addPerson( %d, '%@', '%@', '%@', %d );",
						  follower.userId,
						  follower.profileImageURL,
						  follower.name,
						  /*follower.nation*/@"KOR",
						  1];
		[self.webView stringByEvaluatingJavaScriptFromString:func];
	}
	
	[self resizeContentHeight];
}


#pragma mark -
#pragma mark JavaScript Functions

- (void)clearTabContents
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"var children = page.children; for( var i = children.length - 1; i > 0; i-- ) page.removeChild( children[i] );"];
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

- (void)resizeContentHeight
{
	CGRect frame = self.webView.frame;
	frame.size.height = [[self.webView stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue];
	if( frame.size.height < 330 ) frame.size.height = 330;
	self.webView.frame = frame;
	_scrollView.contentSize = CGSizeMake( 320, self.webView.frame.size.height + 38 );
}

@end
