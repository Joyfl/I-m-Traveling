//
//  Notification.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@synthesize notificationId, type, time, source, userId, userName, numOthers, imageURL, checked;

- (NSString *)sentence
{
	NSString *sentence;
	
	switch( type )
	{
		case NOTIFICATION_TYPE_LIKE:
			if( numOthers == 0 )
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USER_LIKE_FEED", @"" ), userName]; 
			}
			else
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USERS_LIKE_FEED", @"" ), userName, numOthers]; 
			}
			break;
		
		case NOTIFICATION_TYPE_COMMENT:
			if( numOthers == 0 )
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USER_COMMENT_FEED", @"" ), userName]; 
			}
			else
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USERS_COMMENT_FEED", @"" ), userName, numOthers]; 
			}
			break;
			
		case NOTIFICATION_TYPE_FOLLOW:
			if( numOthers == 0 )
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USER_FOLLOW_USER", @"" ), userName]; 
			}
			else
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"USERS_FOLLOW_USER", @"" ), userName, numOthers];
			}

			break;
			
		case NOTIFICATION_TYPE_NEWTRIP:
			break;
			
		case NOTIFICATION_TYPE_UPLOADING:
			if( numOthers == 0 )
			{
				sentence = NSLocalizedString( @"FEED_ID_UPLOADING", @"" );
			}
			else
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"FEEDS_ARE_UPLOADING", @"" ), numOthers + 1];
			}
			break;
	}
	
	return sentence;
}

@end
