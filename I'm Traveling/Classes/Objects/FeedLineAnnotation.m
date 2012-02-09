//
//  FeedLineAnnotation.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 9..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedLineAnnotation.h"

@implementation FeedLineAnnotation

@synthesize locations = _locations;

- (id)initWithLocations:(NSMutableArray *)locations mapView:(MKMapView *)mapView
{
	if( self = [super init] )
	{
		_locations = [locations retain];
		_mapView = [mapView retain];
	}
	
	return self;
}

- (CLLocationCoordinate2D)coordinate
{
	return _mapView.centerCoordinate;
}

@end
