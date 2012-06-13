//
//  NotificationViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"

@interface NotificationViewController : UIPullDownWebViewController
{
	NSInteger _userId;
	NSMutableArray *_notifications;
}

- (id)initWithUserId:(NSInteger)userId;

@end
