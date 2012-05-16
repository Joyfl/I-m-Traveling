//
//  NotificationManager.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "NotificationManager.h"
#import "UploadManager.h"
#import "Notification.h"

@implementation NotificationManager

+ (NotificationManager *)manager
{
	static NotificationManager *manager;
	
	if( !manager )
	{
		manager = [[NotificationManager alloc] init];
	}
	
	return manager;
}

- (id)init
{
	if( self = [super init] )
	{
		_notifications = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)addNotification:(Notification *)notification
{
	[_notifications addObject:notification];
}

- (NSInteger)numNotifications
{
	return _notifications.count + [UploadManager manager].numUploadings ? 1 : 0;
}

@end
