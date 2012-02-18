//
//  MapView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 30..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "MapViewController.h"
#import "FeedDetailViewController.h"
#import "FeedObject.h"
#import "FeedAnnotation.h"
#import "Utils.h"
#import "Const.h"

@interface MapViewController (Private)

- (void)deselectAlignButtons;
- (NSInteger)getCellIdWithLatitude:(double)latitude longitude:(double)longitude;

@end


@implementation MapViewController

enum {
	kTagAllButton = 0,
	kTagFollowingButton = 1
};

- (id)init
{
	if( self = [super init] )
	{
		// left
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *gpsButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[gpsButton setBackgroundImage:[[UIImage imageNamed:@"button_gps.png"] retain] forState:UIControlStateNormal];
		[gpsButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[gpsButton addTarget:self action:@selector(onGPSButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *gpsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gpsButton];
		gpsBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, gpsBarButtonItem, nil];
		
		
		// title
		UIView *alignButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 150.0, 31.0 )];
		
		UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 75.0, 31.0 )];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new.png"] retain] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateHighlighted];
		[newButton setBackgroundImage:[[UIImage imageNamed:@"button_new_selected.png"] retain] forState:UIControlStateDisabled];
		[newButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		newButton.tag = kTagAllButton;
		[alignButtons addSubview:newButton];
		[newButton sendActionsForControlEvents:UIControlEventTouchDown];
		
		UIButton *followingButton = [[UIButton alloc] initWithFrame:CGRectMake( 75, 0, 76.0, 31.0 )];
		[followingButton setImage:[[UIImage imageNamed:@"button_following.png"] retain] forState:UIControlStateNormal];
		[followingButton setImage:[[UIImage imageNamed:@"button_following_selected.png"] retain] forState:UIControlStateHighlighted];
		[followingButton setImage:[[UIImage imageNamed:@"button_following_selected.png"] retain] forState:UIControlStateDisabled];
		[followingButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		followingButton.tag = kTagFollowingButton;
		[alignButtons addSubview:followingButton];
		
		self.navigationItem.titleView = alignButtons;
		
		
		// right
		UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		rightSpacer.width = 4;
		
		UIButton *listButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[listButton setBackgroundImage:[[UIImage imageNamed:@"button_list.png"] retain] forState:UIControlStateNormal];
		[listButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[listButton addTarget:self action:@selector(onListButtonTouch) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
		listBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightSpacer, listBarButtonItem, nil];		
		
		_feedMapObjects = [[NSMutableDictionary alloc] init];
		
		_feedMapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		_feedMapView.delegate = self;
		[self.view addSubview:_feedMapView];
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		
//		NSLog( @"cellId : %d", [self getCellIdWithLatitude:37.5655 longitude:126.938] );
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[_locationManager startUpdatingLocation];
	[_feedMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[_locationManager stopUpdatingLocation];
	[_feedMapView setUserTrackingMode:MKUserTrackingModeNone];
}

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

#pragma mark - Network

- (void)loadFeeds
{
	NSString *json = [Utils getHtmlFromUrl:[NSString stringWithFormat:@"%@?order_type=%d&latitude=%lf&longitude=%lf", API_FEED_MAP, _orderType, _feedMapView.userLocation.coordinate.latitude, _feedMapView.userLocation.coordinate.longitude]];
	NSLog( @"%@", [NSString stringWithFormat:@"%@?order_type=%d&latitude=%lf&longitude=%lf", API_FEED_MAP, _orderType, _feedMapView.userLocation.coordinate.latitude, _feedMapView.userLocation.coordinate.longitude] );
	if( [json hasPrefix:@"{"] )
	{
		NSLog( @"%@", json );
		return;
	}
	
	NSArray *feeds = [Utils parseJSON:json];
	
	for( NSDictionary *feed in feeds )
	{
		FeedObject *feedObject = [[FeedObject alloc] init];
		FeedAnnotation *annotation = [[FeedAnnotation alloc] init];
		
		feedObject.feedId = annotation.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		feedObject.place = annotation.title = [feed objectForKey:@"place"];
		feedObject.name = annotation.subtitle = [feed objectForKey:@"name"];
		feedObject.latitude = [[feed objectForKey:@"latitude"] doubleValue];
		feedObject.longitude = [[feed objectForKey:@"longitude"] doubleValue];
		annotation.coordinate = CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude );
		
		BOOL alreadyExists = NO;
		
#warning 이미 존재하는지 검사하는거 발로짬
		for( FeedAnnotation *existAnnotation in _feedMapView.annotations )
		{
			if( existAnnotation.coordinate.latitude == annotation.coordinate.latitude
			 && existAnnotation.coordinate.longitude == annotation.coordinate.longitude )
			{
				alreadyExists = YES;
				break;
			}
		}
		
		if( !alreadyExists )
			[_feedMapView addAnnotation:annotation];
		
		[_feedMapObjects setObject:feedObject forKey:[NSNumber numberWithInt:feedObject.feedId]];
	}
}

#pragma mark - map

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
	NSLog( @"mode changed : %d", mode );
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if( annotation == _feedMapView.userLocation )
	{
		mapView.userLocation.title = @"Current Location";
		return nil;
	}
	
	static NSString *pinId;
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	pin.animatesDrop = YES;
	pin.userInteractionEnabled = YES;
	pin.canShowCallout = YES;
	
	UIButton *feedButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
	pin.rightCalloutAccessoryView = feedButton;
	
	return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	FeedAnnotation *annotation = (FeedAnnotation *)view.annotation;
	FeedDetailViewController *detailViewController = [FeedDetailViewController viewController];
	detailViewController.feedObject = [_feedMapObjects objectForKey:[NSNumber numberWithInt:annotation.feedId]];
	detailViewController.type = 1;
	detailViewController.loaded = NO;
	
	CGRect rect = [_feedMapView convertRegion:_feedMapView.region toRectToView:self.view];
	rect.origin.y -= ( _feedMapView.frame.size.height - 100 ) * 0.5;
	detailViewController.originalRegion = [_feedMapView convertRect:rect toRegionFromView:self.view];
	
	[self.navigationController pushViewController:detailViewController animated:NO];
	[detailViewController startLoadingFeedDetail];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog( @"update" );
	
	NSInteger newCellId = [self getCellIdWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
	NSLog( @"currentCellId : %d", _currentCellId );
	NSLog( @"newCellId     : %d", newCellId );
	if( _currentCellId != newCellId && _feedMapView.userLocation.coordinate.latitude != 0.0 && _feedMapView.userLocation.coordinate.longitude != 0.0 )
	{
		[self loadFeeds];
		_currentCellId = newCellId;
	}
}

#pragma mark - selectors

- (void)onGPSButtonTouch
{
	[_feedMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)onAlignButtonTouch:(id)sender
{
	[self deselectAlignButtons];
	
	UIButton *button = (UIButton *)sender;
	button.highlighted = YES;
	button.enabled = NO;
	
	switch( button.tag )
	{
		// new
		case 0:
			_orderType = 0;
			break;
			
		// popular
		case 1:
			_orderType = 1;
			break;
	}
}

- (void)onListButtonTouch
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
	[self.navigationController popViewControllerAnimated:NO];
	[UIView commitAnimations];
}


#pragma mark - utils

- (void)deselectAlignButtons
{
	for( int i = 0; i < 2; i++ )
	{
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).highlighted = NO;
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).enabled = YES;
	}
}

- (NSInteger)getCellIdWithLatitude:(double)latitude longitude:(double)longitude
{
	return ABS( round( ( latitude + 90 ) * 100 ) / 100 ) * 100 * 36000 + ABS( round( ( longitude + 180 ) * 100 ) / 100 ) * 100;
//	((ABS(ROUND(경도 + 90,2)) * 100) * 36000) + ((ABS(ROUND(위도 + 180,2)) * 100));
}

@end
