//
//  TimeSelectionViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TimeSelectionViewController.h"
#import "ImTravelingBarButtonItem.h"
#import "Utils.h"

@interface TimeSelectionViewController()

- (void)showPickerWithDate:(NSDate *)date andPickerMode:(UIDatePickerMode)mode;

@end


@implementation TimeSelectionViewController

- (id)initWithShareViewController:(ShareViewController *)shareViewController
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		self.navigationItem.title = @"Select a date";
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithTitle:@"Cancel" target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *doneButton = [[ImTravelingBarButtonItem alloc] initWithTitle:@"Add" target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		_shareViewController = shareViewController;
		
		
		// Date Button
		_dateButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 0, 320, 50 )];
		[_dateButton setBackgroundImage:[UIImage imageNamed:@"time_select_date_bg.png"] forState:UIControlStateNormal];
		[_dateButton addTarget:self action:@selector(dateButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_dateButton];
		
		UILabel *dateButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20, 8, 50, 31 )];
		dateButtonLabel.font = [UIFont boldSystemFontOfSize:15];
		dateButtonLabel.text = @"Date";
		dateButtonLabel.textColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
		dateButtonLabel.backgroundColor = [UIColor clearColor];
		[_dateButton addSubview:dateButtonLabel];
		[dateButtonLabel release];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 8, 220, 31 )];
		_dateLabel.font = [UIFont systemFontOfSize:15];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.text = [Utils dateWithDate:[NSDate date] andTimezone:[NSTimeZone localTimeZone]];
		_dateLabel.textColor = [UIColor colorWithRed:0.18 green:0.16 blue:0.21 alpha:1];
		[_dateButton addSubview:_dateLabel];
		
		
		// Time Button
		_timeButton = [[UIButton alloc] initWithFrame:CGRectMake( 0, 50, 320, 50 )];
		[_timeButton setBackgroundImage:[UIImage imageNamed:@"time_select_time_bg.png"] forState:UIControlStateNormal];
		[_timeButton addTarget:self action:@selector(timeButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_timeButton];
		
		UILabel *timeButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake( 20, 8, 50, 31 )];
		timeButtonLabel.font = [UIFont boldSystemFontOfSize:15];
		timeButtonLabel.text = @"Time";
		timeButtonLabel.textColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:1];
		timeButtonLabel.backgroundColor = [UIColor clearColor];
		[_timeButton addSubview:timeButtonLabel];
		[timeButtonLabel release];
		
		_timeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 80, 8, 220, 31 )];
		_timeLabel.font = [UIFont systemFontOfSize:15];
		_timeLabel.backgroundColor = [UIColor clearColor];
		_timeLabel.text = [Utils timeWithDate:[NSDate date] andTimezone:[NSTimeZone localTimeZone]];
		_timeLabel.textColor = [UIColor colorWithRed:0.18 green:0.16 blue:0.21 alpha:1];
		[_timeButton addSubview:_timeLabel];
		
		
		_selectedDate = [shareViewController.selectedDate copy];
		_selectedTime = [shareViewController.selectedTime copy];
		
		[_dateButton sendActionsForControlEvents:UIControlEventTouchUpInside];
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
	_shareViewController.selectedDate = _selectedDate;
	_shareViewController.selectedTime = _selectedTime;
	[_shareViewController updateDateLabelText];
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Selectors

- (void)dateButtonDidTouchUpInside
{
	_currentPickerCaller = _dateButton;
	[self showPickerWithDate:_selectedDate andPickerMode:UIDatePickerModeDate];
}

- (void)timeButtonDidTouchUpInside
{
	_currentPickerCaller = _timeButton;
	[self showPickerWithDate:_selectedTime andPickerMode:UIDatePickerModeTime];
}


#pragma mark -
#pragma mark UIDatePicker

- (void)pickerValueChanged:(id)picker
{
	if( _currentPickerCaller == _dateButton )
	{
		_selectedDate = [picker date];
		_dateLabel.text = [Utils dateWithDate:_selectedDate andTimezone:[NSTimeZone localTimeZone]];
	}
	
	else if( _currentPickerCaller == _timeButton )
	{
		_selectedTime = [picker date];
		_timeLabel.text = [Utils timeWithDate:_selectedTime andTimezone:[NSTimeZone localTimeZone]];
	}
}


#pragma mark -
#pragma mark Utils

- (void)showPickerWithDate:(NSDate *)date andPickerMode:(UIDatePickerMode)mode
{
	UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake( 0, 200, 320, 214 )];
	picker.datePickerMode = mode;
	picker.date = date;
	[picker addTarget:self action:@selector(pickerValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:picker];
	[picker release];
}

@end
