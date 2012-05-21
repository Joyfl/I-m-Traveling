//
//  Notification.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NOTIFICATION_TYPE_LIKE			0
#define NOTIFICATION_TYPE_COMMENT		1
#define NOTIFICATION_TYPE_FOLLOW		2
#define NOTIFICATION_TYPE_NEWTRIP		3
#define NOTIFICATION_TYPE_UPLOADING		4

@interface Notification : NSObject
{
	NSInteger notificationId;
	NSInteger type;
	NSDate *time;
	NSInteger numSources;
	NSObject *source;
	NSObject *destination;
	NSString *imageURL;
	
	BOOL checked;
}

@property (nonatomic, assign) NSInteger notificationId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, assign) NSInteger numSources;
@property (nonatomic, retain) NSObject *source;
@property (nonatomic, retain) NSObject *destination;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, readonly) NSString *sentence;

@end
