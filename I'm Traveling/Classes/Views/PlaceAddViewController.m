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


@implementation PlaceAddViewController

@synthesize placeSelectionViewController;

- (id)init
{
	if( self = [super init] )
	{
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 440 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.scrollEnabled = NO;
		[self.view addSubview:_tableView];
		
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
	[data setObject:_categoryCell.textLabel.text forKey:@"category"];
	[self loadURL:API_PLACE_ADD withData:data];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( section == 0 ) return 1;
	else if( section == 1 ) return 2;
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 0 ) return 70;
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if( indexPath.section == 0 )
	{
		_mapView = [[MKMapView alloc] init];
		_mapView.layer.cornerRadius = 8;
		_mapView.userTrackingMode = MKUserTrackingModeFollow;
		
		cell.backgroundView = _mapView;
	}
	else if( indexPath.row == 0 )
	{
		_nameInput = [[UITextField alloc] initWithFrame:CGRectMake( 20, 10, 282, 30 )];
		_nameInput.placeholder = @"Place name";
		[_nameInput becomeFirstResponder];
		[cell addSubview:_nameInput];
	}
	else
	{
		cell.textLabel.text = @"0";
		_categoryCell = cell;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.row == 1 )
	{
		[_nameInput resignFirstResponder];
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
	return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [NSString stringWithFormat:@"%d", row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	_categoryCell.textLabel.text = [NSString stringWithFormat:@"%d", row];
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
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
