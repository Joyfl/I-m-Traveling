//
//  FeedLineAnnotation.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 9..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FeedLineAnnotation : NSObject <MKAnnotation>
{
	NSMutableArray *_locations;
	MKMapView *_mapView;
}

@property (nonatomic, retain) NSMutableArray *locations;

- (id)initWithLocations:(NSMutableArray *)locations mapView:(MKMapView *)mapView;

@end
