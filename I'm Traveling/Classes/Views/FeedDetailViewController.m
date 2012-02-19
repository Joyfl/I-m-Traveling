//
//  FeedDetailView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "FeedDetailWebView.h"
#import "FeedObject.h"
#import "Const.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>
#import "FeedLineAnnotation.h"
#import "FeedLineAnnotationView.h"

@interface FeedDetailViewController (Private)

- (void)loadFeedDetail;
- (void)loadFeedDetailIndex:(NSInteger)index;
- (void)loadFeedDetailFromLoadingQueue;

- (void)animateAppearance;
- (void)animateDisappearance;

- (void)removeUpperAndLowerImages;

- (void)handleAllFeeds:(NSArray *)allFeeds currentFeedId:(NSInteger)currentFeedId;

- (void)addFeedIndexToLoadingQueue:(NSInteger)index;
- (void)removeLoadedFeedFromLoadingQueue;

@property (retain, readonly) FeedDetailWebView *leftWebView;
@property (retain, readonly) FeedDetailWebView *centerWebView;
@property (retain, readonly) FeedDetailWebView *rightWebView;

@end


@implementation FeedDetailViewController

@synthesize type, mapView=_mapView, loaded, originalRegion;

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
		
		_leftFeedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_leftFeedButton.frame = CGRectMake( 10, 10, 30, 80 );
		_leftFeedButton.alpha = 0.7;
		[_leftFeedButton addTarget:self action:@selector(leftFeedButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		_rightFeedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_rightFeedButton.frame = CGRectMake( 280, 10, 30, 80 );
		_rightFeedButton.alpha = 0.7;
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
		
		_loadingQueue = [[NSMutableArray alloc] init];
		
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
	
	NSLog( @"%f", self.leftWebView.frame.origin.x );
	NSLog( @"%f", self.centerWebView.frame.origin.x );
	NSLog( @"%f", self.rightWebView.frame.origin.x );
	
	[self loadFeedDetail];
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
	
	// 현재 피드의 region으로 애니메이션 (type = 0일 경우에는 애니메이션 안함)
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( _feedObjectFromPrevView.latitude, _feedObjectFromPrevView.longitude ), 200, 200 ) animated:type ? YES : NO];
	
	// Animation 적용 (type 1의 애니메이션은 loadDidFinish에서)
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

- (void)loadFeedDetail
{
	[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, _feedObjectFromPrevView.feedId, type]];
}

// 직접 호출하지는 않음
- (void)loadFeedDetailIndex:(NSInteger)index
{
	FeedObject *feedObject = (FeedObject *)[_feedDetailObjects objectAtIndex:index];
	
//	NSLog( @"req : %@", [NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, feedObject.feedId, 2] );
	// 이미 로드가 완료된 것을 한번 더 로드하는 것 방지
	if( !feedObject.complete )
		[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, feedObject.feedId, 1]];
}

- (void)loadFeedDetailFromLoadingQueue
{
	if( _loadingQueue.count > 0 )
	{
		[self loadFeedDetailIndex:[[_loadingQueue objectAtIndex:0] integerValue]];
	}
}

