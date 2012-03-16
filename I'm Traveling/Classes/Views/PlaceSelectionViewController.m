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
#import "PlaceAddViewController.h"

@interface PlaceSelectionViewController()

- (void)search:(NSString *)keyword;

- (void)addPlace:(Place *)place;

@end


@implementation PlaceSelectionViewController

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		// 검색창을 위해 공간 만들어둠
		self.webView.frame = CGRectMake( 0, 50, 320, 416 - 50 );
		self.view.backgroundColor = [UIColor whiteColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = addButton;
		
		_shareViewController = shareViewController;
		
		_locationManager = [[CLLocationManager alloc] init];
		_locationManager.delegate = self;
		[_locationManager startUpdatingLocation];
		
		_places = [[NSMutableDictionary alloc] init];
		
		UITextField *searchInput = [[UITextField alloc] initWithFrame:CGRectMake( 5, 5, 310, 31 )];
		searchInput.placeholder = @"Search";
		searchInput.returnKeyType = UIReturnKeyDone;
		searchInput.delegate = self;
		[searchInput addTarget:self action:@selector(searchInputEditingChanged:) forControlEvents:UIControlEventEditingChanged];
		[self.view addSubview:searchInput];
		
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark View Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
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
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[_locationManager stopUpdatingLocation];
	
#warning temp cellid
	NSInteger newCellId = 459030704; //[Utils getCellIdWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
	if( _lastCellId != newCellId )
	{
		[self loadURL:[NSString stringWithFormat:@"%@?cell_id=%d", API_PLACE_LIST, newCellId]];
		_lastCellId = newCellId;
	}
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


- (void)loadingDidFinish:(NSString *)result
{
	[self clear];
	
	NSArray *places = [Utils parseJSON:result];
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
	}
}


#pragma mark -
#pragma mark WebView

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
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self search:textField.text];
	return YES;
}

- (void)searchInputEditingChanged:(id)sender
{
	// 텍스트 내용이 마지막으로 변경된 후 0.5초 후에 검색
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[self performSelector:@selector(search:) withObject:[sender text] afterDelay:0.5];
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


#pragma mark -
#pragma mark Javascript Functions

- (void)addPlace:(Place *)place
{
	NSString *func = [NSString stringWithFormat:@"addPlace( %d, '%@', %d );", place.placeId, place.name, place.category];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	NSLog( @"%@", func );
}

@end
