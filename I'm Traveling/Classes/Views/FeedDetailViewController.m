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
#import "FeedAnnotation.h"
#import "FeedLineAnnotation.h"
#import "FeedLineAnnotationView.h"

@interface FeedDetailViewController (Private)

- (void)removeUpperAndLowerImages;

- (void)createFeedDetail:(FeedObject *)feedObj;
- (void)modifyFeedDetail:(FeedObject *)feedObj;

- (void)resizeContentHeight;

@end


@implementation FeedDetailViewController

@synthesize feedObject, type, mapView=_mapView, upperImageView, lowerImageView, loaded;

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
		
		self.webView.frame = CGRectMake( 0, 100, 320, 367 );
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
		
		[self loadURL:HTML_INDEX];

		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, MAP_Y, 320, MAP_HEIGHT )];
		_mapView.delegate = self;
		_mapView.scrollEnabled = NO;
		_mapView.zoomEnabled = NO;
		[self.view addSubview:_mapView];
		
		[self.view addSubview:_scrollView];
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
	[_scrollView addSubview:self.webView];
	
	if( loaded ) return;
	
	[self clear];
	
	[_mapView removeAnnotations:_mapView.annotations];
	
	// 현재 피드의 어노테이션은 미리 찍어둠
	FeedAnnotation *annotation = [[FeedAnnotation alloc] init];
	annotation.feedId = feedObject.feedId;
	annotation.coordinate = CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude );
	[_mapView addAnnotation:annotation];
	
	// 현재 피드의 region으로 애니메이션
	[_mapView setRegion:MKCoordinateRegionMakeWithDistance( CLLocationCoordinate2DMake( feedObject.latitude, feedObject.longitude ), 200, 200 ) animated:YES];
	
	// Animation 적용 (type 1의 애니메이션은 loadFeedDetail에서)
	if( type == 0 )
	{
		[self performSelector:@selector(onAnimationFinished) withObject:nil afterDelay:0.5];
		
		[self.view addSubview:upperImageView];
		[self.view addSubview:lowerImageView];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		upperImageView.frame = CGRectMake( 0, -upperImageView.frame.size.height, 320, upperImageView.frame.size.height );
		lowerImageView.frame = CGRectMake( 0, 100, 320, lowerImageView.frame.size.height );
		[UIView commitAnimations];
	}
	
	self.navigationItem.title = feedObject.place;
	
	loaded = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[self.webView removeFromSuperview];
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
		if( animationFinished )
			[self removeUpperAndLowerImages];
		else
			loadingFinished = YES;
	}
}

- (void)loadFeedDetailAfterDelay:(NSTimeInterval)delay
{
	[self performSelector:@selector(loadFeedDetail) withObject:nil afterDelay:delay];
}

- (void)loadFeedDetail
{
	NSString *json = [Utils getHtmlFromUrl:[NSString stringWithFormat:@"%@?feed_id=%d&type=%d", API_FEED_DETAIL, feedObject.feedId, type]];
	NSLog( @"json : %@", json );
	NSDictionary *feed = [Utils parseJSON:json];
	
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
	
	[self clear];
	[self createFeedDetail:feedObject];
	
	NSArray *allFeeds = [feed objectForKey:@"all_feeds"];
	NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:allFeeds.count]; // 모든 피드들의 위치. 지도에 선 그릴 때 필요
	
	for( int i = 0; i < allFeeds.count; i++ )
	{
		NSDictionary *feed = (NSDictionary *)[allFeeds objectAtIndex:i];
		FeedAnnotation *annotation = [[FeedAnnotation alloc] init];
		annotation.feedId = [[feed objectForKey:@"feed_id"] integerValue];
		double latitude = [[feed objectForKey:@"latitude"] doubleValue];
		double longitude = [[feed objectForKey:@"longitude"] doubleValue];
		annotation.coordinate = CLLocationCoordinate2DMake( latitude, longitude );
		
		// 현재 피드일 경우
		if( annotation.feedId == feedObject.feedId )
		{
			[_feedDetailObjects setObject:feedObject forKey:[NSNumber numberWithInt:feedObject.feedId]];
		}
		else
		{
			FeedObject *feedObj = [[FeedObject alloc] init];
			feedObj.feedId = annotation.feedId;
			feedObj.latitude = latitude;
			feedObj.longitude = longitude;
			
			// 현재 피드의 어노테이션은 viewDidAppear에서 이미 찍음
			[_mapView addAnnotation:annotation];
		}
		
		[locations addObject:[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease]];
	}
	
	FeedLineAnnotation *lineAnnotation = [[FeedLineAnnotation alloc] initWithLocations:locations mapView:_mapView];
	[_mapView addAnnotation:lineAnnotation];
	
	// type 0의 애니메이션은 viewDidAppear에서
	if( type == 1 )
	{
		self.webView.frame = CGRectMake( 0, 367, 320, 367 );
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.5];
		self.webView.frame = CGRectMake( 0, 100, 320, 367 );
		[UIView commitAnimations];
	}
	
	[self resizeContentHeight];
	
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

- (void)onAnimationFinished
{
	if( loadingFinished )
		[self removeUpperAndLowerImages];
	else
		animationFinished = YES;
}

- (void)removeUpperAndLowerImages
{
	[upperImageView removeFromSuperview];
	[lowerImageView removeFromSuperview];
	
	upperImageView = nil;
	lowerImageView = nil;
}

- (void)resizeContentHeight
{
	float height = [[self.webView stringByEvaluatingJavaScriptFromString:@"getHeight()"] floatValue] - 5;
	CGRect frame = self.webView.frame;
	frame.size.height = height;
	self.webView.frame = frame;
	_scrollView.contentSize = CGSizeMake( 320, height + 100 );
}

@end
