//
//  MapView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 30..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController

- (id)init
{
	if( self = [super init] )
	{
		UIBarButtonItem *gpsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(onGPSButtonTouch)];
		self.navigationItem.leftBarButtonItem = gpsButton;
		
		mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		[self.view addSubview:mapView];
		
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		
		[locationManager startUpdatingLocation];
		[mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
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

#pragma mark - map



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog( @"update" );
//	mapView.region = 
//	mapView.userLocation` = newLocation;// MKCoordinateRegionMakeWithDistance( newLocation.coordinate, 100, 100 );
//	mapView 
}

#pragma mark - selectors

- (void)onGPSButtonTouch
{
	mapView.userTrackingMode = YES;
}

@end
