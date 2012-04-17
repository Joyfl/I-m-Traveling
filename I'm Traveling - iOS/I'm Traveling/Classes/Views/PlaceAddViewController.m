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


@implementation PlaceAddViewController

@synthesize placeSelectionViewController;

- (id)init
{
	if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_PLACE_ADD", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithTitle:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *doneButton = [[ImTravelingBarButtonItem alloc] initWithTitle:NSLocalizedString( @"ADD", @"" ) target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		
		_mapView = [[MKMapView alloc] initWithFrame:CGRectMake( 0, 0, 320, 100 )];
		_mapView.layer.cornerRadius = 8;
		_mapView.userTrackingMode = MKUserTrackingModeFollow;
		[self.view addSubview:_mapView];
		
		UIImageView *nameInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"place_add_name_bg.png"]];
		nameInputBackground.frame = CGRectMake( 0, 100, 320, 50 );
		[self.view addSubview:nameInputBackground];
		[nameInputBackground release];
		
		_nameInput = [[UITextField alloc] initWithFrame:CGRectMake( 20, 112, 282, 31 )];
		_nameInput.placeholder = NSLocalizedString( @"PLACE_NAME", @"" );
		_nameInput.font = [UIFont boldSystemFontOfSize:15];
		[_nameInput becomeFirstResponder];
		[self.view addSubview:_nameInput];
		
		UIButton *categoryButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 150, 320, 50 )];
		[categoryButton setBackgroundImage:[UIImage imageNamed:@"place_add_category_bg.png"] forState:UIControlStateNormal];
		[categoryButton addTarget:self action:@selector(categoryButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:categoryButton];
		
		_categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20, 10, 282, 31 )];
		_categoryLabel.backgroundColor = [UIColor clearColor];
		_categoryLabel.font = [UIFont boldSystemFontOfSize:15];
		_categoryLabel.text = @"0";
		[categoryButton addSubview:_categoryLabel];
		[categoryButton release];
		
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
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	[data setObject:[NSNumber numberWithInt:[Utils userId]] forKey:@"user_id"];
	[data setObject:[Utils email] forKey:@"email"];
	[data setObject:[Utils password] forKey:@"password"];
	[data setObject:_nameInput.text forKey:@"place_name"];
	[data setObject:[NSNumber numberWithFloat:_mapView.userLocation.coordinate.latitude] forKey:@"latitude"];
	[data setObject:[NSNumber numberWithFloat:_mapView.userLocation.coordinate.longitude] forKey:@"longitude"];
	[data setObject:_categoryLabel.text forKey:@"category"];
	[self loadURL:API_PLACE_ADD withData:data];
	[data release];
}


#pragma mark -
#pragma mark Selectors

- (void)categoryButtonDidTouchUpInside
{
	[_nameInput resignFirstResponder];
}


#pragma mark -
#pragma mark UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_categoryLabel.text = [NSString stringWithFormat:@"%d", row];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *json = [Utils parseJSON:result];
	if( [json objectForKey:@"RESULT"] )
	{
		Place *place = [[Place alloc] init];
		place.placeId = [[json objectForKey:@"RESULT"] integerValue];
		place.name = _nameInput.text;
		place.latitude = _mapView.userLocation.coordinate.latitude;
		place.longitude = _mapView.userLocation.coordinate.longitude;
		[placeSelectionViewController selectPlace:place];
		[place release];
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end