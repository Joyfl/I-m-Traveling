//
//  PlaceSelectionViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "PlaceSelectionViewController.h"
#import "ShareViewController.h"
#import "Const.h"
#import "Utils.h"
#import "Place.h"
#import "ImTravelingNavigationController.h"
#import "ImTravelingBarButtonItem.h"
#import "PlaceAddViewController.h"
#import "Pin.h"


@implementation PlaceSelectionViewController

@synthesize category;

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_PLACE_LIST", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		// title		
		UIView *titleButtons = [[UIView alloc] initWithFrame:CGRectMake( 0, -1, 152, 31 )];
		
		UIButton *listButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 76, 31 )];
		listButton.tag = 0;
		listButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		listButton.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
		listButton.titleEdgeInsets = UIEdgeInsetsMake( 0, 4, 0, 0 );
		[listButton setTitle:NSLocalizedString( @"LIST", @"" ) forState:UIControlStateNormal];
		[listButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
		[listButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left.png"] forState:UIControlStateNormal];
		[listButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left_selected.png"] forState:UIControlStateHighlighted];
		[listButton setBackgroundImage:[UIImage imageNamed:@"button_bar_left_selected.png"] forState:UIControlStateDisabled];
		[listButton addTarget:self action:@selector(titleButtonsDidTouchDown:) forControlEvents:UIControlEventTouchDown];
		[titleButtons addSubview:listButton];
		listButton.highlighted = YES;
		listButton.enabled = NO;
		[listButton release];
		
		UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake( 75, 0, 76, 31 )];
		mapButton.tag = 1;
		mapButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		mapButton.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
		mapButton.titleEdgeInsets = UIEdgeInsetsMake( 0, -4, 0, 0 );
		[mapButton setTitle:NSLocalizedString( @"MAP", @"" ) forState:UIControlStateNormal];
		[mapButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
		[mapButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right.png"] forState:UIControlStateNormal];
		[mapButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right_selected.png"] forState:UIControlStateHighlighted];
		[mapButton setBackgroundImage:[UIImage imageNamed:@"button_bar_right_selected.png"] forState:UIControlStateDisabled];
		[mapButton addTarget:self action:@selector(titleButtonsDidTouchDown:) forControlEvents:UIControlEventTouchDown];
		[titleButtons addSubview:mapButton];
		[mapButton release];
		
		self.navigationItem.titleView = titleButtons;
		[titleButtons release];
		
		ImTravelingBarButtonItem *addButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"ADD_PLACE", @"" ) target:self action:@selector(addButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];
		
		for( NSInteger i = 9; i > 5; i-- )
			[[self.webView.scrollView.subviews objectAtIndex:i] setHidden:YES];
		
		// search bar 때문에 높이 416에서 44를 추가로 뺌.
		self.webView.frame = CGRectMake( 0, 44, 320, 372 );
		self.webView.backgroundColor = [UIColor colorWithRed:0.960 green:0.89 blue:0.82 alpha:1.0];
		self.view.backgroundColor = [UIColor colorWithRed:0.960 green:0.89 blue:0.82 alpha:1.0];
		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 0, 320, WEBVIEW_HEIGHT_NO_TABBAR )];
		_mapView.delegate = self;
		_mapView.hidden = YES;
		[self.view addSubview:_mapView];
		
		_shareViewController = shareViewController;
		
		_places = [[NSMutableDictionary alloc] init];
		
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake( 0, 0, 320, 44 )];
		_searchBar.delegate = self;
		_searchBar.placeholder = NSLocalizedString( @"PLACE_SEARCH", @"" );
		_searchBar.backgroundImage = [UIImage imageNamed:@"search_bar.png"];
		[self.view addSubview:_searchBar];
		
		[self loadPage:HTML_INDEX];
		[self startBusy];
	}
	
	return self;
}


#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
	
	if( _placeSelected )
		[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Navigation Bar Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)titleButtonsDidTouchDown:(id)sender
{
	for( int i = 0; i < 2; i++ )
	{
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).highlighted = NO;
		((UIButton *)[self.navigationItem.titleView.subviews objectAtIndex:i]).enabled = YES;
	}
	
	UIButton *button = (UIButton *)sender;
	button.highlighted = YES;
	button.enabled = NO;
	
	switch( button.tag )
	{
		// map
		case 0:
			webView.hidden = NO;
			_mapView.hidden = YES;
			
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = _searchBar.frame;
				frame.origin.y = 0;
				_searchBar.frame = frame;
			}];
			break;
			
		// list
		case 1:
			webView.hidden = YES;
			_mapView.hidden = NO;
			
			[UIView animateWithDuration:0.25 animations:^{
				CGRect frame = _searchBar.frame;
				frame.origin.y = -43;
				_searchBar.frame = frame;
			}];
			break;
	}
	
	[self reloadWebView];
}

