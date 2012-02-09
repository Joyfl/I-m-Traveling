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
#import "FeedAnnotation.h"
#import "FeedLineAnnotation.h"
#import "FeedLineAnnotationView.h"

@interface FeedDetailViewController (Private)

- (void)createFeedDetail:(FeedObject *)feedObj;
- (void)modifyFeedDetail:(FeedObject *)feedObj;

@end


@implementation FeedDetailViewController

- (id)initWithFeedObject:(FeedObject *)feedObject type:(NSInteger)type
{
    if( self = [super init] )
	{
		_feedObject = feedObject;
		_type = type;
		
		_feedImageView = [[FeedImageView alloc] init];
		[self.webView.scrollView addSubview:_feedImageView.view];
		
		self.webView.scrollView.showsVerticalScrollIndicator = NO;
		
		_feedMapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 267, 320, 100 )];
		_feedMapView.delegate = self;
		_feedMapView.scrollEnabled = NO;
		_feedMapView.zoomEnabled = NO;
		[self.view addSubview:_feedMapView];
		
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

#pragma mark - setters

- (void)setFeedObject:(FeedObject *)obj
{
	_feedObject = obj;
	self.navigationItem.title = _feedObject.place;
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
	
	NSString *json = [Utils getHtmlFromUrl:[NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, _feedObject.feedId, _type]];
	NSDictionary *feed = [Utils parseJSON:json];
	
	_feedObject.tripId = [[feed objectForKey:@"trip_id"] integerValue];
	_feedObject.latitude = [[feed objectForKey:@"latitude"] doubleValue];
	_feedObject.longitude = [[feed objectForKey:@"longitude"] doubleValue];
	[self createFeedDetail:_feedObject];
	
	_feedMapView.region = MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( _feedObject.latitude, _feedObject.longitude ), 200, 200 );
	
	_feedObjectsOfTrip = [feed objectForKey:@"all_feeds"];
	NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:_feedObjectsOfTrip.count];
	
	for( int i = 0; i < _feedObjectsOfTrip.count; i++ )
	{
		NSDictionary *feed = (NSDictionary *)[_feedObjectsOfTrip objectAtIndex:i];
		FeedAnnotation *annotation = [[FeedAnnotation alloc] init];
		annotation.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		
		double latitude = [[feed objectForKey:@"latitude"] doubleValue];
		double longitude = [[feed objectForKey:@"longitude"] doubleValue];
		annotation.coordinate = CLLocationCoordinate2DMake( latitude, longitude );
		
		[_feedMapView addAnnotation:annotation];
		
		if( annotation.feedId == _feedObject.feedId )
			_currentFeedIndex = i;
		
		[locations addObject:[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease]];
	}
	
	FeedLineAnnotation *lineAnnotation = [[FeedLineAnnotation alloc] initWithLocations:locations mapView:_feedMapView];
	[_feedMapView addAnnotation:lineAnnotation];
	
	[_feedImageView loadFeedImage:_currentFeedIndex url:_feedObject.pictureURL];
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
	if( [annotation isKindOfClass:[FeedLineAnnotation class]] )
	{
		FeedLineAnnotationView *lineAnnotationView = [[FeedLineAnnotationView alloc] initWithAnnotation:annotation mapView:_feedMapView];
		return lineAnnotationView;
	}
	
	static NSString *pinId = @"pin";
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	return pin;
}

@end
