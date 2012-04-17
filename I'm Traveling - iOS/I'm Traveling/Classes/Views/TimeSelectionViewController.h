//
//  TimeSelectionViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"

@interface TimeSelectionViewController : UIViewController
{
	ShareViewController *_shareViewController;
	
	UITableView *_tableView;
	
	NSDate *_selectedDate;
	NSDate *_selectedTime;
	
	UIButton *_dateButton;
	UILabel *_dateLabel;
	
	UIButton *_timeButton;
	UILabel *_timeLabel;
	
	UIButton *_currentPickerCaller;
}

- (id)initWithShareViewController:(ShareViewController *)shareViewController;

@end
