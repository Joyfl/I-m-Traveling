//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedObject.h"
#import <MapKit/MapKit.h>

@interface FeedDetailViewController : UIWebViewController <UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate>
{
	NSInteger type; // 0 : From List, 1 : From Map
	FeedObject *feedObject;
	
	UIScrollView *_scrollView;
	MKMapView *_mapView;
	
	NSMutableDictionary *_feedDetailObjects;
	
	UIImageView *upperImageView;
	UIImageView *lowerImageView;
	
	BOOL loaded;
	BOOL animationFinished;
	BOOL loadingFinished;
}

+ (FeedDetailViewController *)viewController;

- (void)loadFeedDetail;
- (void)loadFeedDetailAfterDelay:(NSTimeInterval)delay;

@property (nonatomic, retain) FeedObject *feedObject;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UIImageView *upperImageView;
@property (nonatomic, retain) UIImageView *lowerImageView;
@property (nonatomic, assign) BOOL loaded;

@end
