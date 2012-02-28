//
//  PlaceSelectionViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface PlaceSelectionViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
}

@end
