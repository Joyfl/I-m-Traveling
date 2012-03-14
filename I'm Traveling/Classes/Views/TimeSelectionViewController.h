//
//  TimeSelectionViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"

@interface TimeSelectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	ShareViewController *_shareViewController;
	
	UITableView *_tableView;
	
	NSDate *_selectedDate;
	NSDate *_selectedTime;
	
	UITableViewCell *_dateCell;
	UITableViewCell *_timeCell;
	UITableViewCell *_currentPickerCaller;
}

- (id)initWithShareViewController:(ShareViewController *)shareViewController;

@end
