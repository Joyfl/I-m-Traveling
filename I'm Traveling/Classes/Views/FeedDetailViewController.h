//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import "FeedImageView.h"
#import "FeedObject.h"
#import <MapKit/MapKit.h>

@interface FeedDetailViewController : UIPullDownWebViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
	NSInteger type; // 0 : From List, 1 : From Map
	FeedObject *feedObject;
	
	FeedImageView *feedImageView;
	MKMapView *feedMapView;
	
	NSMutableArray *feedObjectsOfTrip;
	NSInteger currentFeedIndex;
}

@property (nonatomic, retain) FeedObject *feedObject;
@property (nonatomic, assign) NSInteger type;

@end
