//
//  FeedDetailView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedObject.h"
#import "Const.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>
#import "FeedMarker.h"

@interface FeedDetailViewController (Private)

- (void)createFeedDetail:(FeedObject *)feedObj;
- (void)modifyFeedDetail:(FeedObject *)feedObj;

@end


@implementation FeedDetailViewController

@synthesize feedObject;

- (id)init
{
    if( self = [super init] )
	{
		feedImageView = [[FeedImageView alloc] init];
		[self.webView.scrollView addSubview:feedImageView.view];
		
		self.webView.scrollView.showsVerticalScrollIndicator = NO;
		
		feedMapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 267, 320, 100 )];
		feedMapView.delegate = self;
		feedMapView.scrollEnabled = NO;
		feedMapView.zoomEnabled = NO;
		[self.view addSubview:feedMapView];
		
		[self loadURL:HTML_INDEX];
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

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self reloadWebView];
}

- (void)reloadWebView
{
	[self clear];
	
	NSString *json = [Utils getHtmlFromUrl:[NSString stringWithFormat:@"%@?feed_id=%d", API_FEED_DETAIL, feedObject.feedId]];
	NSDictionary *feed = [Utils parseJSON:json];
	
	feedObject.tripId = [[feed objectForKey:@"trip_id"] integerValue];
	feedObject.latitude = 37.242; //[[feed objectForKey:@"latitude"] doubleValue];
	feedObject.longitude = 131.861; //[[feed objectForKey:@"longitude"] doubleValue];
	[self createFeedDetail:feedObject];
	
	feedMapView.region = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude ), 2000, 2000 );
	
	feedObjectsOfTrip = [feed objectForKey:@"all_feeds"];
	for( int i = 0; i < feedObjectsOfTrip.count; i++ )
	{
		if( [[feedObjectsOfTrip objectAtIndex:i] integerValue] == feedObject.feedId )
		{
			currentFeedIndex = i;
			
			FeedMarker *marker = [[FeedMarker alloc] init];
			marker.feedId = feedObject.feedId;
			marker.title = @"a";
			marker.subtitle = @"b";
			marker.coordinate = CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude );
			[feedMapView addAnnotation:marker];
			
			break;
		}
	}
	
	[feedImageView loadFeedImage:currentFeedIndex url:feedObject.pictureURL];
}

#pragma mark - Javascript Function

- (void)createFeedDetail:(FeedObject *)feedObj
{
	NSString *func = [[NSString stringWithFormat:@"createFeedDetail(%d, %d, %d, '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   feedObj.tripId,
					   feedObj.feedId,
					   feedObj.userId,
					   feedObj.profileImageURL,
					   feedObj.name,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.review,
					   feedObj.numLikes,
					   feedObj.numComments] retain];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
	NSLog( @"%@", func );
}

- (void)modifyFeedDetail:(FeedObject *)feedObj
{
	NSString *func = [[NSString stringWithFormat:@"modifyFeedDetail(%d, %d, '%@', '%@', '%@', '%@', %d)",
					   feedObj.feedId,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.review,
					   feedObj.numLikes,
					   feedObj.numComments] retain];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
	NSLog( @"%@", func );
}

# pragma mark - Map

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	static NSString *pinId = @"pin";
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	return pin;
}

@end
