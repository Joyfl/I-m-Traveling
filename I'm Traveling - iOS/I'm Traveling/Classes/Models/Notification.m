//
//  Notification.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Notification.h"

@implementation Notification

@synthesize notificationId, type, time, numSources, source, destination, imageURL, checked;

- (NSString *)sentence
{
	NSString *sentence;
	
	switch( type )
	{
		case NOTIFICATION_TYPE_LIKE:
			break;
		
		case NOTIFICATION_TYPE_COMMENT:
			break;
			
		case NOTIFICATION_TYPE_FOLLOW:
			break;
			
		case NOTIFICATION_TYPE_NEWTRIP:
			break;
			
		case NOTIFICATION_TYPE_UPLOADING:
			if( numSources == 1 )
			{
				sentence = NSLocalizedString( @"FEED_ID_UPLOADING", @"" );
			}
			else
			{
				sentence = [NSString stringWithFormat:NSLocalizedString( @"FEEDS_ARE_UPLOADING", @"" ), numSources];
			}
			break;
	}
	
	return sentence;
}

@end
