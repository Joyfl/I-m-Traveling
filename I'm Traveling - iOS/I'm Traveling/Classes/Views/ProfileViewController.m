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
#import "ImtravelingBarButtonItem.h"
#import "SettingsViewController.h"
#import "FeedDetailViewController.h"
#import "NotificationViewController.h"
#import "Notification.h"

@implementation ProfileViewController

@synthesize activated;

enum {
	kTokenIdProfile = 0,
	kTokenIdTrips = 1,
	kTokenIdFollowing = 2,
	kTokenIdFollowers = 3
};

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor colorWithRed:0.960 green:0.89 blue:0.82 alpha:1.0];
		
		UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 320, 100 )];
		topBackgroundView.backgroundColor = [UIColor darkGrayColor];
		[self.view addSubview:topBackgroundView];
		[topBackgroundView release];
		
		_coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, -85, 320, 320 )];
		[_coverImageView setImage:[UIImage imageNamed:@"cover_temp.jpg"]];
		[self.view addSubview:_coverImageView];
		
		_imageTopBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_image_top_border.png"]];
		_imageTopBorder.hidden = YES;
		[_coverImageView addSubview:_imageTopBorder];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		_scrollView.delegate = self;
		_scrollView.contentSize = CGSizeMake( 320, 368 );
		[self.view addSubview:_scrollView];
		
		self.webView.frame = CGRectMake( 0, 97, 320, 270 );
		self.webView.backgroundColor = [UIColor clearColor];
		self.webView.opaque = NO;
		self.webView.scrollView.scrollEnabled = NO;
		[_scrollView addSubview:self.webView];
		
		_notificationButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		_notificationButton.frame = CGRectMake( 230, 120, 60, 60 );
		[_notificationButton addTarget:self action:@selector(notificationButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_notificationButton];
		
		_arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_arrow.png"]];
		_arrow.frame = CGRectMake( 40, 168, 22, 14 );
		
		user = [[UserObject alloc] init];
		trips = [[NSMutableArray alloc] init];
		followers = [[NSMutableArray alloc] init];
		followings = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)activateFromTabBarWithUserId:(NSInteger)userId userName:(NSString *)name
{
	activated = YES;
	user.userId = userId;
	user.name = name;
	self.navigationItem.title = name;
	
	ImTravelingBarButtonItem *editButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"EDIT", @"" ) target:self action:@selector(editButtonDidTouchUpInside)];
	self.navigationItem.leftBarButtonItem = editButton;
	[editButton release];
	
	ImTravelingBarButtonItem *settingsButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"SETTINGS", @"" ) target:self action:@selector(settingsButtonDidTouchUpInside)];
	self.navigationItem.rightBarButtonItem = settingsButton;
	[settingsButton release];
	
	[self startBusy];
	[self loadPage:HTML_INDEX];
}

- (void)activateWithUserId:(NSInteger)userId userName:(NSString *)name
{
	activated = YES;
	user.userId = userId;
	user.name = name;
	self.navigationItem.title = name;

	ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
	self.navigationItem.leftBarButtonItem = backButton;
	[backButton release];
	
	[self startBusy];
	[self loadPage:HTML_INDEX];
}

- (void)deactivate
{
	activated = NO;
	user.complete = NO;
	
	[trips removeAllObjects];
	[followers removeAllObjects];
	[followings removeAllObjects];
	
	[_arrow removeFromSuperview];
	
	[self.webView stringByEvaluatingJavaScriptFromString:@"clear()"];
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.title = nil;
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
	if( !activated || !user.complete ) return;
	[self loadProfile];
}


#pragma mark -
#pragma mark UIWebViewController

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
	[self loadAll];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"profile_trips"] )
	{
		currentTab = 0;
		[self animateArrow];
		[self clearTabContents];
		[self createTrips];
	}
	else if( [message isEqualToString:@"profile_following"] )
	{
		currentTab = 1;
		[self animateArrow];
		[self clearTabContents];
		[self createFollowings];
	}
	else if( [message isEqualToString:@"profile_followers"] )
	{
		currentTab = 2;
		[self animateArrow];
		[self clearTabContents];
		[self createFollowers];
	}
	else if( [message isEqualToString:@"select_feed"] )
	{
//		FeedDetailViewController *feedDetailViewController = [[FeedDetailViewController alloc] init
	}
	else if( [message isEqualToString:@"create_profile"] )
	{
		ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
		[profileViewController activateWithUserId:[[arguments objectAtIndex:0] integerValue] userName:[Utils decodeURI:[arguments objectAtIndex:1]]];
		[self.navigationController pushViewController:profileViewController animated:YES];
		[profileViewController release];
	}
}


#pragma mark -
#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = YES;
}


#pragma mark -
#pragma mark Load

