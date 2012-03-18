//
//  TripAddViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TripAddViewController.h"
#import "Utils.h"
#import "TripObject.h"
#import "TripListViewController.h"
#import "Const.h"
#import "ImTravelingBarButtonItem.h"

@interface TripAddViewController()

- (void)showPickerWithDate:(NSDate *)date;

@end


@implementation TripAddViewController

@synthesize tripListViewController;

- (id)init
{
	if( self = [super init] )
	{
		self.navigationItem.title = @"Start a new trip";
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithTitle:@"Cancel" target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *doneButton = [[ImTravelingBarButtonItem alloc] initWithTitle:@"Add" target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		
		_titleInput = [[UITextField alloc] initWithFrame:CGRectMake( 10, 10, 300, 31 )];
		_titleInput.borderStyle = UITextBorderStyleRoundedRect;
		_titleInput.placeholder = @"Trip Title";
		[_titleInput becomeFirstResponder];
		[self.view addSubview:_titleInput];
		
		_startDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_startDateButton.frame = CGRectMake( 10, 50, 145, 31 );
		[_startDateButton setTitle:[Utils dateWithDate:[NSDate date]] forState:UIControlStateNormal];
		[_startDateButton addTarget:self action:@selector(startDateButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_startDateButton];
		
//		UILabel *label = [[UILabel alloc] init];
		
		_endDateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_endDateButton.frame = CGRectMake( 165, 50, 145, 31 );
		[_endDateButton setTitle:[Utils dateWithDate:[NSDate date]] forState:UIControlStateNormal];
		[_endDateButton addTarget:self action:@selector(endDateButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_endDateButton];
		
		UIButton *borderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		borderButton.frame = CGRectMake( 10, 90, 300, 62 );
		borderButton.enabled = NO;
		[self.view addSubview:borderButton];
		
		_summaryInput = [[UITextView alloc] initWithFrame:CGRectMake( 10, 90, 300, 62 )];
		_summaryInput.editable = YES;
		_summaryInput.backgroundColor = [UIColor clearColor];
		[self.view addSubview:_summaryInput];
		
		_startDate = [[NSDate alloc] init];
		_endDate = [[NSDate alloc] init];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Bar Selectors

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
	[data setObject:_titleInput.text forKey:@"trip_title"];
	[data setObject:[Utils dateStringForUpload:_startDate] forKey:@"start_date"];
	[data setObject:[Utils dateStringForUpload:_endDate] forKey:@"end_date"];
	[data setObject:_summaryInput.text forKey:@"summary"];
	[self loadURL:API_TRIP_ADD withData:data];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *json = [Utils parseJSON:result];
	
	// ShareViewController - TripListViewController에서 여행 추가 버튼을 눌러 들어온 경우
	// 여행을 추가하면 추가한 여행이 자동으로 선택되어지도록 한다.
	if( tripListViewController != nil && [json objectForKey:@"RESULT"] )
	{
		// Upload할 때에는 trip id와 title밖에 필요가 없음.
		TripObject *trip = [[TripObject alloc] init];
		trip.tripId = [[json objectForKey:@"RESULT"] integerValue];
		trip.title = _titleInput.text;
		[tripListViewController selectTrip:trip];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Selectors

- (void)startDateButtonDidTouchUpInside
{
	_currentPickerCaller = _startDateButton;
	[self showPickerWithDate:_startDate];
}

- (void)endDateButtonDidTouchUpInside
{
	_currentPickerCaller = _endDateButton;
	[self showPickerWithDate:_endDate];
}

- (void)pickerValueChanged:(id)picker
{
	if( _currentPickerCaller == _startDateButton )
		_startDate = [picker date];
	
	else if( _currentPickerCaller == _endDateButton )
		_endDate = [picker date];
	
	else
		return;
	
	[_currentPickerCaller setTitle:[Utils dateWithDate:[picker date]] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Utils

- (void)showPickerWithDate:(NSDate *)date
{
	[_titleInput resignFirstResponder];
	[_summaryInput resignFirstResponder];
	
	UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake( 0, 200, 320, 214 )];
	picker.datePickerMode = UIDatePickerModeDate;
	picker.date = date;
	[picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
	[picker release];
}

@end
