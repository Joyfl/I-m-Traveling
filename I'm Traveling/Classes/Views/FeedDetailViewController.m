//
//  FeedDetailView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedObject.h"
#import "Const.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>

@interface FeedDetailViewController (Private)

- (void)preloadFeedDetail;
- (void)prepareFeedDetailWithIndex:(NSInteger)index;
- (void)createFeedDetail:(FeedObject *)feedObject atIndex:(NSInteger)index;
- (void)loadFeedDetailFromLoadingQueue;

- (void)animateAppearance;
- (void)animateDisappearance;

- (void)removeUpperAndLowerImages;

- (void)completeFeedObject:(FeedObject *)feedObject fromDictionary:(NSDictionary *)feed;
- (void)handleAllFeeds:(NSArray *)allFeeds currentFeedId:(NSInteger)currentFeedId;

- (void)resizeWebViewHeight:(FeedDetailWebView *)webView;
- (void)resizeContentHeight;

@property (retain, readonly) FeedDetailWebView *leftWebView;
@property (retain, readonly) FeedDetailWebView *centerWebView;
@property (retain, readonly) FeedDetailWebView *rightWebView;

@end


@implementation FeedDetailViewController

@synthesize ref, mapView=_mapView, loaded, originalRegion;

#define MAP_HEIGHT	736
#define MAP_Y		-0.5 * ( MAP_HEIGHT - 100 )

+ (FeedDetailViewController *)viewController
{
	static FeedDetailViewController *_detailViewController;
	
	if( _detailViewController == nil )
	{
		_detailViewController = [[FeedDetailViewController alloc] init];
	}
	
	return _detailViewController;
}

