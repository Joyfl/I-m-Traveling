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
#import "FeedLineAnnotation.h"
#import "FeedLineAnnotationView.h"

@interface FeedDetailViewController (Private)

- (void)loadFeedDetailIndex:(NSInteger)index;

- (void)removeUpperAndLowerImages;

- (void)animateAppearance;
- (void)animateDisappearance;

- (void)createFeedDetail:(FeedObject *)feedObj;
- (void)modifyFeedDetail:(FeedObject *)feedObj;

- (void)resizeContentHeight;

@end


@implementation FeedDetailViewController

@synthesize feedObject, type, mapView=_mapView, loaded, originalRegion;

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
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		_scrollView.delegate = self;
		
		self.webView.backgroundColor = [UIColor clearColor];
		self.webView.opaque = NO;
		self.webView.scrollView.scrollEnabled = NO;
		[self.webView removeFromSuperview];

//		self.webView.layer.shadowColor = [UIColor blackColor].CGColor;
//		self.webView.layer.shadowOpacity = 0.7f;
//		self.webView.layer.shadowOffset = CGSizeMake( 0, -4.0f );
//		self.webView.layer.shadowRadius = 5.0f;

		// 그림자 제거
//		for( NSInteger i = 9; i > 5; i-- )
//			[[self.webView.scrollView.subviews objectAtIndex:i] setHidden:YES];
		
		[self loadRemotePage:HTML_INDEX];
		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, MAP_Y, 320, MAP_HEIGHT )];
		_mapView.delegate = self;
		_mapView.scrollEnabled = NO;
		_mapView.zoomEnabled = NO;
		[self.view addSubview:_mapView];
		
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
		
		
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		UIButton *backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[backButton setBackgroundImage:[[UIImage imageNamed:@"button_back.png"] retain] forState:UIControlStateNormal];
		[backButton setFrame:CGRectMake( 0.0f, 0.0f, 50.0f, 31.0f )];
		[backButton addTarget:self action:@selector(onBackButtonTouch) forControlEvents:UIControlEventTouchUpInside];		
		
		UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
		backBarButtonItem.style = UIBarButtonItemStyleBordered;
		
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, backBarButtonItem, nil];
    }
	
    return self;
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
	
	[self clear];
	
	// 현재 피드의 어노테이션은 미리 찍어둠
	[_mapView addAnnotation:feedObject];
	
	// 현재 피드의 region으로 애니메이션 (type = 0일 경우에는 애니메이션 안함)
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude ), 200, 200 ) animated:type ? YES : NO];
	
	// Animation 적용 (type 1의 애니메이션은 loadDidFinish에서)
	[self animateAppearance];
	
	self.navigationItem.title = feedObject.place;
	
	loaded = YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - web view

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"detail_finished"] && type == 0 )
	{
		NSLog( @"detail_finished" );
		if( _animationFinished )
			[self removeUpperAndLowerImages];
		else
			_loadingFinished = YES;
	}
}

- (void)loadFeedDetail
{
	[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, feedObject.feedId, type]];
}

- (void)loadFeedDetailIndex:(NSInteger)index
{
	// 현재 피드를 다시 로드할 필요가 없음
	if( index == _currentFeedIndex ) return;
	
	_loadFromDetail = YES;
//	_currentFeedIndex = index;
//	feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
	
	[self loadFeedDetail];
}

- (void)didFinishLoading:(NSString *)result
{
	NSLog( @"json : %@", result );
	NSDictionary *feed = [Utils parseJSON:result];
	
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
	
	
	// feed_detail을 처음 생성하는 로직, 지도에 핀을 찍고 선을 그리는 로직
	// 리스트나 맵에서 로드될 때만 해당
	if( !_loadFromDetail )
	{
		// UI 수정은 Main Thread에서
		[self performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
		
		NSArray *allFeeds = [feed objectForKey:@"all_feeds"];
		NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:allFeeds.count]; // 모든 피드들의 위치. 지도에 선 그릴 때 필요
		
		for( int i = 0; i < allFeeds.count; i++ )
		{
			NSDictionary *feed = (NSDictionary *)[allFeeds objectAtIndex:i];
			
			FeedObject *feedObj = [[FeedObject alloc] init];
			feedObj.feedId = [[feed objectForKey:@"feed_id"] integerValue];
			feedObj.latitude = [[feed objectForKey:@"latitude"] doubleValue];
			feedObj.longitude = [[feed objectForKey:@"longitude"] doubleValue];
			
			// 현재 피드일 경우
			if( feedObj.feedId == feedObject.feedId )
			{
				_currentFeedIndex = i;
			}
			else
			{
				// 현재 피드의 어노테이션은 viewDidAppear에서 이미 찍음
				[_mapView addAnnotation:feedObj];
			}
			
			[_feedDetailObjects addObject:feedObj];
			
			[locations addObject:[[[CLLocation alloc] initWithLatitude:feedObj.latitude longitude:feedObj.longitude] autorelease]];
		}
		
		// 라인 어노테이션
		FeedLineAnnotation *lineAnnotation = [[FeedLineAnnotation alloc] initWithLocations:locations mapView:_mapView];
		[_mapView addAnnotation:lineAnnotation];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(modifyFeedDetail:) withObject:feedObject waitUntilDone:NO];
	}
	
	// type 0의 애니메이션은 viewDidAppear에서
	[self performSelectorOnMainThread:@selector(animateAppearance) withObject:nil waitUntilDone:NO];
	
	// UI 변경은 메인 스레드에서
	[self performSelectorOnMainThread:@selector(resizeContentHeight) withObject:nil waitUntilDone:NO];
	
