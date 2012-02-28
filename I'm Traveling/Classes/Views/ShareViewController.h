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
	UIImage *_image;
	NSDictionary *_info;
	
	UITableViewCell *_tripCell;
	UITableViewCell *_dateCell;
	UITableViewCell *_placeCell;
	
	NSDate *selectedDate;
	NSDate *selectedTime;
}

- (id)initWithImage:(UIImage *)image;

- (void)fillDateCellDetailText;

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDate *selectedTime;

@end
