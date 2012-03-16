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

@interface ProfileViewController (Private)

- (void)prepareProfile;
- (void)createProfile;
- (void)loadProfile;

@end


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
		
		_webView = [[ProfileWebView alloc] init];
		_webView.frame = CGRectMake( 0, 97, 320, 471 );
		[_scrollView addSubview:_webView];
		
		userObject = [[UserObject alloc] init];
		userObject.userId = 2;
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
	if( !created )
	{
		[_webView clear];
		[self prepareProfile];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Profile

- (void)prepareProfile
{
	if( userObject.complete )
	{
		[self createProfile];
	}
	else
	{
		[self loadProfile];
	}
	
	created = YES;
}

- (void)createProfile
{
	[_webView createProfile:userObject];
	self.navigationItem.title = userObject.name;
}

- (void)loadProfile
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_PROFILE, 2]];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *user = [Utils parseJSON:result];
	
	userObject.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, userObject.userId];
	userObject.name = [user objectForKey:@"name"];
	userObject.nation = [user objectForKey:@"nation"];
	userObject.numFeeds = [[user objectForKey:@"num_feeds"] integerValue];
	userObject.numTrips = [[user objectForKey:@"num_trips"] integerValue];
	userObject.numFollowers = [[user objectForKey:@"num_followers"] integerValue];
	userObject.numFollowings = [[user objectForKey:@"num_followings"] integerValue];
	userObject.complete = YES;
	
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

@end
