//
//  AccountsViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 6. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface AccountsViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
}

@end
