//
//  PlaceAddViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 15..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "PlaceAddViewController.h"
#import "Const.h"
#import "QuartzCore/CALayer.h"
#import "Utils.h"
#import "Place.h"
#import "PlaceSelectionViewController.h"
#import "ImTravelingBarButtonItem.h"

#define	MAPVIEW_Y				-158
#define UPDOWN_BUTTON_Y_MIN		62
#define UPDOWN_BUTTON_Y_MAX		378
#define PIN_Y_MIN				24
#define PIN_Y_MAX				182


@implementation PlaceAddViewController

@synthesize placeSelectionViewController;

- (id)init
{
	if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_PLACE_ADD", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *doneButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"ADD", @"" ) target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, MAPVIEW_Y, 320, WEBVIEW_HEIGHT_NO_TABBAR )];
		[_mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
		[self.view addSubview:_mapView];
		
		UIImageView *googleLogo = [self googleLogo];
		[googleLogo removeFromSuperview];
		googleLogo.frame = CGRectMake( 6, 5, googleLogo.frame.size.width, googleLogo.frame.size.height );
		[self.view addSubview:googleLogo];
		
		_pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
		_pin.frame = CGRectMake( 150, PIN_Y_MIN, 21, 32 );
		[self.view addSubview:_pin];
		[_pin release];
		
		_upDownButton = [[UIButton buttonWithType:UIButtonTypeContactAdd] retain];
		_upDownButton.frame = CGRectMake( 0, UPDOWN_BUTTON_Y_MIN, 40, 40 );
		[_upDownButton addTarget:self action:@selector(upDownButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_upDownButton];
		
		_container = [[UIView alloc] initWithFrame:CGRectMake( 0, 100, 320, 100 )];
		_container.layer.shadowOffset = CGSizeMake( 0, -2 );
		_container.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
		_container.layer.shadowOpacity = 0.5;
		_container.layer.shadowRadius = 2;
		[self.view addSubview:_container];
		
		UIImageView *nameInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"place_add_name_bg.png"]];
		nameInputBackground.frame = CGRectMake( 0, 0, 320, 50 );
		[_container addSubview:nameInputBackground];
		[nameInputBackground release];
		
		_nameInput = [[UITextField alloc] initWithFrame:CGRectMake( 20, 12, 282, 31 )];
		_nameInput.placeholder = NSLocalizedString( @"PLACE_NAME", @"" );
		_nameInput.font = [UIFont boldSystemFontOfSize:15];
		_nameInput.layer.shadowOffset = CGSizeMake( 0, 1 );
		_nameInput.layer.shadowColor = [UIColor whiteColor].CGColor;
		_nameInput.layer.shadowOpacity = 0.5;
		_nameInput.layer.shadowRadius = 0;
		[_nameInput setValue:[UIColor colorWithRed:217/255.0 green:183/255.0 blue:155/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
		[_nameInput addTarget:self action:@selector(nameInputEditingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
		[_nameInput becomeFirstResponder];
		[_container addSubview:_nameInput];
		
		UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 50, 320, 50 )];
		[categoryButton setBackgroundImage:[UIImage imageNamed:@"place_add_category_bg.png"] forState:UIControlStateNormal];
		[categoryButton addTarget:self action:@selector(categoryButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_container addSubview:categoryButton];
		[categoryButton release];
		
		_categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20, 10, 282, 31 )];
		_categoryLabel.backgroundColor = [UIColor clearColor];
		_categoryLabel.font = [UIFont boldSystemFontOfSize:15];
		_categoryLabel.textColor = [UIColor colorWithRed:207/255.0 green:173/255.0 blue:145/255.0 alpha:1];
		_categoryLabel.text = NSLocalizedString( @"SELECT_CATEGORY", @"" );
		_categoryLabel.shadowOffset = CGSizeMake( 0, 1 );
		_categoryLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
		[categoryButton addSubview:_categoryLabel];
		
		_selectedCategory = -1;
		
		_picker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, 200, 320, 250 )];
		_picker.delegate = self;
		_picker.dataSource = self;
		_picker.showsSelectionIndicator = YES;
		[self.view addSubview:_picker];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Item Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonDidTouchUpInside
{
	if( _nameInput.text.length == 0 )
	{
		[self showOopsAlertWithMessage:NSLocalizedString( @"ENTER_PLACE_NAME", @"" )];
		return;
	}
	
	if( _selectedCategory == -1 )
	{
		[self showOopsAlertWithMessage:NSLocalizedString( @"PLEASE_SELECT_CATEGORY", @"" )];
		return;
	}
	
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	[params setObject:[NSNumber numberWithInt:[Utils userId]] forKey:@"user_id"];
	[params setObject:[Utils email] forKey:@"email"];
	[params setObject:[Utils password] forKey:@"password"];
	[params setObject:_nameInput.text forKey:@"place_name"];
	[params setObject:[NSNumber numberWithFloat:_mapView.region.center.latitude] forKey:@"latitude"];
	[params setObject:[NSNumber numberWithFloat:_mapView.region.center.longitude] forKey:@"longitude"];
	[params setObject:_categoryLabel.text forKey:@"category"];
	[self.loader addTokenWithTokenId:0 url:API_PLACE_ADD method:ImTravelingLoaderMethodGET params:params];
	[self.loader startLoading];
	[params release];
}


