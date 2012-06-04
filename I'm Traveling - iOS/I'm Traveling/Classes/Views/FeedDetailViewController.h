//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedDetailWebView.h"
#import "FeedObject.h"
#import <MapKit/MapKit.h>
#import "ImTravelingBarButtonItem.h"

@interface FeedDetailViewController : ImTravelingViewController <UIScrollViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
{
	// 0 : From List
	// 1 : From Map
	// 2 : From Simple Feed List
	NSInteger ref;
	
	FeedObject *_feedObjectFromPrevView; // List 또는 Map에서 넘어온 FeedObject
	
	UIScrollView *_scrollView;
	MKMapView *_mapView;
	NSMutableArray *_webViews;
	ImTravelingBarButtonItem *_likeButton;
	UIButton *_titleButton;
	
	NSMutableArray *_feedDetailObjects;
	NSInteger _currentFeedIndex;
	
	NSInteger _numAllFeeds;
	
	// List 애니메이션용 이미지뷰
	UIImageView *_upperImageView;
	UIImageView *_lowerImageView;
	CGFloat _upperImageViewOriginalY;
	CGFloat _lowerImageViewOriginalY;
	
	// ref = 1일 경우 back버튼을 눌러 맵으로 돌아갈 때 자연스러운 애니메이션을 위해 필요.
	MKCoordinateRegion _originalRegion;
	
	UIButton *_leftFeedButton;
	UIButton *_rightFeedButton;
	
	UIView *_commentBar;
	UITextField *_commentInput;
	UIButton *_sendButton;
}

- (id)initFromListWithFeed:(FeedObject *)feed upperImage:(UIImage *)upperImage lowerImage:(UIImage *)lowerImage lowerImageViewOffset:(CGFloat)offset;
- (id)initFromMapWithFeed:(FeedObject *)feed originalRegion:(MKCoordinateRegion)originalRegion;
//- (id)initFromSimpleListWithFeedIndex:(NSInteger *)feedIndex;
- (void)seeAllFeeds;
- (void)webViewDidFinishLoad:(FeedDetailWebView *)webView;
- (void)commentDidAdd:(FeedDetailWebView *)webView;

@end