- (void)didFinishLoading:(NSString *)result
{	
	NSDictionary *feed = [Utils parseJSON:result];
	
	FeedObject *feedObject = _feedObjectFromPrevView ? _feedObjectFromPrevView : [_feedDetailObjects objectAtIndex:[[_loadingQueue objectAtIndex:0] integerValue]];
	
	// type이 0, 1, 2일 경우에 공통적으로 해당
	feedObject.tripId = [[feed objectForKey:@"trip_id"] integerValue];
	feedObject.review = [feed objectForKey:@"review"];
	
	// type이 1, 2일 경우에 공통적으로 해당
	if( !feedObject.userId ) feedObject.userId = [[feed objectForKey:@"user_id"] integerValue];
	if( !feedObject.region ) feedObject.region = [feed objectForKey:@"region"];
	if( !feedObject.time ) feedObject.time = [feed objectForKey:@"time"];
	if( !feedObject.numLikes ) feedObject.numLikes = [[feed objectForKey:@"num_likes"] integerValue];
	if( !feedObject.numComments ) feedObject.numComments = [[feed objectForKey:@"num_comments"] integerValue];
	if( !feedObject.pictureURL ) feedObject.pictureURL = [NSString stringWithFormat:@"%@%d_%d.jpg", API_FEED_IMAGE, feedObject.userId, feedObject.feedId];
	if( !feedObject.profileImageURL ) feedObject.profileImageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, feedObject.userId];
	
	// type이 2일 경우에만 해당
	if( !feedObject.place ) feedObject.place = [feed objectForKey:@"place"];
	
	// 모든 정보가 채워짐
	feedObject.complete = YES;
	
	// 첫 로딩
	if( _feedObjectFromPrevView )
	{
		// UI 수정은 Main Thread에서, Detail에서 다른 Detail을 로드할 경우는 modifyFeedDetail 사용
		[self.centerWebView clear];
		self.centerWebView.feedObject = feedObject;
		[self.centerWebView performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
		[self handleAllFeeds:[feed objectForKey:@"all_feeds"] currentFeedId:feedObject.feedId];
		
		[self addFeedIndexToLoadingQueue:_currentFeedIndex - 1];
		[self addFeedIndexToLoadingQueue:_currentFeedIndex + 1];
		
		_feedObjectFromPrevView = nil; // 첫 로딩이라는 것을 알려주는 지표 제거
	}
	else
	{
		NSInteger webViewIndex = 1;
		
		if( [[_loadingQueue objectAtIndex:0] integerValue] < _currentFeedIndex )
			webViewIndex = 0;
		else if( _currentFeedIndex < [[_loadingQueue objectAtIndex:0] integerValue] )
			webViewIndex = 2;
		
		NSLog( @"webViewIndex : %d", webViewIndex );
		[[_webViews objectAtIndex:webViewIndex] clear];
		[[_webViews objectAtIndex:webViewIndex] setFeedObject:feedObject];
		[[_webViews objectAtIndex:webViewIndex] performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
		
		[self removeLoadedFeedFromLoadingQueue];
	}
	
	[self loadFeedDetailFromLoadingQueue];
}

- (void)handleAllFeeds:(NSArray *)allFeeds currentFeedId:(NSInteger)currentFeedId
{
	NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:allFeeds.count]; // 모든 피드들의 위치. 지도에 선 그릴 때 필요
	
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
		}
		else
		{
			// 현재 피드의 어노테이션은 viewDidAppear에서 이미 찍음
			[_mapView addAnnotation:feedObj];
		}
		
		[_feedDetailObjects addObject:feedObj];
		
		// 라인 어노테이션을 찍기 위해 location 정보만 입력받음
		[locations addObject:[[[CLLocation alloc] initWithLatitude:feedObj.latitude longitude:feedObj.longitude] autorelease]];
	}
	
	// 라인 어노테이션
	FeedLineAnnotation *lineAnnotation = [[FeedLineAnnotation alloc] initWithLocations:locations mapView:_mapView];
	[_mapView addAnnotation:lineAnnotation];
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
	float buttonY = frame.origin.y + 330;
	
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
	if( [annotation isKindOfClass:[FeedLineAnnotation class]] )
	{
		FeedLineAnnotationView *lineAnnotationView = [[FeedLineAnnotationView alloc] initWithAnnotation:annotation mapView:_mapView];
		return lineAnnotationView;
	}
	
	static NSString *pinId = @"pin";
	MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	return pin;
}


#pragma mark -
#pragma mark Animations

- (void)setOriginalRegion:(MKCoordinateRegion)region
{
	_mapView.region = originalRegion = region;
}

- (void)animateAppearance
{
	if( self.type == 0 )
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
	else if( self.type == 1 )
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
	
	if( type == 0 )
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
	else if( type == 1 )
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
	if( type == 0 )
	{
		[_upperImageView removeFromSuperview];
		[_lowerImageView removeFromSuperview];
	}
	else if( type == 1 )
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
		
		self.leftWebView.frame = CGRectMake( -320, 100, 320, self.leftWebView.frame.size.height );
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
		
		self.rightWebView.frame = CGRectMake( 320, 100, 320, self.rightWebView.frame.size.height );
	}
}

- (void)currentFeedDidChange:(NSUInteger)oldIndex newIndex:(NSUInteger)newIndex
{
	[_webViews exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
}

- (void)backButtonDidTouchUpInside
{
	[self animateDisappearance];
	
	// 선 제거
	for( id<MKAnnotation> annotation in _mapView.annotations )
	{
		if( [annotation isKindOfClass:[FeedLineAnnotation class]] )
			[_mapView removeAnnotation:annotation];
	}
}

- (void)resizeContentHeight:(FeedDetailWebView *)webView
{
	float height = [[webView stringByEvaluatingJavaScriptFromString:@"getHeight();"] floatValue] - 21;
	CGRect frame = webView.frame;
	frame.size.height = height;
	webView.frame = frame;
	_scrollView.contentSize = CGSizeMake( 320, height + 100 );
}

#pragma mark -
#pragma mark From FeedDetailWebView

- (void)feedDetailDidFinishCreating
{
	// WebView 컨텐츠 리사이징
	[self resizeContentHeight:self.centerWebView];
	[self resizeContentHeight:self.leftWebView];
	[self resizeContentHeight:self.rightWebView];
	
	if( type == 0 )
	{
		NSLog( @"detail_finished" );
		if( _animationFinished )
			[self removeUpperAndLowerImages];
		else
			_loadingFinished = YES;
	}
	else if( type == 1 )
	{
		// type이 1일 경우의 애니메이션 (type 0의 애니메이션은 viewDidAppear에서)
		[self performSelectorOnMainThread:@selector(animateAppearance) withObject:nil waitUntilDone:NO];
	}
}

#pragma mark -
#pragma mark LoadingQueue

- (void)addFeedIndexToLoadingQueue:(NSInteger)index
{
	if( 0 <= index && index < _feedDetailObjects.count )
		[_loadingQueue addObject:[NSNumber numberWithInt:index]];
}

- (void)removeLoadedFeedFromLoadingQueue
{
	[_loadingQueue removeObjectAtIndex:0];
}


#pragma mark -
#pragma mark Utils

// 지도 region 옮겨주는거

@end
