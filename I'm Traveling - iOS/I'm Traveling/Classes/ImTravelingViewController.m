//
//  ImTravelingViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"
#import "DejalActivityView.h"
#import "Reachability.h"

@implementation ImTravelingViewController

@synthesize loader;

- (id)init
{
	if( self = [super init] )
	{
		loader = [[ImTravelingLoader alloc] init];
		loader.delegate = self;
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange) name:kReachabilityChangedNotification object:nil];
	
	internetReachability = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachability startNotifier];
	[self reachabilityDidChange];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

	 
#pragma mark -
#pragma mark Reachability

 - (void)reachabilityDidChange
{
//	NSLog( @"reachabilityDidChange : %@", self.class );
	NetworkStatus internetStatus = [internetReachability currentReachabilityStatus];
	
	switch( internetStatus )
	{
		case NotReachable:
			networkAvailable = NO;
			break;
			
		case ReachableViaWWAN:
			networkAvailable = YES;
			break;
			
		case ReachableViaWiFi:
			networkAvailable = YES;
			break;
	}
	
	[self networkAvailabilityDidChange:networkAvailable];
}

- (void)networkAvailabilityDidChange:(BOOL)available
{
//	if( available )
//		NSLog( @"network is available. : %@", self.class );
//	else
//		NSLog( @"network is not available. : %@", self.class );
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (BOOL)shouldLoadWithToken:(ImTravelingLoaderToken *)token
{
	return YES;
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSLog( @"loadingDidFinish : Overriding is needed." );
}

- (BOOL)isError:(NSDictionary *)json
{
	return [[json objectForKey:@"status"] integerValue] == 0;
}

- (NSInteger)errorCode:(NSDictionary *)json
{
	return [[json objectForKey:@"result"] integerValue];
}

#pragma mark -
#pragma mark Utils

- (void)startBusy
{
	UIView *view;
	
	if( self.tabBarController )
		view = self.tabBarController.view;
	else
		view = self.view;
	
	[DejalBezelActivityView activityViewForView:view];
}

- (void)stopBusy
{
	[DejalBezelActivityView removeView];
}

- (void)showOopsAlertWithMessage:(NSString *)message
{
	[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:message delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
}

@end
