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
#import "FeedMarker.h"

@implementation MapViewController

@synthesize feedObjects;

- (id)init
{
	if( self = [super init] )
	{
		UIBarButtonItem *gpsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onGPSButtonTouch)];
		self.navigationItem.leftBarButtonItem = gpsButton;
		
		UIBarButtonItem *listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onListButtonTouch)];
		self.navigationItem.rightBarButtonItem = listButton;
		
		feedMapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		feedMapView.delegate = self;
		[self.view addSubview:feedMapView];
		
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
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
	
	[locationManager startUpdatingLocation];
	[feedMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	
	[locationManager stopUpdatingLocation];
	[feedMapView setUserTrackingMode:MKUserTrackingModeNone];
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

#pragma mark - map

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
	NSLog( @"mode changed : %d", mode );
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if( annotation == feedMapView.userLocation )
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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
	[feedMapView setUserTrackingMode:MKUserTrackingModeNone];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	FeedMarker *marker = (FeedMarker *)view.annotation;
	FeedDetailViewController *detail = [[FeedDetailViewController alloc] init];
	detail.feedObject = [feedObjects objectForKey:[NSNumber numberWithInt:marker.feedId]];
	
	[self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog( @"update" );
//	mapView.region = 
//	mapView.userLocation = newLocation;// MKCoordinateRegionMakeWithDistance( newLocation.coordinate, 100, 100 );
//	mapView 
	
#warning temp code
	// 랜덤하게 어노테이션 찍어줌
	if( arc4random() % 100 < 10 )
	{
		FeedMarker *marker = [[FeedMarker alloc] init];
		marker.feedId = 1;
		marker.title = @"Title";
		marker.subtitle = @"Subtitle";
		marker.coordinate = feedMapView.userLocation.coordinate;
		[feedMapView addAnnotation:marker];
	}
}

#pragma mark - selectors

- (void)onGPSButtonTouch
{
	[feedMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)onListButtonTouch
{
	[self.navigationController popViewControllerAnimated:NO];
}

@end
