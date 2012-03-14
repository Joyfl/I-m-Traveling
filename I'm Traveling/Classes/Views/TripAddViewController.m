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

@interface TripAddViewController()

- (void)showPicker;

@end


@implementation TripAddViewController

@synthesize tripListViewController;

- (id)init
{
	if( self = [super init] )
	{
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		
		
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
//	[self loadURL:<#(NSString *)#> withData:<#(NSDictionary *)#>];
}


#pragma mark -
#pragma mark ImTravelingViewController

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *json = [Utils parseJSON:result];
	
	// ShareViewController - TripListViewController에서 여행 추가 버튼을 눌러 들어온 경우
	// 여행을 추가하면 추가한 여행이 자동으로 선택되어지도록 한다.
	if( tripListViewController != nil )
	{
		// Upload할 때에는 trip id밖에 필요가 없음.
		TripObject *trip = [[TripObject alloc] init];
		trip.tripId = [[json objectForKey:@"trip_id"] integerValue];
		[tripListViewController selectTrip:trip];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Selectors

- (void)startDateButtonDidTouchUpInside
{
	_currentPickerCaller = _startDateButton;
	[self showPicker];
}

- (void)endDateButtonDidTouchUpInside
{
	_currentPickerCaller = _endDateButton;
	[self showPicker];
}

- (void)pickerValueChanged:(id)picker
{
	[_currentPickerCaller setTitle:[Utils dateWithDate:[picker date]] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Utils

- (void)showPicker
{
	[_titleInput resignFirstResponder];
	[_summaryInput resignFirstResponder];
	
	UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake( 0, 200, 320, 214 )];
	picker.datePickerMode = UIDatePickerModeDate;
	[picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
}

@end
