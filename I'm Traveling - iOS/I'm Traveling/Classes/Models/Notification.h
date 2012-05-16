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

@interface Notification : NSObject
{
	NSInteger type;
	NSObject *source;
	NSObject *destination;
	NSString *imageURL;
	
	BOOL checked;
}

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, retain) NSObject *source;
@property (nonatomic, retain) NSObject *destination;
@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, assign) BOOL checked;

@end
