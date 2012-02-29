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
	[_shareViewController fillDateLabelText];
	
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
		[ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:_selectedDate target:self action:@selector(dateDidSelected:element:) origin:tableView];
	else
		[ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeTime selectedDate:_selectedTime target:self action:@selector(timeDidSelected:element:) origin:tableView];
	
	
}

- (void)dateDidSelected:(NSDate *)selectedDate element:(id)element
{
	_selectedDate = [selectedDate copy];
	_dateCell.detailTextLabel.text = [Utils dateWithDate:selectedDate andTimezone:[NSTimeZone localTimeZone]];
}

- (void)timeDidSelected:(NSDate *)selectedDate element:(id)element
{
	_selectedTime = [selectedDate copy];
	_timeCell.detailTextLabel.text = [Utils timeWithDate:selectedDate andTimezone:[NSTimeZone localTimeZone]];
}

@end