- (void)loadAll
{
	[self.loader addTokenWithTokenId:kTokenIdProfile url:[NSString stringWithFormat:@"%@?user_id=%d", API_PROFILE, user.userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader addTokenWithTokenId:kTokenIdTrips url:[NSString stringWithFormat:@"%@?user_id=%d", API_TRIP_LIST, user.userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader addTokenWithTokenId:kTokenIdFollowing url:[NSString stringWithFormat:@"%@?command=following_list&src_id=%d", API_FOLLOWING_LIST, user.userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader addTokenWithTokenId:kTokenIdFollowers url:[NSString stringWithFormat:@"%@?command=follower_list&src_id=%d", API_FOLLOWERS_LIST, user.userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader startLoading];
}

- (void)loadProfile
{
	[self.loader addTokenWithTokenId:kTokenIdProfile url:[NSString stringWithFormat:@"%@?user_id=%d", API_PROFILE, user.userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader startLoading];
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
//	NSLog( @"tokenId : %d", token.tokenId );
	
	NSDictionary *json = [Utils parseJSON:token.data];
	NSInteger errorCode = -1;
	
	if( [self isError:json] )
	{
		errorCode = [self errorCode:json];
		NSLog( @"Error : %d", errorCode );
		
		if( errorCode != 1 ) return;
	}
	
	NSDictionary *result = [json objectForKey:@"result"];
	
	switch( token.tokenId )
	{
		case kTokenIdProfile:
		{
			_numNotifications = [[result objectForKey:@"num_notifications"] integerValue];
			NSLog( @"numNotifications : %d", _numNotifications );
			
			if( !user.complete )
			{
				user.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, user.userId];
				user.name = [result objectForKey:@"name"];
				user.nation = [result objectForKey:@"nation"];
				user.numFeeds = [[result objectForKey:@"num_feeds"] integerValue];
				user.numTrips = [[result objectForKey:@"num_trips"] integerValue];
				user.numFollowers = [[result objectForKey:@"num_followers"] integerValue];
				user.numFollowings = [[result objectForKey:@"num_followings"] integerValue];
				user.complete = YES;
				
				[self createProfile];
			}
			else
			{
				[self updateNumNotifications];
			}
			
			break;
		}
			
		case kTokenIdTrips:
		{
			if( errorCode != 1 )
			{
				for( NSDictionary *t in result )
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
			}
			
			[self createTrips];
			break;
		}
			
		case kTokenIdFollowing:
		{
			if( errorCode != 1 )
			{
				for( NSDictionary *u in result )
				{
					UserObject *following = [[UserObject alloc] init];
					following.userId = [[u objectForKey:@"dest_id"] integerValue];
					following.name = [u objectForKey:@"dest_name"];
					following.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, following.userId];
					[followings addObject:following];
					[following release];
				}
			}
			
			break;
		}
			
		case kTokenIdFollowers:
		{
			if( errorCode != 1 )
			{
				for( NSDictionary *u in result )
				{
					UserObject *follower = [[UserObject alloc] init];
					follower.userId = [[u objectForKey:@"src_id"] integerValue];
					follower.name = [u objectForKey:@"src_name"];
					follower.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, follower.userId];
					[followers addObject:follower];
					[follower release];
				}
			}
			
			[self stopBusy];
			
			[self.webView addSubview:_arrow];
			break;
		}
	}
}


#pragma mark -
#pragma mark Create

- (void)createProfile
{
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
					  _numNotifications,
					  0];
	
	[self.webView stringByEvaluatingJavaScriptFromString:func];
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
#pragma mark Update

- (void)updateUserName
{
	
}

- (void)updateNumTrips
{
	
}

- (void)updateNumFollowing
{
	
}

- (void)updateNumFollowers
{
	
}

- (void)updateNumNotifications
{
#warning temp
	[_notificationButton setTitle:[NSString stringWithFormat:@"%d", _numNotifications]  forState:UIControlStateNormal];
	
	NSString *func = [NSString stringWithFormat:@"$('#noticeText').innerText = %d;", _numNotifications];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
}


#pragma mark -
#pragma mark JavaScript Functions

- (void)clearTabContents
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"clearProfileTabContents()"];
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


#pragma mark -
#pragma mark Selectors

- (void)editButtonDidTouchUpInside
{
	
}

- (void)settingsButtonDidTouchUpInside
{
	SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
	[self.navigationController pushViewController:settingsViewController animated:YES];
	[settingsViewController release];
}

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)notificationButtonDidTouchUpInside
{
	NotificationViewController *notificationViewController = [[NotificationViewController alloc] initWithUserId:user.userId];
	[self.navigationController pushViewController:notificationViewController animated:YES];
}


#pragma mark -
#pragma mark Animations

- (void)animateArrow
{
	[UIView setAnimationDuration:0.5];
	[UIView beginAnimations:nil context:nil];
	CGRect frame = _arrow.frame;
	frame.origin.x = 40 + 104 * currentTab;
	_arrow.frame = frame;
	[UIView commitAnimations];
}

@end
