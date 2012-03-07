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
#import "TripObject.h"

@interface TripListViewController()

- (void)addTrip:(TripObject *)trip;

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
	
}


#pragma mark -
#pragma mark WebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self loadURL:[NSString stringWithFormat:@"%@?user_id=%d", API_TRIP_LIST, [Utils userId]]];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( message == @"select_trip" )
	{
		NSLog( @"trip_id : %@", [arguments objectAtIndex:0] );
		
		_shareViewController.selectedTrip = [_trips objectForKey:[NSNumber numberWithInteger:[[arguments objectAtIndex:0] integerValue]]];
		[_shareViewController updateTripLabelText];
		
		[self dismissModalViewControllerAnimated:YES];
	}
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(NSString *)result
{
	NSLog( @"result : %@", result );
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
		[self addTrip:trip];
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addTrip:(TripObject *)trip
{
	NSString *func = [NSString stringWithFormat:@"addTrip( '%@', '%@', '%@', '%@', %d );", trip.title, trip.startDate, trip.endDate, trip.summary, trip.numFeeds];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	NSLog( @"%@", func );
}

@end
