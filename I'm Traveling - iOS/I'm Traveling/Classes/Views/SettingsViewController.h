//
//  SettingsViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>
{
	UITableView *_tableView;
}

@end
