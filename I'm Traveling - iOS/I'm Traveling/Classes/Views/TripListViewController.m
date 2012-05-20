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
#import "ImTravelingBarButtonItem.h"

@interface TripListViewController()

- (void)addSimpleTrip:(TripObject *)trip;

@end


@implementation TripListViewController

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_TRIP_LIST", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *addButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"NEW_TRIP", @"" ) target:self action:@selector(addButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];
		
		self.webView.frame = CGRectMake( 0, 0, 320, 416 );
		
		_shareViewController = shareViewController;
		
		_trips = [[NSMutableDictionary alloc] init];
		
		[self loadPage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
	// Trip Add 후 dismiss
	if( _tripSelected )
		[self dismissModalViewControllerAnimated:YES];
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
	[tripAddViewController release];
	[navigaionController release];
}


#pragma mark -
#pragma mark WebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.loader loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_TRIP_LIST, [Utils userId]] withData:nil andId:0];
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
	
	_tripSelected = YES;

	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	[self clear];
	
	NSDictionary *json = [Utils parseJSON:token.data];
	
	// trip이 없을 경우
	if( [self isError:json] )
	{
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"NO_TRIPS_MSG", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSArray *trips = [json objectForKey:@"result"];
	
	for( NSDictionary *t in trips )
	{
		TripObject *trip = [[TripObject alloc] init];
		trip.tripId = [[t objectForKey:@"trip_id"] integerValue];
		trip.title = [t objectForKey:@"trip_title"];
		trip.startDate = [t objectForKey:@"start_date"];
		trip.endDate = [t objectForKey:@"end_date"];
		trip.summary = [t objectForKey:@"summary"];
		trip.numFeeds = [[t objectForKey:@"num_feeds"] integerValue];
		trip.firstFeedId = [[t objectForKey:@"firstfeed_id"] integerValue];
		
		[_trips setObject:trip forKey:[NSNumber numberWithInteger:trip.tripId]];
		[self addSimpleTrip:trip];
		[trip release];
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addSimpleTrip:(TripObject *)trip
{
#warning picture url 등록된 여행이 없을 경우 이미지 필요
	NSString *func = [NSString stringWithFormat:@"addSimpleTrip( %d, '%@', '%@', '%@', '%@', '%@', %d );",
					  trip.tripId,
					  [NSString stringWithFormat:@"%@%d_%d.jpg", API_FEED_IMAGE, [Utils userId], trip.firstFeedId],
					  trip.title,
					  trip.startDate,
					  trip.endDate,
					  trip.summary,
					  trip.numFeeds];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	NSLog( @"%@", func );
}

@end
