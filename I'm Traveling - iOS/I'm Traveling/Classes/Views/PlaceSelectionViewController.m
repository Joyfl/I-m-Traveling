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
		
		ImTravelingBarButtonItem *addButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"ADD_PLACE", @"" ) target:self action:@selector(addButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = addButton;
		[addButton release];
		
		for( NSInteger i = 9; i > 5; i-- )
			[[self.webView.scrollView.subviews objectAtIndex:i] setHidden:YES];
		
		// search bar 때문에 높이 416에서 44를 추가로 뺌.
		self.webView.frame = CGRectMake( 0, 44, 320, 372 );
		self.webView.backgroundColor = [UIColor colorWithRed:0.960 green:0.89 blue:0.82 alpha:1.0];
		self.view.backgroundColor = [UIColor colorWithRed:0.960 green:0.89 blue:0.82 alpha:1.0];
		
		_shareViewController = shareViewController;
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		
		_places = [[NSMutableDictionary alloc] init];
		
		_searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake( 0, 0, 320, 44 )];
		_searchBar.delegate = self;
		_searchBar.placeholder = NSLocalizedString( @"PLACE_SEARCH", @"" );
		_searchBar.backgroundImage = [UIImage imageNamed:@"search_bar.png"];
		[self.view addSubview:_searchBar];
		
		category = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"category" ofType:@"plist"]];
		
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
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[_locationManager stopUpdatingLocation];
	
	NSInteger newCellId = [Utils getCellIdWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
	if( _lastCellId != newCellId )
	{
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


#pragma mark -
#pragma mark UIPullDownWebViewController

- (void)reloadWebView
{
	[_locationManager startUpdatingLocation];
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
		place.longitude = [[p objectForKey:@"latitude"] doubleValue];
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
	[_locationManager startUpdatingLocation];
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
	NSString *func = [NSString stringWithFormat:@"addPlace( %d, '%@', '%@' );", place.placeId, place.name, [self categoryForNumber:place.category]];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
//	NSLog( @"%@", func );
}


#pragma mark -
#pragma mark Getters

- (NSString *)categoryForNumber:(NSInteger)no
{
	return NSLocalizedString( [category objectAtIndex:no], @"" );
}

@end
