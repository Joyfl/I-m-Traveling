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
#import "ImTravelingBarButtonItem.h"

#define MAP_HEIGHT	736
#define MAP_Y		-0.5 * ( MAP_HEIGHT - 100 )
#define WEBVIEW_Y	70

@interface FeedDetailViewController (Private)

@property (retain, readonly) FeedDetailWebView *leftWebView;
@property (retain, readonly) FeedDetailWebView *centerWebView;
@property (retain, readonly) FeedDetailWebView *rightWebView;

@end


@implementation FeedDetailViewController

- (id)initWithFeed:(FeedObject *)feed
{
	if( self = [super init] )
	{
		// Navigation Bar
		UIBarButtonItem *leftSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		leftSpacer.width = 4;
		
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects:leftSpacer, backButton, nil];
		[backButton release];
		
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
			detailWebView.frame = CGRectMake( i * 320 - 320, WEBVIEW_Y, 320, 367 - WEBVIEW_Y );
			[_webViews addObject:detailWebView];
			[detailWebView release];
		}
		
		_feedLoadingQueue = [[LoadingQueue alloc] init];
		_commentLoadingQueue = [[LoadingQueue alloc] init];
		
		_feedDetailObjects = [[NSMutableArray alloc] init];
		
		_commentBar = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 320, 40 )];
		
		UIImageView *commentBarBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_bar.png"]];
		[_commentBar addSubview:commentBarBackground];
		[commentBarBackground release];
		
		UIImageView *commentInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"comment_input.png"]];
		commentInputBackground.frame = CGRectMake( 7, 5, 235, 31 );
		[_commentBar addSubview:commentInputBackground];
		[commentInputBackground release];
		
		_commentInput = [[UITextField alloc] initWithFrame:CGRectMake( 17, 9, 220, 23 )];
		_commentInput.delegate = self;
		_commentInput.placeholder = NSLocalizedString( @"LEAVE_A_COMMENT", @"Leave a comment" );
		_commentInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		_commentInput.returnKeyType = UIReturnKeySend;
		[_commentBar addSubview:_commentInput];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
		
		_sendButton = [[UIButton alloc] initWithFrame:CGRectMake( 253, 5, 60, 31 )];
		_sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		[_sendButton setTitle:NSLocalizedString( @"SEND", @"Send" ) forState:UIControlStateNormal];
		[_sendButton setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
		[_sendButton addTarget:self action:@selector(sendButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_commentBar addSubview:_sendButton];
		
		_keyboardHideButton = [[UIButton alloc] initWithFrame:CGRectMake( 250, 171, 60, 29 )];
		[_keyboardHideButton setBackgroundImage:[UIImage imageNamed:@"button_hide_keyboard.png"] forState:UIControlStateNormal];
		[_keyboardHideButton addTarget:self action:@selector(keyboardHideButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		self.navigationItem.title = _feedObjectFromPrevView.place;
		
		_feedObjectFromPrevView = feed;
    }
	
    return self;
}

- (id)initFromListWithFeed:(FeedObject *)feed upperImage:(UIImage *)upperImage lowerImage:(UIImage *)lowerImage lowerImageViewOffset:(CGFloat)offset
{
	if( self = [self initWithFeed:feed] )
	{
		ref = 0;
		
		_upperImageView = [[UIImageView alloc] initWithImage:upperImage];
		_lowerImageView = [[UIImageView alloc] initWithImage:lowerImage];
		_lowerImageView.frame = CGRectMake( 0, offset, 320, _lowerImageView.frame.size.height );
		
		_upperImageViewOriginalY = 0;
		_lowerImageViewOriginalY = offset;
		
		[self.view addSubview:_upperImageView];
		[self.view addSubview:_lowerImageView];
		
		[self setMapViewRegionLatitude:feed.latitude longitude:feed.longitude animated:NO];
	}
	
	return self;
}

- (id)initFromMapWithFeed:(FeedObject *)feed originalRegion:(MKCoordinateRegion)originalRegion
{
	if( self = [self initWithFeed:feed] )
	{
		ref = 1;
		
		_mapView.region = _originalRegion = originalRegion;
		[self setMapViewRegionLatitude:feed.latitude longitude:feed.longitude animated:YES];
	}
	
	return self;
}

/*
- (id)initFromSimpleListWithFeedIndex:(NSInteger *)feedIndex
{
	if( self = [self initWithFeed:feed] )
	{
		_currentFeedIndex = feedIndex;
		
		FeedObject *currentFeed = [_feedDetailObjects objectAtIndex:index];
		[self activateWithFeedObject:currentFeed];
		
		[self createFeedDetail:currentFeed atIndex:index];
		
		[self drawAllFeedsOnMap];
		[self setMapViewRegionLatitude:currentFeed.latitude longitude:currentFeed.longitude animated:NO];
		
		[self prepareFeedDetailWithIndex:index - 1];
		[self prepareFeedDetailWithIndex:index + 1];
	}
	return self;
}
*/

- (void)webViewDidFinishLoad:(FeedDetailWebView *)webView
{
	if( webView == self.centerWebView )
	{
		[self preloadFeedDetail];
	}
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
	
	[_scrollView release];
	[_mapView release];
	[_webViews release];
	[_feedDetailObjects release];
	[_feedLoadingQueue release];
	[_commentLoadingQueue release];
	[_leftFeedButton release];
	[_rightFeedButton release];
	[_commentBar release];
	[_commentInput release];
	[_sendButton release];
	[_keyboardHideButton release];
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
//			NSLog( @"create : %d", index );
			[self createFeedDetail:feedObject atIndex:index];
		}
		else
		{
//			NSLog( @"load : %d", index );
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


#pragma mark -
#pragma mark Comments

- (void)prepareCommentsWithFeedIndex:(NSInteger)feedIndex
{
	if( 0 <= index && feedIndex < _feedDetailObjects.count )
	{
		FeedObject *feed = [_feedDetailObjects objectAtIndex:feedIndex];
		
		if( feed.numComments == 0 )
			return;
		
//		NSLog( @"Prepare comment index : %d (num : %d)", feedIndex, feed.numComments );
		
		if( feed.comments.count == feed.numComments )
		{
//			NSLog( @"add comments : %d", feedIndex );
			[self addComments:feed.comments atIndex:feedIndex];
		}
		else
		{
//			NSLog( @"load comments : %d", feedIndex );
			[_commentLoadingQueue addIndex:feedIndex];
			[self loadCommentsFromLoadingQueue];
		}
	}
}

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
	
//	NSLog( @"comments were added : %d", index );
}

- (void)loadCommentsFromLoadingQueue
{
	if( _commentLoadingQueue.count > 0 )
	{
		NSLog( @"%d", _commentLoadingQueue.firstIndex );
		NSInteger feedId = [[_feedDetailObjects objectAtIndex:_commentLoadingQueue.firstIndex] feedId];
//		NSLog( @"load comments from queue : %@", [NSString stringWithFormat:@"%@?feed_id=%d&type=0", API_FEED_COMMENT, feedId] );
		[self loadURL:[NSString stringWithFormat:@"%@?feed_id=%d&type=0", API_FEED_COMMENT, feedId]];
	}
}

- (void)loadingDidFinish:(NSString *)data
{
	NSDictionary *json = [Utils parseJSON:data];
	
	if( [self isError:json] )
	{
		NSLog( @"Error : %@", [json objectForKey:@"error"] );
		return;
	}
	
	id result = [json objectForKey:@"result"];
	
	// Feed Detail
	if( [result isKindOfClass:[NSDictionary class]] )
	{		
		FeedObject *feedObject = _feedObjectFromPrevView ? _feedObjectFromPrevView : [_feedDetailObjects objectAtIndex:_feedLoadingQueue.firstIndex];
		[self fillFeedObject:feedObject fromDictionary:result];
		
		// 첫 로딩
		if( _feedObjectFromPrevView )
		{
			// UI 수정은 Main Thread에서
			[self.centerWebView clear];
			[self.centerWebView createFeedDetail:feedObject];
//			[self resizeContentHeight];
//			[self.centerWebView performSelectorOnMainThread:@selector(createFeedDetail:) withObject:feedObject waitUntilDone:NO];
			[self performSelectorOnMainThread:@selector(resizeContentHeight) withObject:nil waitUntilDone:NO];
			[self handleAllFeeds:[result objectForKey:@"all_feeds"] currentFeedId:feedObject.feedId];
			
			[_feedDetailObjects replaceObjectAtIndex:_currentFeedIndex withObject:feedObject];
			
			[self changeNavigationBarTitle];
			
			[_feedLoadingQueue addIndex:_currentFeedIndex - 1];
			[_feedLoadingQueue addIndex:_currentFeedIndex + 1];
			
			_feedObjectFromPrevView = nil; // 첫 로딩이라는 것을 알려주는 지표 제거
			
			[self animateAppearance];
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
	else if( [result isKindOfClass:[NSArray class]] )
	{
//		NSLog( @"comments in json : %@", json );
		FeedObject *feed = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		
		for( NSDictionary *c in result )
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
	
	// 댓글 등록 완료
	else if( [result isKindOfClass:[NSString class]] )
	{
		Comment *comment = [[Comment alloc] init];
		comment.commentId = [result integerValue];
		comment.userId = [Utils userId];
		comment.profileImgUrl = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, comment.userId];
		comment.name = [Utils userName];
		comment.time = [Utils dateStringForUpload:[NSDate date]];
		comment.comment = _commentInput.text;
		[self.centerWebView addComment:comment];
		
		_commentInput.text = @"";
		_commentInput.enabled = YES;
		_sendButton.enabled = YES;
		
		return;
	}
}

- (void)fillFeedObject:(FeedObject *)feedObject fromDictionary:(NSDictionary *)feed
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

- (void)animateAppearance
{
	[self performSelector:@selector(animationDidFinish) withObject:nil afterDelay:0.5];
	
	if( ref == 0 )
	{
		self.centerWebView.frame = CGRectMake( 0, WEBVIEW_Y, 320, 367 );
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		_upperImageView.frame = CGRectMake( 0, -_upperImageView.frame.size.height, 320, _upperImageView.frame.size.height );
		_lowerImageView.frame = CGRectMake( 0, 90, 320, _lowerImageView.frame.size.height );
		[UIView commitAnimations];
	}
	else if( ref == 1 )
	{
		[_scrollView addSubview:self.leftWebView];
		[_scrollView addSubview:self.centerWebView];
		[_scrollView addSubview:self.rightWebView];
		self.centerWebView.frame = CGRectMake( 0, 467, 320, 367 );
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.centerWebView.frame = CGRectMake( 0, WEBVIEW_Y, 320, 367 );
		[UIView commitAnimations];
	}
	else
	{
		[_scrollView addSubview:self.leftWebView];
		[_scrollView addSubview:self.centerWebView];
		[_scrollView addSubview:self.rightWebView];
		
		self.centerWebView.frame = CGRectMake( 0, WEBVIEW_Y, 320, 367 );
	}
}

- (void)animateDisappearance
{
	if( ref == 0 )
	{
		// scroll view 컨텐츠 y좌표를 0으로 이동시키고 애니메이션시킴.
		if( _scrollView.contentOffset.y == 0 )
		{
			[self scrollViewDidScrollToTopFromBack];
		}
		else
		{
			[self performSelector:@selector(scrollViewDidScrollToTopFromBack) withObject:nil afterDelay:0.5];
			[_scrollView setContentOffset:CGPointZero animated:YES];
		}
	}
	else if( ref == 1 )
	{
		[self performSelector:@selector(backAnimationDidFinish) withObject:nil afterDelay:0.5];
		
		[_mapView setRegion:_originalRegion animated:YES];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.centerWebView.frame = CGRectMake( 0, 367, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
	}
	else
	{
		[self backAnimationDidFinish];
	}
}

- (void)animationDidFinish
{
	[self stopBusy];
	
	if( ref == 0 )
		[self removeUpperAndLowerImages];
}

- (void)removeUpperAndLowerImages
{
	[_scrollView addSubview:self.leftWebView];
	[_scrollView addSubview:self.centerWebView];
	[_scrollView addSubview:self.rightWebView];
	
	[_upperImageView removeFromSuperview];
	[_lowerImageView removeFromSuperview];
}

- (void)scrollViewDidScrollToTopFromBack
{
	[self performSelector:@selector(backAnimationDidFinish) withObject:nil afterDelay:0.5];
	
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

- (void)backAnimationDidFinish
{
	if( ref == 0 )
	{
		[_upperImageView removeFromSuperview];
		[_lowerImageView removeFromSuperview];
		[_upperImageView release];
		[_lowerImageView release];
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

- (void)setUpperImageView:(UIImageView *)upperImageView lowerImageView:(UIImageView *)lowerImageView lowerImageViewOffset:(CGFloat)offset
{
	_upperImageView = upperImageView;
	_lowerImageView = lowerImageView;
	
	_upperImageViewOriginalY = 0;
	_lowerImageViewOriginalY = offset;
	
	_lowerImageView.frame = CGRectMake( 0, offset, 320, _lowerImageView.frame.size.height );
}

- (void)feedChangeAnimationDidFinish
{
	[self stopBusy];
}


#pragma mark -
#pragma mark Touch Selectors

- (void)leftFeedButtonDidTouchUpInside
{
	if( 0 < _currentFeedIndex )
	{
		[self startBusy];
		
		_currentFeedIndex --;
		
		[self performSelector:@selector(feedChangeAnimationDidFinish) withObject:nil afterDelay:0.5];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.leftWebView.frame = CGRectMake( 0, WEBVIEW_Y, 320, self.leftWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( 320, WEBVIEW_Y, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[self setMapViewRegionLatitude:feedObject.latitude longitude:feedObject.longitude animated:YES];
		
		[self changeNavigationBarTitle];
		
		[_webViews exchangeObjectAtIndex:1 withObjectAtIndex:0];
		[_webViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
		
		[self resizeContentHeight];
		
		self.leftWebView.frame = CGRectMake( -320, WEBVIEW_Y, 320, self.leftWebView.frame.size.height );
		
		// 왼쪽 피드 로드
		[self prepareFeedDetailWithIndex:_currentFeedIndex - 1];
	}
}

- (void)rightFeedButtonDidTouchUpInside
{
	if( _currentFeedIndex < _feedDetailObjects.count - 1 )
	{
		[self startBusy];
		
		_currentFeedIndex ++;
		
		[self performSelector:@selector(feedChangeAnimationDidFinish) withObject:nil afterDelay:0.5];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.rightWebView.frame = CGRectMake( 0, WEBVIEW_Y, 320, self.rightWebView.frame.size.height );
		self.centerWebView.frame = CGRectMake( -320, WEBVIEW_Y, 320, self.centerWebView.frame.size.height );
		[UIView commitAnimations];
		
		FeedObject *feedObject = [_feedDetailObjects objectAtIndex:_currentFeedIndex];
		[self setMapViewRegionLatitude:feedObject.latitude longitude:feedObject.longitude animated:YES];
		
		[self changeNavigationBarTitle];
		
		[_webViews exchangeObjectAtIndex:1 withObjectAtIndex:2];
		[_webViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
		
		[self resizeContentHeight];
		
		self.rightWebView.frame = CGRectMake( 320, WEBVIEW_Y, 320, self.rightWebView.frame.size.height );
		
		// 오른쪽 피드 로드
		[self prepareFeedDetailWithIndex:_currentFeedIndex + 1];
	}
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

- (void)sendButtonDidTouchUpInside
{
	_commentInput.enabled = NO;
	_sendButton.enabled = NO;
	
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	[data setObject:[NSNumber numberWithInteger:[Utils userId]] forKey:@"user_id"];
	[data setObject:[Utils email] forKey:@"email"];
	[data setObject:[Utils password] forKey:@"password"];
	[data setObject:[NSNumber numberWithInteger:[[_feedDetailObjects objectAtIndex:_currentFeedIndex] feedId]] forKey:@"feed_id"];
	[data setObject:_commentInput.text forKey:@"comment"];
	[data setObject:@"1" forKey:@"type"];
	[self loadURL:API_FEED_COMMENT withData:data];
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

- (void)resizeWebViewHeight:(UIWebView *)wv
{
	CGRect frame = wv.frame;
	frame.size.height = [[wv stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue];
	wv.frame = frame;
}

- (void)resizeContentHeight
{
	// 왜 공간이 생기는지 모르겠음.
	NSInteger wtfSpace = [[_feedDetailObjects objectAtIndex:_currentFeedIndex] numComments] ? WEBVIEW_Y : WEBVIEW_Y - 4;
	
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
		
		/*if( ref == 0 )
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
		else
		{
			// Simple Feed List에서 넘어올 경우 stopBusy
			[self stopBusy];
		}*/
		
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
	/*
	SimpleFeedListViewController *simpleFeedListViewController = [[SimpleFeedListViewController alloc] initFromFeedDetailViewControllerFeeds:_feedDetailObjects lastFeedIndex:_currentFeedIndex];
	[self.navigationController pushViewController:simpleFeedListViewController animated:YES];
	 */
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self sendButtonDidTouchUpInside];
	
	return NO;
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