//	if( 
	
//	[self stopBusy];
}

#pragma mark - Scroll View

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect frame = _mapView.frame;
	
	if( _scrollView.contentOffset.y > 0 )
		frame.origin.y = MAP_Y - _scrollView.contentOffset.y;
	else
		frame.origin.y = MAP_Y - _scrollView.contentOffset.y / 2;
	
	_mapView.frame = frame;
}

# pragma mark - Map

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

#pragma mark - Javascript Function

- (void)createFeedDetail:(FeedObject *)feedObj
{
	NSString *func = [[NSString stringWithFormat:@"createFeedDetail(%d, %d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   feedObj.tripId,
					   feedObj.feedId,
					   feedObj.userId,
					   feedObj.profileImageURL,
					   feedObj.name,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.pictureURL,
					   feedObj.review,
					   @"feedObj.info",
					   feedObj.numAllFeeds,
					   feedObj.numLikes] retain];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
	NSLog( @"%@", func );
}

- (void)modifyFeedDetail:(FeedObject *)feedObj
{
	NSString *func = [[NSString stringWithFormat:@"modifyFeedDetail(%d, %d, '%@', '%@', '%@', '%@', %d)",
					   feedObj.feedId,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.review,
					   feedObj.numLikes,
					   feedObj.numComments] retain];
	
	[webView stringByEvaluatingJavaScriptFromString:func];
	
//	NSLog( @"%@", func );
}

#pragma mark - others

- (void)setOriginalRegion:(MKCoordinateRegion)region
{
	_mapView.region = originalRegion = region;
}

- (void)animateAppearance
{
	if( self.type == 0 )
	{
		self.webView.frame = CGRectMake( 0, 100, 320, 367 );
		
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
		[_scrollView addSubview:self.webView];
		self.webView.frame = CGRectMake( 0, 467, 320, 367 );
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.webView.frame = CGRectMake( 0, 100, 320, 367 );
		[UIView commitAnimations];
	}
}

- (void)animateDisappearance
{
	[self performSelector:@selector(onBackAnimationFinished) withObject:nil afterDelay:0.5];
	
	if( type == 0 )
	{
		[self.webView removeFromSuperview];
		
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
		self.webView.frame = CGRectMake( 0, 367, 320, self.webView.frame.size.height );
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
	[_scrollView addSubview:self.webView];
	
	[_upperImageView removeFromSuperview];
	[_lowerImageView removeFromSuperview];
}

- (void)resizeContentHeight
{
	float height = [[self.webView stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue] - 5;
	CGRect frame = self.webView.frame;
	frame.size.height = height;
	self.webView.frame = frame;
	_scrollView.contentSize = CGSizeMake( 320, height + 100 );
}

- (void)onBackButtonTouch
{
	[self animateDisappearance];
	
	// 선 제거
	for( id<MKAnnotation> annotation in _mapView.annotations )
	{
		if( [annotation isKindOfClass:[FeedLineAnnotation class]] )
			[_mapView removeAnnotation:annotation];
	}
}

- (void)onBackAnimationFinished
{
	if( type == 0 )
	{
		[_upperImageView removeFromSuperview];
		[_lowerImageView removeFromSuperview];
	}
	else if( type == 1 )
	{
		[self.webView removeFromSuperview];
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

- (void)leftFeedButtonDidTouchUpInside
{
	[self loadFeedDetailIndex:_currentFeedIndex - 1];
}

- (void)rightFeedButtonDidTouchUpInside
{
	[self loadFeedDetailIndex:_currentFeedIndex + 1];
}

@end
