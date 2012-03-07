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

@interface PlaceSelectionViewController()

- (void)search:(NSString *)keyword;

- (void)addPlace:(Place *)place;
- (void)clearPlaceList;

@end


@implementation PlaceSelectionViewController

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		// 검색창을 위해 공간 만들어둠
		self.webView.frame = CGRectMake( 0, 50, 320, self.webView.frame.size.height - 50 );
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
		[self.view addSubview:searchInput];
		
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Bar Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)addButtonDidTouchUpInside
{
	
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	[_locationManager stopUpdatingLocation];
	
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
	NSLog( @"%@", result );
	NSArray *places = [Utils parseJSON:result];
	for( NSDictionary *p in places )
	{
		Place *place = [[Place alloc] init];
		place.placeId = [[p objectForKey:@"id"] integerValue];
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
	if( message == @"select_place" )
	{
		NSLog( @"place_id : %@", [arguments objectAtIndex:0] );
	}
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	[self search:textField.text];
	return YES;
}

- (void)search:(NSString *)keyword
{
	if( keyword.length == 0 )
		return;
	
	[self clearPlaceList];
	
	for( NSNumber *placeId in _places )
	{
		Place *place = [_places objectForKey:placeId];
		if( [place.name rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound )
		{
			[self addPlace:place];
		}
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addPlace:(Place *)place
{
	NSString *func = [NSString stringWithFormat:@"addPlace( '%@', %d );", place.name, place.category];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
	NSLog( @"%@", func );
}

- (void)clearPlaceList
{
	[self.webView stringByEvaluatingJavaScriptFromString:@"clearPlaceList();"];
}

@end
