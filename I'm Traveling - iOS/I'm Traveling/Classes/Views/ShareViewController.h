//
//  UploadView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 24..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImTravelingViewController.h"
#import "TripObject.h"
#import "Place.h"

@interface ShareViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
	UITableView *_tableView;
	
	UIImageView *_imageTopBorder;
	UIImage *_image;
	UITableViewCell *_imageCell;
	
	UILabel *_tripLabel;
	
	Place *selectedPlace;
	UILabel *_placeLabel;
	
	NSDate *selectedDate;
	NSDate *selectedTime;
	UILabel *_dateButtonLabel;
	UILabel *_dateLabel;
	
	UITableViewCell *_reviewCell;
	UITextView *_reviewInput;
	
	NSMutableArray *_info;
	
	BOOL _saveToLocal;
	
	id _currentFirstResponder;
	UIButton *_keyboardHideButton;
	
	BOOL _uploading;
}

- (id)initWithImage:(UIImage *)image;
- (void)updateTripLabelText;
- (void)updatePlaceLabelText;
- (void)updateDateLabelText;
- (void)textDidBeginEditting:(id)sender;

@property (nonatomic, retain) TripObject *selectedTrip;
@property (nonatomic, retain) Place *selectedPlace;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *selectedTime;

@end