- (id)init
{
    if( self = [super init] )
	{
		// Navigation Bar
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"button_back.png"] retain] forState:UIControlStateNormal];
		[backButton setFrame:CGRectMake( 0.0f, 0.0f, 50.0f, 31.0f )];
		[backButton addTarget:self action:@selector(backButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		backBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, backBarButtonItem, nil];
		
		
		// Map View
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, MAP_Y, 320, MAP_HEIGHT )];
		_mapView.delegate = self;
		_mapView.scrollEnabled = NO;
		_mapView.zoomEnabled = NO;
		[self.view addSubview:_mapView];
		
		// Scroll View
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		_scrollView.delegate = self;
		[self.view addSubview:_scrollView];		
		
		_leftFeedButton = [[UIButton alloc] initWithFrame:CGRectMake( 10, 33, 22, 34 )];
		_leftFeedButton.alpha = 0.7;
		[_leftFeedButton setBackgroundImage:[UIImage imageNamed:@"button_left.png"] forState:UIControlStateNormal];
		[_leftFeedButton addTarget:self action:@selector(leftFeedButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		_rightFeedButton = [[UIButton alloc] initWithFrame:CGRectMake( 288, 33, 22, 34 )];
		_rightFeedButton.alpha = 0.7;
		[_rightFeedButton setBackgroundImage:[UIImage imageNamed:@"button_right.png"] forState:UIControlStateNormal];
		[_rightFeedButton addTarget:self action:@selector(rightFeedButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		[self.view addSubview:_leftFeedButton];
		[self.view addSubview:_rightFeedButton];
		
		
		// WebViews
		_webViews = [[NSMutableArray alloc] init];
		
		for( int i = 0; i < 3; i++ )
		{
			FeedDetailWebView *detailWebView = [[FeedDetailWebView alloc] initWithFeedDetailViewController:self];
			detailWebView.frame = CGRectMake( i * 320 - 320, 100, 320, detailWebView.frame.size.height );
			[_webViews addObject:detailWebView];
		}
		
		_loadingQueue = [[LoadingQueue alloc] init];
		
		_feedDetailObjects = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (void)activateWithFeedObject:(FeedObject *)feedObject
{
	self.loaded = _animationFinished = _loadingFinished = NO;
	
	_feedObjectFromPrevView = feedObject;
	
	// 현재 피드의 어노테이션은 미리 찍어둠
	[_mapView addAnnotation:_feedObjectFromPrevView];
	
	self.navigationItem.title = _feedObjectFromPrevView.place;
	
	[_feedDetailObjects removeAllObjects];
	[_loadingQueue removeAllObjects];
	
	for( int i = 0; i < 3; i++ )
	{
		[[_webViews objectAtIndex:i] clear];
	}
	
	[self preloadFeedDetail];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	if( loaded ) return;
	
	// 현재 피드의 region으로 애니메이션 (ref = 0일 경우에는 애니메이션 안함)
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( _feedObjectFromPrevView.latitude, _feedObjectFromPrevView.longitude ), 200, 200 ) animated:ref ? YES : NO];
	
	// Animation 적용 (ref 1의 애니메이션은 loadDidFinish에서)
	[self animateAppearance];
	
	loaded = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Loading

- (void)preloadFeedDetail
{
	[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&ref=%d", API_FEED_DETAIL, _feedObjectFromPrevView.feedId, ref]];
}

- (void)prepareFeedDetailWithIndex:(NSInteger)index
{
	if( 0 <= index && index < _feedDetailObjects.count )
	{
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:index];
		
		if( feedObject.complete )
		{
			[self createFeedDetail:feedObject atIndex:index];
		}
		else
		{
			[_loadingQueue addFeedIndex:index];
			[self loadFeedDetailFromLoadingQueue];
		}
	}
}

- (void)createFeedDetail:(FeedObject *)feedObject atIndex:(NSInteger)index
{
	if( index < _currentFeedIndex )
	{
		[self.leftWebView createFeedDetail:feedObject];
	}
	else if( _currentFeedIndex < index )
	{
		[self.rightWebView createFeedDetail:feedObject];
	}
	else
	{
		[self.centerWebView createFeedDetail:feedObject];
	}
}

- (void)loadFeedDetailFromLoadingQueue
{
	if( _loadingQueue.count > 0 )
	{
		[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&ref=2", API_FEED_DETAIL, [[_feedDetailObjects objectAtIndex:_loadingQueue.firstIndex] feedId]]];
	}
}

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *feed = [Utils parseJSON:result];
	if( [feed objectForKey:@"ERROR"] )
	{
		NSLog( @"ERROR! : %@", [feed objectForKey:@"ERROR"] );
		return;
	}
	
	FeedObject *feedObject = _feedObjectFromPrevView ? _feedObjectFromPrevView : [_feedDetailObjects objectAtIndex:_loadingQueue.firstIndex];
	[self completeFeedObject:feedObject fromDictionary:feed];
	
	// 첫 로딩
	if( _feedObjectFromPrevView )
	{
		// UI 수정은 Main Thread에서, Detail에서 다른 Detail을 로드할 경우는 modifyFeedDetail 사용
		[self.centerWebView clear];
		[self.centerWebView performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(resizeContentHeight) withObject:nil waitUntilDone:NO];
		[self handleAllFeeds:[feed objectForKey:@"all_feeds"] currentFeedId:feedObject.feedId];
		
		[_feedDetailObjects replaceObjectAtIndex:_currentFeedIndex withObject:feedObject];
		
		[_loadingQueue addFeedIndex:_currentFeedIndex - 1];
		[_loadingQueue addFeedIndex:_currentFeedIndex + 1];
		
		_feedObjectFromPrevView = nil; // 첫 로딩이라는 것을 알려주는 지표 제거
	}
	else
	{
		[_feedDetailObjects replaceObjectAtIndex:_loadingQueue.firstIndex withObject:feedObject];
		
		[self createFeedDetail:feedObject atIndex:_loadingQueue.firstIndex];
		
		[_loadingQueue removeLoadedFeedFromLoadingQueue];
	}
	
	[self loadFeedDetailFromLoadingQueue];
}

- (void)completeFeedObject:(FeedObject *)feedObject fromDictionary:(NSDictionary *)feed
{
	// ref가 0, 1, 2일 경우에 공통적으로 해당
	feedObject.tripId = [[feed objectForKey:@"trip_id"] integerValue];
	feedObject.review = [feed objectForKey:@"review"];
	feedObject.numAllFeeds = [[feed objectForKey:@"all_feeds"] count];
	
	// ref가이 1, 2일 경우에 공통적으로 해당
	if( !feedObject.userId ) feedObject.userId = [[feed objectForKey:@"user_id"] integerValue];
	if( !feedObject.region ) feedObject.region = [feed objectForKey:@"region"];
	if( !feedObject.time ) feedObject.time = [feed objectForKey:@"time"];
	if( !feedObject.numLikes ) feedObject.numLikes = [[feed objectForKey:@"num_likes"] integerValue];
	if( !feedObject.numComments ) feedObject.numComments = [[feed objectForKey:@"num_comments"] integerValue];
	if( !feedObject.pictureURL ) feedObject.pictureURL = [NSString stringWithFormat:@"%@%d_%d.jpg", API_FEED_IMAGE, feedObject.userId, feedObject.feedId];
	if( !feedObject.profileImageURL ) feedObject.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, feedObject.userId];
	
	// ref가 2일 경우에만 해당
	if( !feedObject.name ) feedObject.name = [feed objectForKey:@"name"];
	if( !feedObject.place ) feedObject.place = [feed objectForKey:@"place"];
	
	// 모든 정보가 채워짐
	feedObject.complete = YES;
}

- (void)handleAllFeeds:(NSArray *)allFeeds currentFeedId:(NSInteger)currentFeedId
{
	_loadingQueue.maxIndex = allFeeds.count;
	
	// 모든 피드들의 위치. 지도에 선 그릴 때 필요
	CLLocationCoordinate2D coordinates[allFeeds.count];
	
	for( int i = 0; i < allFeeds.count; i++ )
	{
		NSDictionary *feed = (NSDictionary *)[allFeeds objectAtIndex:i];
		
		FeedObject *feedObj = [[FeedObject alloc] init];
		feedObj.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		feedObj.latitude = [[feed objectForKey:@"latitude"] doubleValue];
		feedObj.longitude = [[feed objectForKey:@"longitude"] doubleValue];
		
		// 현재 피드일 경우
		if( feedObj.feedId == currentFeedId )
		{
			_currentFeedIndex = i;
			NSLog( @"_currentFeedIndex : %d", _currentFeedIndex );
		}
		else
		{
			// 현재 피드의 어노테이션은 viewDidAppear에서 이미 찍음
			[_mapView addAnnotation:feedObj];
		}
		
		[_feedDetailObjects addObject:feedObj];
		
		// 선을 그리기위한 정보
		coordinates[i] = feedObj.coordinate;
	}
	
	MKPolyline *overlay = [MKPolyline polylineWithCoordinates:coordinates count:allFeeds.count];
	[_mapView addOverlay:overlay];
	[overlay release];
}


#pragma mark -
#pragma mark WebViews

- (FeedDetailWebView *)leftWebView
{
	return [_webViews objectAtIndex:0];
}

- (FeedDetailWebView *)centerWebView
{
	return [_webViews objectAtIndex:1];
}

- (FeedDetailWebView *)rightWebView
{
	return [_webViews objectAtIndex:2];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Map
	CGRect frame = _mapView.frame;
	
	if( _scrollView.contentOffset.y > 0 )
		frame.origin.y = MAP_Y - _scrollView.contentOffset.y;
	else
		frame.origin.y = MAP_Y - _scrollView.contentOffset.y / 2;
	
	_mapView.frame = frame;
	
	// Left, Right Button
	float buttonY = frame.origin.y + 351;
	
	frame = _leftFeedButton.frame;
	frame.origin.y = buttonY;
	_leftFeedButton.frame = frame;
	
	frame = _rightFeedButton.frame;
	frame.origin.y = buttonY;
	_rightFeedButton.frame = frame;
}

#pragma mark -
#pragma mark MKMapViewDelegate, CLLocationManagerDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	static NSString *pinId = @"pin";
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	return pin;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if( [overlay isKindOfClass:[MKPolyline class]] )
	{
		MKPolylineView *polygonView = [[MKPolylineView alloc] initWithOverlay:overlay];
		polygonView.lineWidth = 4;
		polygonView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1.0 alpha:0.5];
		return polygonView;
	}
	
	return nil;
}