#pragma mark -
#pragma mark Selectors

- (void)upDownButtonDidTouchUpInside
{
	if( _mapView.frame.origin.y == MAPVIEW_Y )
	{
		[_nameInput resignFirstResponder];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.25];
		
		CGRect frame = _mapView.frame;
		frame.origin.y = 0;
		_mapView.frame = frame;
		
		frame = _pin.frame;
		frame.origin.y = PIN_Y_MAX;
		_pin.frame = frame;
		
		frame = _upDownButton.frame;
		frame.origin.y = UPDOWN_BUTTON_Y_MAX;
		_upDownButton.frame = frame;
		
		frame = _container.frame;
		frame.origin.y = WEBVIEW_HEIGHT_NO_TABBAR;
		_container.frame = frame;
		
		frame = _picker.frame;
		frame.origin.y = WEBVIEW_HEIGHT_NO_TABBAR;
		_picker.frame = frame;
		
		[UIView commitAnimations];
	}
	else
	{
		if( _wasEditingName )
			[_nameInput becomeFirstResponder];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.25];
		
		CGRect frame = _mapView.frame;
		frame.origin.y = MAPVIEW_Y;
		_mapView.frame = frame;
		
		frame = _pin.frame;
		frame.origin.y = PIN_Y_MIN;
		_pin.frame = frame;
		
		frame = _upDownButton.frame;
		frame.origin.y = UPDOWN_BUTTON_Y_MIN;
		_upDownButton.frame = frame;
		
		frame = _container.frame;
		frame.origin.y = 100;
		_container.frame = frame;
		
		frame = _picker.frame;
		frame.origin.y = 200;
		_picker.frame = frame;
		
		[UIView commitAnimations];
	}
}

- (void)nameInputEditingDidBegin
{
	_wasEditingName = YES;
}

- (void)categoryButtonDidTouchUpInside
{
	[_nameInput resignFirstResponder];
	_wasEditingName = NO;
	
	if( _selectedCategory == -1 )
	{
		[self pickerView:_picker didSelectRow:0 inComponent:0];
	}
}


#pragma mark -
#pragma mark UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 13;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [placeSelectionViewController categoryForNumber:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_selectedCategory = row;
	_categoryLabel.textColor = [UIColor blackColor];
	_categoryLabel.text = [placeSelectionViewController categoryForNumber:row];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [self isError:json] )
	{
		NSLog( @"Error!" );
		return;
	}
	
	Place *place = [[Place alloc] init];
	place.placeId = [[json objectForKey:@"result"] integerValue];
	place.name = _nameInput.text;
	place.latitude = _mapView.userLocation.coordinate.latitude;
	place.longitude = _mapView.userLocation.coordinate.longitude;
	[placeSelectionViewController selectPlace:place];
	[place release];
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Utils

- (UIImageView *)googleLogo
{
	for( UIView *subview in _mapView.subviews )
	{
		if( [subview isMemberOfClass:[UIImageView class]] )
			return (UIImageView *)subview;
	}
	
	return nil;
}

@end
