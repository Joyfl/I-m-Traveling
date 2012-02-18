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
	
	UIImageView *_upperImageView;
	UIImageView *_lowerImageView;
	float _upperImageViewOriginalY;
	float _lowerImageViewOriginalY;
	
	BOOL loaded; // 로드된 적이 있는지 (viewDidAppear는 다른 탭으로 전환했다가 다시 돌아와도 호출되기 때문에 중복 로드 방지)
	
	// type = 0일 경우 애니메이션과 로딩이 모두 끝난 후에 upperImageView와 lowerImageView를 제거함
	BOOL animationFinished;
	BOOL loadingFinished;
	
	MKCoordinateRegion originalRegion; // type = 2일 경우 back버튼을 눌러 맵으로 돌아갈 때 자연스러운 애니메이션을 위해 필요.
}

+ (FeedDetailViewController *)viewController;

- (void)startLoadingFeedDetail;
- (void)setUpperImageView:(UIImageView *)upperImageView lowerImageView:(UIImageView *)lowerImageView lowerImageViewOffset:(float)offset;

@property (nonatomic, retain) FeedObject *feedObject;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, assign) BOOL loaded;
@property (nonatomic, assign) MKCoordinateRegion originalRegion;

@end
