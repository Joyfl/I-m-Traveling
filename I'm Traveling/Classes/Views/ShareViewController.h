//
//  UploadView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 24..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImTravelingViewController.h"

@interface ShareViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
	
	UIImageView *_imageTopBorder;
	UIImage *_image;
	UITableViewCell *_imageCell;
	
	UILabel *_tripLabel;
	UILabel *_placeLabel;
	
	NSDate *selectedDate;
	NSDate *selectedTime;
	UILabel *_dateButtonLabel;
	UILabel *_dateLabel;
	
	UITableViewCell *_reviewCell;
	UITextView *_reviewInput;
	
	NSMutableArray *_info;
	
	id _currentFirstResponder;
	UIButton *_dismissKeyboardButton;
}

- (id)initWithImage:(UIImage *)image;
- (void)fillDateLabelText;
- (void)textDidBeginEditting:(id)sender;

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *selectedTime;

@end
