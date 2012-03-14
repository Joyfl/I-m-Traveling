//
//  TripListViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 28..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TripListViewController.h"
#import "ShareViewController.h"
#import "Const.h"
#import "Utils.h"
#import "TripAddViewController.h"
#import "ImTravelingNavigationController.h"

@interface TripListViewController()

- (void)addSimpleTrip:(TripObject *)trip;

@end


@implementation TripListViewController

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = addButton;
		
		_shareViewController = shareViewController;
		
		_trips = [[NSMutableDictionary alloc] init];
		
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Bar Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addButtonDidTouchUpInside
{
	TripAddViewController *tripAddViewController = [[TripAddViewController alloc] init];
	tripAddViewController.tripListViewController = self;
	ImTravelingNavigationController *navigaionController = [[ImTravelingNavigationController alloc] initWithRootViewController:tripAddViewController];
	[self presentModalViewController:navigaionController animated:YES];
}


#pragma mark -
#pragma mark WebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_TRIP_LIST, [Utils userId]]];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"select_trip"] )
	{
		NSLog( @"trip_id : %@", [arguments objectAtIndex:0] );
		
		[self selectTrip:[_trips objectForKey:[NSNumber numberWithInteger:[[arguments objectAtIndex:0] integerValue]]]];
	}
}

- (void)selectTrip:(TripObject *)trip
{
	_shareViewController.selectedTrip = trip;
	[_shareViewController updateTripLabelText];

	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(NSString *)result
{
	[self clear];
	
	NSArray *trips = [Utils parseJSON:result];
	for( NSDictionary *t in trips )
	{
		TripObject *trip = [[TripObject alloc] init];
		trip.tripId = [[t objectForKey:@"trip_id"] integerValue];
		trip.title = [t objectForKey:@"trip_title"];
		trip.startDate = [t objectForKey:@"start_date"];
		trip.endDate = [t objectForKey:@"end_date"];
		trip.summary = [t objectForKey:@"summary"];
		trip.numFeeds = [[t objectForKey:@"num_feeds"] integerValue];
		
		[_trips setObject:trip forKey:[NSNumber numberWithInteger:trip.tripId]];
		[self addSimpleTrip:trip];
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addSimpleTrip:(TripObject *)trip
{
#warning 2번째 인자 (piture url) 임시값
	NSString *func = [NSString stringWithFormat:@"addSimpleTrip( %d, '%@', '%@', '%@', '%@', '%@', %d );", trip.tripId, @"http://imtraveling.joyfl.kr/feed/2_5.jpg", trip.title, trip.startDate, trip.endDate, trip.summary, trip.numFeeds];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	NSLog( @"%@", func );
}

@end
