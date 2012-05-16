//
//  NotificationManager.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Uploading, Notification;

@interface NotificationManager : NSObject
{
	NSMutableArray *_uploadings;
	NSMutableArray *_notifications;
}

+ (NotificationManager *)manager;

- (void)addUploading:(Uploading *)uploading;
- (void)addNotification:(Notification *)notification;

@property (nonatomic, readonly) NSInteger numNotifications;

@end
