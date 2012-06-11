//
//  MapView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 30..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ImTravelingViewController.h"

@interface MapViewController : ImTravelingViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
	MKMapView *_feedMapView;
	
	NSMutableDictionary *_feedMapObjects;
	
	NSInteger _orderType;
	NSInteger _currentCellId;
}

@end
