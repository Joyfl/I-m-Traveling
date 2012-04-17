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
	UITextView *_summaryInput;
}

@property (nonatomic, retain) TripListViewController *tripListViewController;

@end
