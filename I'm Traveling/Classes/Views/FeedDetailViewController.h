//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedImageView.h"
#import "FeedObject.h"
#import <MapKit/MapKit.h>

@interface FeedDetailViewController : UIWebViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
	NSInteger _type; // 0 : From List, 1 : From Map
	FeedObject *_feedObject;
	
	FeedImageView *_feedImageView;
	MKMapView *_feedMapView;
	
	NSMutableDictionary *_feedDetailObjects;
	NSInteger _currentFeedIndex;
}

- (id)initWithFeedObject:(FeedObject *)feedObject type:(NSInteger)type;

@end
