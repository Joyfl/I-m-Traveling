//
//  FeedLineAnnotationView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 9..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FeedLineAnnotation.h"

@interface FeedLineAnnotationView : MKAnnotationView
{
	NSMutableArray *_locations;
	MKMapView *_mapView;
}

- (id)initWithAnnotation:(FeedLineAnnotation *)annotation mapView:(MKMapView *)mapView;

@end
