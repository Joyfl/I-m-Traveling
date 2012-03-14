//
//  TimeSelectionViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TimeSelectionViewController.h"
#import "ActionSheetDatePicker.h"
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
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		
		_shareViewController = shareViewController;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 440 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
		
		_selectedDate = [shareViewController.selectedDate copy];
		_selectedTime = [shareViewController.selectedTime copy];
		
		_currentPickerCaller = _dateCell;
		[self showPickerWithDate:_selectedDate andPickerMode:UIDatePickerModeDate];
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
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];	
	cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
	
	if( indexPath.row == 0 )
	{
		_dateCell = cell;
		cell.textLabel.text = @"Date";
		cell.detailTextLabel.text = [Utils dateWithDate:_selectedDate];
	}
	else
	{
		_timeCell = cell;
		cell.textLabel.text = @"Time";
		cell.detailTextLabel.text = [Utils timeWithDate:_selectedTime];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if( indexPath.row == 0 )
	{
		_currentPickerCaller = _dateCell;
		[self showPickerWithDate:_selectedDate andPickerMode:UIDatePickerModeDate];
	}
	
	else if( indexPath.row == 1 )
	{
		_currentPickerCaller = _timeCell;
		[self showPickerWithDate:_selectedTime andPickerMode:UIDatePickerModeTime];
	}
}


#pragma mark -
#pragma mark UIDatePicker

- (void)pickerValueChanged:(id)picker
{
	if( _currentPickerCaller == _dateCell )
	{
		_selectedDate = [picker date];
		_dateCell.detailTextLabel.text = [Utils dateWithDate:_selectedDate andTimezone:[NSTimeZone localTimeZone]];
	}
	
	else if( _currentPickerCaller == _timeCell )
	{
		_selectedTime = [picker date];
		_timeCell.detailTextLabel.text = [Utils timeWithDate:_selectedTime andTimezone:[NSTimeZone localTimeZone]];
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
