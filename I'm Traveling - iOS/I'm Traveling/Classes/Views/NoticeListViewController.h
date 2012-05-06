//
//  NoticeListViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface NoticeListViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *_notices;
	UITableView *_tableView;
}

@end