#pragma mark -
#pragma mark Animations

- (void)setOriginalRegion:(MKCoordinateRegion)region
{
	_mapView.region = originalRegion = region;
}

- (void)animateAppearance
{
	if( self.ref == 0 )
	{
		self.centerWebView.frame = CGRectMake( 0, 100, 320, 367 );
		
		[self performSelector:@selector(animationDidFinish) withObject:nil afterDelay:0.5];
		
		[self.view addSubview:_upperImageView];
		[self.view addSubview:_lowerImageView];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		_upperImageView.frame = CGRectMake( 0, -_upperImageView.frame.size.height, 320, _upperImageView.frame.size.height );
		_lowerImageView.frame = CGRectMake( 0, 100, 320, _lowerImageView.frame.size.height );
		[UIView commitAnimations];
	}
	else if( self.ref == 1 )
	{
		[_scrollView addSubview:self.leftWebView];
		[_scrollView addSubview:self.centerWebView];
		[_scrollView addSubview:self.rightWebView];
		self.centerWebView.frame = CGRectMake( 0, 467, 320, 367 );
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.centerWebView.frame = CGRectMake( 0, 100, 320, 367 );
		[UIView commitAnimations];
	}
}

- (void)animateDisappearance
{
	[self performSelector:@selector(backAnimationDidFinish) withObject:nil afterDelay:0.5];
	
	if( ref == 0 )
	{
		[self.centerWebView removeFromSuperview];
		
		[self.view addSubview:_upperImageView];
		[self.view addSubview:_lowerImageView];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		_upperImageView.frame = CGRectMake( 0, _upperImageViewOriginalY, 320, _upperImageView.frame.size.height );
		_lowerImageView.frame = CGRectMake( 0, _lowerImageViewOriginalY, 320, _lowerImageView.frame.size.height );
		[UIView commitAnimations];
	}
	else if( ref == 1 )
	{
		[_mapView setRegion:originalRegion animated:YES];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.centerWebView.frame = CGRectMake( 0, 367, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
	}
}

- (void)animationDidFinish
{
	if( _loadingFinished )
		[self removeUpperAndLowerImages];
	else
		_animationFinished = YES;
}

- (void)removeUpperAndLowerImages
{
	[_scrollView addSubview:self.leftWebView];
	[_scrollView addSubview:self.centerWebView];
	[_scrollView addSubview:self.rightWebView];
	
	[_upperImageView removeFromSuperview];
	[_lowerImageView removeFromSuperview];
}

- (void)backAnimationDidFinish
{
	if( ref == 0 )
	{
		[_upperImageView removeFromSuperview];
		[_lowerImageView removeFromSuperview];
	}
	else if( ref == 1 )
	{
		[self.centerWebView removeFromSuperview];
	}
	
	[self.navigationController popViewControllerAnimated:NO];
	_scrollView.contentOffset = CGPointZero;
	
	[_mapView removeAnnotations:_mapView.annotations];
}

- (void)setUpperImageView:(UIImageView *)upperImageView lowerImageView:(UIImageView *)lowerImageView lowerImageViewOffset:(float)offset
{
	_upperImageView = upperImageView;
	_lowerImageView = lowerImageView;
	
	_upperImageViewOriginalY = 0;
	_lowerImageViewOriginalY = offset;
	
	_lowerImageView.frame = CGRectMake( 0, offset, 320, _lowerImageView.frame.size.height );
}


#pragma mark -
#pragma mark Touch Selectors

- (void)leftFeedButtonDidTouchUpInside
{
	if( 0 < _currentFeedIndex )
	{
		_currentFeedIndex --;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.3];
		self.leftWebView.frame = CGRectMake( 0, 100, 320, self.leftWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( 320, 100, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude ), 200, 200 ) animated:YES];
		
		[_webViews exchangeObjectAtIndex:1 withObjectAtIndex:0];
		[_webViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
		
		[self resizeContentHeight];
		
		self.leftWebView.frame = CGRectMake( -320, 100, 320, self.leftWebView.frame.size.height );
		
		// 왼쪽 피드 로드
		[self prepareFeedDetailWithIndex:_currentFeedIndex - 1];
	}
}

