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
#import "Pin.h"
#import "SimpleFeedListViewController.h"
#import "Comment.h"

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

// Feed List에서 Detail로 넘어올 때 로딩과정에서 생기는 부자연스러움을 없애기 위해 미리 생성 후 로드한다.
+ (FeedDetailViewController *)viewController
{
	static FeedDetailViewController *_detailViewController;
	
	if( _detailViewController == nil )
	{
		_detailViewController = [[FeedDetailViewController alloc] initWithFeeds:nil];
	}
	
	return _detailViewController;
}

- (id)initWithFeeds:(NSMutableArray *)feeds
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
		
		self.view.backgroundColor = [UIColor darkGrayColor];
		
		
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
		
		_leftFeedButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 28, 44, 44 )];
		_leftFeedButton.alpha = 0.7;
		[_leftFeedButton setImage:[UIImage imageNamed:@"button_left.png"] forState:UIControlStateNormal];
		[_leftFeedButton addTarget:self action:@selector(leftFeedButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		_rightFeedButton = [[UIButton alloc] initWithFrame:CGRectMake( 276, 28, 44, 44 )];
		_rightFeedButton.alpha = 0.7;
		[_rightFeedButton setImage:[UIImage imageNamed:@"button_right.png"] forState:UIControlStateNormal];
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
		
		_feedLoadingQueue = [[LoadingQueue alloc] init];
		_commentLoadingQueue = [[LoadingQueue alloc] init];
		
		if( feeds )
		{
			_feedDetailObjects = [feeds retain];
			_feedLoadingQueue.maxIndex = _feedDetailObjects.count;
		}
		else
		{
			_feedDetailObjects = [[NSMutableArray alloc] init];
		}
		
		
		_commentBar = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 320, 40 )];
		
		UIImageView *commentBarBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_bar.png"]];
		[_commentBar addSubview:commentBarBackground];
		[commentBarBackground release];
		
		UIImageView *commentInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_input.png"]];
		commentInputBackground.frame = CGRectMake( 7, 5, 235, 31 );
		[_commentBar addSubview:commentInputBackground];
		[commentInputBackground release];
		
		_commentInput = [[UITextField alloc] initWithFrame:CGRectMake( 17, 9, 220, 23 )];
		_commentInput.placeholder = @"Leave a comment";
		_commentInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		[_commentBar addSubview:_commentInput];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
		
		UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake( 253, 5, 60, 31 )];
		sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[sendButton setTitle:@"Send" forState:UIControlStateNormal];
		[sendButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
		[_commentBar addSubview:sendButton];
		
		_keyboardHideButton = [[UIButton alloc] initWithFrame:CGRectMake( 250, 171, 60, 29 )];
		[_keyboardHideButton setBackgroundImage:[UIImage imageNamed:@"button_hide_keyboard.png"] forState:UIControlStateNormal];
		[_keyboardHideButton addTarget:self action:@selector(keyboardHideButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
	
    return self;
}

- (void)activateWithFeedObject:(FeedObject *)feedObject
{
	self.loaded = _animationFinished = _loadingFinished = NO;
	
	self.navigationItem.title = _feedObjectFromPrevView.place;
	
	for( int i = 0; i < 3; i++ )
	{
		[[_webViews objectAtIndex:i] clear];
	}
	
	if( ref != 2 )
	{
		_feedObjectFromPrevView = feedObject;
		[_feedDetailObjects removeAllObjects];
		[_feedLoadingQueue removeAllObjects];
		[self preloadFeedDetail];
	}
}

/**
 * SimpleFeedList에서 호출
 */
- (void)activateWithFeedIndex:(NSInteger)index
{
	NSLog( @"-----------------------------------------" );
	_currentFeedIndex = index;
	
	FeedObject *currentFeed = [_feedDetailObjects objectAtIndex:index];
	[self activateWithFeedObject:currentFeed];
	
	[self createFeedDetail:currentFeed atIndex:index];
	
	[self drawAllFeedsOnMap];
	[self setMapViewRegionLatitude:currentFeed.latitude longitude:currentFeed.longitude animated:NO];
	
	[self prepareFeedDetailWithIndex:index - 1];
	[self prepareFeedDetailWithIndex:index + 1];
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
	
	// 현재 피드의 region으로 애니메이션 (ref = 1일 경우에만 애니메이션)
	if( _feedObjectFromPrevView )
		[self setMapViewRegionLatitude:_feedObjectFromPrevView.latitude longitude:_feedObjectFromPrevView.longitude animated:ref ? YES : NO];
	
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
			NSLog( @"create : %d", index );
			[self createFeedDetail:feedObject atIndex:index];
		}
		else
		{
			NSLog( @"load : %d", index );
			[_feedLoadingQueue addIndex:index];
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
	if( _feedLoadingQueue.count > 0 )
	{
		[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&ref=2", API_FEED_DETAIL, [[_feedDetailObjects objectAtIndex:_feedLoadingQueue.firstIndex] feedId]]];
	}
}

- (void)prepareCommentsWithFeedIndex:(NSInteger)feedIndex
{
	if( 0 <= index && feedIndex < _feedDetailObjects.count )
	{
		FeedObject *feed = [_feedDetailObjects objectAtIndex:feedIndex];
		
		if( feed.numComments == 0 )
			return;
		
		NSLog( @"Prepare comment index : %d (num : %d)", feedIndex, feed.numComments );
		
		if( feed.comments.count == feed.numComments )
		{
			NSLog( @"add comments : %d", feedIndex );
			[self addComments:feed.comments atIndex:feedIndex];
		}
		else
		{
			NSLog( @"load comments : %d", feedIndex );
			[_commentLoadingQueue addIndex:feedIndex];
			[self loadCommentsFromLoadingQueue];
		}
	}
}

/*- (void)addComment:(Comment *)comment atIndex:(NSInteger)index
{
	if( index < _currentFeedIndex )
	{
		[self.leftWebView addComment:comment];
	}
	else if( _currentFeedIndex < index )
	{
		[self.rightWebView addComment:comment];
	}
	else
	{
		[self.centerWebView addComment:comment];
	}
}*/

- (void)addComments:(NSArray *)comments atIndex:(NSInteger)index
{
	FeedDetailWebView *webView;
	
	if( index < _currentFeedIndex )
		webView = self.leftWebView;
	
	else if( _currentFeedIndex < index )
		webView = self.rightWebView;
	
	else
		webView = self.centerWebView;
	
	[webView clearComments];
	
	for( Comment *comment in comments )
		[webView addComment:comment];
	
	NSLog( @"comments were added : %d", index );
}

- (void)loadCommentsFromLoadingQueue
{
	if( _commentLoadingQueue.count > 0 )
	{
		NSLog( @"%d", _commentLoadingQueue.firstIndex );
		NSInteger feedId = [[_feedDetailObjects objectAtIndex:_commentLoadingQueue.firstIndex] feedId];
		NSLog( @"load comments from queue : %@", [NSString stringWithFormat:@"%@?feed_id=%d&type=0", API_FEED_COMMENT, feedId] );
		[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&type=0", API_FEED_COMMENT, feedId]];
	}
}


- (void)loadingDidFinish:(NSString *)result
{
	id json = [Utils parseJSON:result];
	
	// Feed Detail or ERROR
	if( [json isKindOfClass:[NSDictionary class]] )
	{
		if( [json objectForKey:@"ERROR"] )
		{
			NSLog( @"ERROR! : %@", [json objectForKey:@"ERROR"] );
			return;
		}
		
		FeedObject *feedObject = _feedObjectFromPrevView ? _feedObjectFromPrevView : [_feedDetailObjects objectAtIndex:_feedLoadingQueue.firstIndex];
		[self completeFeedObject:feedObject fromDictionary:json];
		
		// 첫 로딩
		if( _feedObjectFromPrevView )
		{
			// UI 수정은 Main Thread에서, Detail에서 다른 Detail을 로드할 경우는 modifyFeedDetail 사용
			[self.centerWebView clear];
			[self.centerWebView performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
			[self performSelectorOnMainThread:@selector(resizeContentHeight) withObject:nil waitUntilDone:NO];
			[self handleAllFeeds:[json objectForKey:@"all_feeds"] currentFeedId:feedObject.feedId];
			
			[_feedDetailObjects replaceObjectAtIndex:_currentFeedIndex withObject:feedObject];
			
			[self changeNavigationBarTitle];
			
			[_feedLoadingQueue addIndex:_currentFeedIndex - 1];
			[_feedLoadingQueue addIndex:_currentFeedIndex + 1];
			
			_feedObjectFromPrevView = nil; // 첫 로딩이라는 것을 알려주는 지표 제거
		}
		else
		{
			[_feedDetailObjects replaceObjectAtIndex:_feedLoadingQueue.firstIndex withObject:feedObject];
			
			[self createFeedDetail:feedObject atIndex:_feedLoadingQueue.firstIndex];
			
			[_feedLoadingQueue removeLoadedFromLoadingQueue];
		}
		
		[self loadFeedDetailFromLoadingQueue];
	}
	
	// Comment
	else if( [json isKindOfClass:[NSArray class]] )
	{
		NSLog( @"comments in json : %@", json );
		FeedObject *feed = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		
		for( NSDictionary *c in json )
		{
			Comment *comment = [[Comment alloc] init];
			comment.commentId = [[c objectForKey:@"feed_comment_id"] integerValue];
			comment.userId = [[c objectForKey:@"user_id"] integerValue];
			comment.profileImgUrl = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, comment.userId];
			comment.name = [c objectForKey:@"name"];
			comment.time = [c objectForKey:@"time"];
			comment.comment = [c objectForKey:@"comment"];
			[feed.comments addObject:comment];
//			[self addComment:comment atIndex:_commentLoadingQueue.firstIndex];
		}
		
		[self addComments:feed.comments atIndex:_commentLoadingQueue.firstIndex];
		[_commentLoadingQueue removeLoadedFromLoadingQueue];
	}
}

- (void)completeFeedObject:(FeedObject *)feedObject fromDictionary:(NSDictionary *)feed
{
	// ref가 0, 1, 2일 경우에 공통적으로 해당
	feedObject.tripId = [[feed objectForKey:@"trip_id"] integerValue];
	feedObject.review = [feed objectForKey:@"review"];
	feedObject.numAllFeeds = [[feed objectForKey:@"all_feeds"] count];
	feedObject.info = [feed objectForKey:@"info"];
	feedObject.comments = [[NSMutableArray alloc] init];
	
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
	_feedLoadingQueue.maxIndex = allFeeds.count;
	_commentLoadingQueue.maxIndex = allFeeds.count;
	
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
		
		[_mapView addAnnotation:feedObj];
		
		[_feedDetailObjects addObject:feedObj];
		
		// 선을 그리기위한 정보
		coordinates[i] = feedObj.coordinate;
	}
	
	MKPolyline *overlay = [MKPolyline polylineWithCoordinates:coordinates count:allFeeds.count];
	[_mapView addOverlay:overlay];
	[overlay release];
}

/*
 * ref가 2일 경우에는 handleAllFeeds를 호출하지 않고 drawAllFeedsOnMap을 호출한다.
 */
- (void)drawAllFeedsOnMap
{
	CLLocationCoordinate2D coordinates[_feedDetailObjects.count];
	
	for( NSInteger i = 0; i < _feedDetailObjects.count; i++ )
	{
		FeedObject *feed = [_feedDetailObjects objectAtIndex:i];
		[_mapView addAnnotation:feed];
		coordinates[i] = feed.coordinate;
	}
	
	MKPolyline *overlay = [MKPolyline polylineWithCoordinates:coordinates count:_feedDetailObjects.count];
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
	float buttonY = frame.origin.y + 346;
	
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
	Pin *pin = (Pin *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[Pin alloc] initWithAnnotation:annotation reuseIdentifier:pinId];
	}
	
	return pin;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
	if( [overlay isKindOfClass:[MKPolyline class]] )
	{
		MKPolylineView *polygonView = [[MKPolylineView alloc] initWithOverlay:overlay];
		polygonView.lineWidth = 4;
		polygonView.strokeColor = [UIColor colorWithRed:0.13 green:0.22 blue:0.3 alpha:1];
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
	else
	{
		[_scrollView addSubview:self.leftWebView];
		[_scrollView addSubview:self.centerWebView];
		[_scrollView addSubview:self.rightWebView];
		
		self.centerWebView.frame = CGRectMake( 0, 100, 320, 367 );
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
	else
	{
		[UIView cancelPreviousPerformRequestsWithTarget:self];
		[self backAnimationDidFinish];
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
	else
	{
		[self.navigationController popViewControllerAnimated:YES];
		return;
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
		[UIView setAnimationDuration:0.5];
		self.leftWebView.frame = CGRectMake( 0, 100, 320, self.leftWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( 320, 100, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[self setMapViewRegionLatitude:feedObject.latitude longitude:feedObject.longitude animated:YES];
		
		[self changeNavigationBarTitle];
		
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
		[UIView setAnimationDuration:0.5];
		self.rightWebView.frame = CGRectMake( 0, 100, 320, self.rightWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( -320, 100, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[self setMapViewRegionLatitude:feedObject.latitude longitude:feedObject.longitude animated:YES];
		
		[self changeNavigationBarTitle];
		
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

- (void)keyboardHideButtonDidTouchUpInside
{
	[_commentInput resignFirstResponder];
}


#pragma mark -
#pragma mark Keyboard

- (void)keyboardDidShow
{
	[self.view addSubview:_keyboardHideButton];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	_scrollView.frame = CGRectMake( 0, 0, 320, 200 );
	[UIView commitAnimations];
	
	[_scrollView setContentOffset:CGPointMake( 0, _scrollView.contentSize.height - 216 + 10 ) animated:YES];
}

- (void)keyboardWillHide
{
	[_keyboardHideButton removeFromSuperview];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	_scrollView.frame = CGRectMake( 0, 0, 320, 367 );
	[UIView commitAnimations];
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
	NSInteger wtfSpace = [[_feedDetailObjects objectAtIndex:_currentFeedIndex] numComments] ? 100 : 96;
	
	[_commentBar removeFromSuperview];
	[_scrollView addSubview:_commentBar];
	
	CGRect frame = _commentBar.frame;
	frame.origin.y = self.centerWebView.frame.size.height + wtfSpace;
	_commentBar.frame = frame;
	_scrollView.contentSize = CGSizeMake( 320, self.centerWebView.frame.size.height + wtfSpace + 44 );
}

- (void)feedDetailDidFinishCreating:(FeedDetailWebView *)webView
{
	// WebView 컨텐츠 리사이징
	[self resizeWebViewHeight:webView];
	
	if( webView == self.centerWebView )
	{
		[self resizeContentHeight];
		
		if( ref == 0 )
		{
			if( _animationFinished )
				[self removeUpperAndLowerImages];
			else
				_loadingFinished = YES;
		}
		else if( ref == 1 )
		{
			// ref가 1일 경우의 애니메이션 (ref 0, 2의 애니메이션은 viewDidAppear에서)
			[self performSelectorOnMainThread:@selector(animateAppearance) withObject:nil waitUntilDone:NO];
		}
		
		[self prepareCommentsWithFeedIndex:_currentFeedIndex];
	}
	else if( webView == self.leftWebView )
	{
		[self prepareCommentsWithFeedIndex:_currentFeedIndex - 1];
	}
	else if( webView == self.rightWebView )
	{
		[self prepareCommentsWithFeedIndex:_currentFeedIndex + 1];
	}
}

- (void)commentDidAdd:(FeedDetailWebView *)webView
{
	// WebView 컨텐츠 리사이징
	[self resizeWebViewHeight:webView];
	[self resizeContentHeight];
}

- (void)seeAllFeeds
{
	SimpleFeedListViewController *simpleFeedListViewController = [[SimpleFeedListViewController alloc] initFromFeedDetailViewControllerFeeds:_feedDetailObjects lastFeedIndex:_currentFeedIndex];
	[self.navigationController pushViewController:simpleFeedListViewController animated:YES];
}


#pragma mark -
#pragma mark Utils

- (void)changeNavigationBarTitle
{
	self.navigationItem.title = [[_feedDetailObjects objectAtIndex:_currentFeedIndex] place];
}

- (void)setMapViewRegionLatitude:(CGFloat)latitude longitude:(CGFloat)longitude animated:(BOOL)animated
{
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( latitude, longitude ), 200, 200 ) animated:animated];
}

@end
