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

@interface MapViewController (Private)

- (void)deselectAlignButtons;

@end


@implementation MapViewController

@synthesize feedObjects;

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
		[gpsButton setFrame:CGRectMake( 0.0f, 0.0f, 50.0f, 31.0f )];
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
		[listButton setFrame:CGRectMake( 0.0f, 0.0f, 50.0, 31.0f )];
		[listButton addTarget:self action:@selector(onListButtonTouch) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
		listBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItems = [[NSArray alloc] initWithObjects:rightSpacer, listBarButtonItem, nil];		
		
		
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
			break;
			
		// popular
		case 1:
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

@end
