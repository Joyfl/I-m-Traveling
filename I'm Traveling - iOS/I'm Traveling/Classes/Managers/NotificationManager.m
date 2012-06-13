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
#import "Utils.h"

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

- (Notification *)uploadingNotification
{
	NSInteger numUploadings = [UploadManager manager].numUploadings;
	if( numUploadings == 0 ) return nil;
	
	Notification *notification = [[Notification alloc] init];
	notification.type = NOTIFICATION_TYPE_UPLOADING;
	notification.numOthers = numUploadings - 1;
	notification.source = [UploadManager manager].currentUploading;
	
	UIImage *picture = [[UploadManager manager].currentUploading objectForKey:@"picture"];
	UIGraphicsBeginImageContext( CGSizeMake( 50, 50 ) );
	[picture drawInRect:CGRectMake( 0, 0, 50, 50 )];
	UIImage *scaledPicture = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	notification.imageURL = [NSString stringWithFormat:@"data:image/png;base64,%@", [Utils base64FromImage:scaledPicture]];
	
	return notification;
}

- (Notification *)notificationAtIndex:(NSInteger)index
{
	return [_notifications objectAtIndex:index];
}

- (NSInteger)numNotifications
{
	return _notifications.count + [UploadManager manager].numUploadings ? 1 : 0;
}

@end