- (void)rightFeedButtonDidTouchUpInside
{
	if( _currentFeedIndex < _feedDetailObjects.count - 1 )
	{
		_currentFeedIndex ++;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.3];
		self.rightWebView.frame = CGRectMake( 0, 100, 320, self.rightWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( -320, 100, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude ), 200, 200 ) animated:YES];
		
		[_webViews exchangeObjectAtIndex:1 withObjectAtIndex:2];
		[_webViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
		
		[self resizeContentHeight];
		
		self.rightWebView.frame = CGRectMake( 320, 100, 320, self.rightWebView.frame.size.height );
		
		// 오른쪽 피드 로드
		[self prepareFeedDetailWithIndex:_currentFeedIndex + 1];
	}
}

- (void)currentFeedDidChange:(NSUInteger)oldIndex newIndex:(NSUInteger)newIndex
{
	[_webViews exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}

- (void)backButtonDidTouchUpInside
{
	[self animateDisappearance];
	
	[_mapView removeOverlays:_mapView.overlays];
}

#pragma mark -
#pragma mark From FeedDetailWebView

- (void)resizeWebViewHeight:(FeedDetailWebView *)webView
{
	CGRect frame = webView.frame;
	frame.size.height = [[webView stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue];
	webView.frame = frame;
}

- (void)resizeContentHeight
{
	_scrollView.contentSize = CGSizeMake( 320, self.centerWebView.frame.size.height + 97 );
}

- (void)feedDetailDidFinishCreating:(FeedDetailWebView *)webview
{
	// WebView 컨텐츠 리사이징
	[self resizeWebViewHeight:webview];
	
	if( ref == 0 )
	{
		if( _animationFinished )
			[self removeUpperAndLowerImages];
		else
			_loadingFinished = YES;
	}
	else if( ref == 1 )
	{
		// ref가 1일 경우의 애니메이션 (ref 0의 애니메이션은 viewDidAppear에서)
		[self performSelectorOnMainThread:@selector(animateAppearance) withObject:nil waitUntilDone:NO];
	}
}


#pragma mark -
#pragma mark Utils

// 지도 region 옮겨주는거

@end
