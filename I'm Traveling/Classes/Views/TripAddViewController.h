//
//  TripAddViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@class TripListViewController;

@interface TripAddViewController : ImTravelingViewController
{
	TripListViewController *tripListViewController;
	
	UITextField *_titleInput;
	UIButton *_startDateButton;
	UIButton *_endDateButton;
	UITextView *_summaryInput;
	
	NSDate *_startDate;
	NSDate *_endDate;
	
	UIButton *_currentPickerCaller;
}

@property (nonatomic, retain) TripListViewController *tripListViewController;

@end