- (void)addButtonDidTouchUpInside
{
	PlaceAddViewController *placeAddViewController = [[PlaceAddViewController alloc] init];
	placeAddViewController.placeSelectionViewController = self;
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:placeAddViewController];
	[self presentModalViewController:navigationController animated:YES];
	[placeAddViewController release];
	[navigationController release];
}


#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
	[self regionDidChangeToLatitude:_mapView.region.center.latitude longitude:_mapView.region.center.longitude];
}

- (void)regionDidChangeToLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
	NSInteger newCellId = [Utils getCellIdWithLatitude:latitude longitude:longitude];
	NSLog( @"newCellId : %d", newCellId );
	if( _lastCellId != newCellId )
	{
		[self clear];
		[_mapView removeAnnotations:_mapView.annotations];
		
		[self loadCellId:newCellId]; // 가운데
		[self loadCellId:newCellId - 1 + 36000]; // 왼쪽 위
		[self loadCellId:newCellId + 36000]; // 위
		[self loadCellId:newCellId + 1 + 36000]; // 오른쪽 위
		[self loadCellId:newCellId + 1]; // 오른쪽
		[self loadCellId:newCellId + 1 - 36000]; // 오른쪽 아래
		[self loadCellId:newCellId - 36000]; // 아래
		[self loadCellId:newCellId - 1 - 36000]; // 왼쪽 아래
		[self loadCellId:newCellId - 1]; // 왼쪽
		
		[self.loader startLoading];
		_lastCellId = newCellId;
	}
}

- (void)loadCellId:(NSInteger)cellId
{
	[self.loader addTokenWithTokenId:0 url:[NSString stringWithFormat:@"%@?cell_id=%d", API_PLACE_LIST, cellId] method:ImTravelingLoaderMethodGET params:nil];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if( annotation == _mapView.userLocation )
	{
		return nil;
	}
	
	static NSString *pinId = @"pinId";
	Pin *pin = (Pin *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinId];
	if( pin == nil )
	{
		pin = [[[Pin alloc] initWithAnnotation:annotation reuseIdentifier:pinId] autorelease];
	}
	
	pin.userInteractionEnabled = YES;
	pin.canShowCallout = YES;
	
	UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pin.rightCalloutAccessoryView = selectButton;
	
	return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	[self selectPlace:(Place *)view.annotation];
}


#pragma mark -
#pragma mark UIPullDownWebViewController

- (void)reloadWebView
{
	[self webViewDidFinishReloading];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	
	// 장소가 없을 경우
	if( [self isError:json] )
	{
//		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"NO_PLACES_MSG", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSArray *places = [json objectForKey:@"result"];
	for( NSDictionary *p in places )
	{
		Place *place = [[Place alloc] init];
		place.placeId = [[p objectForKey:@"place_id"] integerValue];
		place.name = [p objectForKey:@"place_name"];
		place.latitude = [[p objectForKey:@"latitude"] doubleValue];
		place.longitude = [[p objectForKey:@"longitude"] doubleValue];
		place.category = [[p objectForKey:@"category"] integerValue];
		
		[_places setObject:place forKey:[NSNumber numberWithInteger:place.placeId]];
		[self addPlace:place];
		
		[place release];
	}
	
	[self stopBusy];
}


#pragma mark -
#pragma mark WebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"select_place"] )
	{
		NSLog( @"place_id : %@", [arguments objectAtIndex:0] );
		[self selectPlace:[_places objectForKey:[NSNumber numberWithInteger:[[arguments objectAtIndex:0] integerValue]]]];
	}
}

- (void)selectPlace:(Place *)place
{
	_shareViewController.selectedPlace = place;
	[_shareViewController updatePlaceLabelText];
	
	_placeSelected = YES;
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self search:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	// 텍스트 내용이 마지막으로 변경된 후 0.5초 후에 검색
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(search:) withObject:searchText afterDelay:0.5];
}

- (void)search:(NSString *)keyword
{
	[self clear];
	
	// 모든 장소들을 보여주기
	if( keyword.length == 0 )
	{
		for( NSNumber *placeId in _places )
		{
			Place *place = [_places objectForKey:placeId];
			[self addPlace:place];
		}
	}
	else
	{
		for( NSNumber *placeId in _places )
		{
			Place *place = [_places objectForKey:placeId];
			if( [place.name rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound )
			{
				[self addPlace:place];
			}
		}
	}
}

- (void)keyboardDidShow
{
	webView.frame = CGRectMake( 0, 44, 320, 156 );
}

- (void)keyboardWillHide
{
	webView.frame = CGRectMake( 0, 44, 320, 372 );
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addPlace:(Place *)place
{
	[_mapView addAnnotation:place];
	NSString *func = [NSString stringWithFormat:@"addPlace( %d, '%@', '%@' );", place.placeId, place.name, [Utils categoryForNumber:place.category]];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
//	NSLog( @"%@", func );
}

@end
