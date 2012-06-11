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
#import "Utils.h"
#import "Const.h"
#import "Pin.h"

@interface MapViewController (Private)

- (void)deselectAlignButtons;

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
		
		UIButton *gpsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[gpsButton setBackgroundImage:[UIImage imageNamed:@"button_gps.png"] forState:UIControlStateNormal];
		[gpsButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[gpsButton addTarget:self action:@selector(onGPSButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *gpsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:gpsButton];
		gpsBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:leftSpacer, gpsBarButtonItem, nil];
		
		[leftSpacer release];
		[gpsBarButtonItem release];
		
		
		// title		
		UIView *alignButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 226, 31 )];
		
		UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 114, 31 )];
		newButton.tag = kTagAllButton;
		newButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		newButton.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
		newButton.titleEdgeInsets = UIEdgeInsetsMake( 0, 4, 0, 0 );
		[newButton setTitle:NSLocalizedString( @"ALL", @"" ) forState:UIControlStateNormal];
		[newButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_left.png"] forState:UIControlStateNormal];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_left_selected.png"] forState:UIControlStateHighlighted];
		[newButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_left_selected.png"] forState:UIControlStateDisabled];
		[newButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		[alignButtons addSubview:newButton];
		newButton.highlighted = YES;
		newButton.enabled = NO;
		[newButton release];
		
		UIButton *followingButton = [[UIButton alloc] initWithFrame:CGRectMake( 114, 0, 112, 31 )];
		followingButton.tag = kTagFollowingButton;
		followingButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		followingButton.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
		followingButton.titleEdgeInsets = UIEdgeInsetsMake( 0, -4, 0, 0 );
		[followingButton setTitle:NSLocalizedString( @"FOLLOWING", @"" ) forState:UIControlStateNormal];
		[followingButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_right.png"] forState:UIControlStateNormal];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_right_selected.png"] forState:UIControlStateHighlighted];
		[followingButton setBackgroundImage:[UIImage imageNamed:@"button_bar_long_right_selected.png"] forState:UIControlStateDisabled];
		[followingButton addTarget:self action:@selector(onAlignButtonTouch:) forControlEvents:UIControlEventTouchDown];
		[alignButtons addSubview:followingButton];
		[followingButton release];
		
		self.navigationItem.titleView = alignButtons;
		[alignButtons release];
		
		
		// right
		UIBarButtonItem *rightSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		rightSpacer.width = 4;
		
		UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[listButton setBackgroundImage:[UIImage imageNamed:@"button_list.png"] forState:UIControlStateNormal];
		[listButton setFrame:CGRectMake( 0.0f, 0.0f, 28.0f, 28.0f )];
		[listButton addTarget:self action:@selector(onListButtonTouch) forControlEvents:UIControlEventTouchUpInside];
		
		UIBarButtonItem *listBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
		listBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightSpacer, listBarButtonItem, nil];
		
		[rightSpacer release];
		[listBarButtonItem release];
		
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
	NSInteger cellId = [Utils getCellIdWithLatitude:_feedMapView.userLocation.coordinate.latitude longitude:_feedMapView.userLocation.coordinate.longitude];
	[self loadCellId:cellId]; // 가운데
	[self loadCellId:cellId - 1 + 36000]; // 왼쪽 위
	[self loadCellId:cellId + 36000]; // 위
	[self loadCellId:cellId + 1 + 36000]; // 오른쪽 위
	[self loadCellId:cellId + 1]; // 오른쪽
	[self loadCellId:cellId + 1 - 36000]; // 오른쪽 아래
	[self loadCellId:cellId - 36000]; // 아래
	[self loadCellId:cellId - 1 - 36000]; // 왼쪽 아래
	[self loadCellId:cellId - 1]; // 왼쪽
	
	[self.loader startLoading];
}

- (void)loadCellId:(NSInteger)cellId
{
	[self.loader addTokenWithTokenId:0 url:[NSString stringWithFormat:@"%@?order_type=%d&cell_id=%d", API_FEED_MAP, _orderType, cellId] method:ImTravelingLoaderMethodGET params:nil];
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	
	// Error
	if( [self isError:json] )
	{
		NSLog( @"%@", json );
		return;
	}
	
	NSArray *feeds = [json objectForKey:@"result"];
	
	for( NSDictionary *feed in feeds )
	{
		FeedObject *feedObject = [[FeedObject alloc] init];
		feedObject.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		feedObject.place = [feed objectForKey:@"place"];
		feedObject.name = [feed objectForKey:@"name"];
		feedObject.latitude = [[feed objectForKey:@"latitude"] doubleValue];
		feedObject.longitude = [[feed objectForKey:@"longitude"] doubleValue];
		
		BOOL alreadyExists = NO;
		
#warning 이미 존재하는지 검사하는거 발로짬
		for( FeedObject *existAnnotation in _feedMapView.annotations )
		{
			if( existAnnotation.coordinate.latitude == feedObject.latitude
			   && existAnnotation.coordinate.longitude == feedObject.longitude )
			{
				alreadyExists = YES;
				break;
			}
		}
		
		if( !alreadyExists )
			[_feedMapView addAnnotation:feedObject];
		
		[_feedMapObjects setObject:feedObject forKey:[NSNumber numberWithInt:feedObject.feedId]];
		
		[feedObject release];
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
		return nil;
	}
	
	static NSString *pinId;
	Pin *pin = (Pin *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[[Pin alloc] initWithAnnotation:annotation reuseIdentifier:pinId] autorelease];
	}
	
	pin.userInteractionEnabled = YES;
	pin.canShowCallout = YES;
	
	UIButton *feedButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
	pin.rightCalloutAccessoryView = feedButton;
	[feedButton release];
	
	return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	[self startBusy];
	
	FeedObject *feedObj = (FeedObject *)view.annotation;
	FeedDetailViewController *detailViewController = [[FeedDetailViewController alloc] initFromMapWithFeed:feedObj originalRegion:_feedMapView.region];
	
	[self.navigationController pushViewController:detailViewController animated:NO];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog( @"update" );
	
	NSInteger newCellId = [Utils getCellIdWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
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

@end
