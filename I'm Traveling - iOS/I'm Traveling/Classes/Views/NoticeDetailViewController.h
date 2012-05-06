//
//  NoticeDetailViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface NoticeDetailViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource>
{
	UITableView *_tableView;
	NSString *_noticeTitle;
	NSString *_noticeContent;
}

- (id)initWithNoticeId:(NSInteger)noticeId;

@end
