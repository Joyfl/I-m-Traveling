//
//  NotificationViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationManager.h"
#import "Notification.h"
#import "Const.h"

@implementation NotificationViewController

- (id)init
{
	if( self = [super init] )
	{
		[self loadPage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark ImTravelingWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self reloadWebView];
}


- (void)reloadWebView
{
	DLog( @"NotificationViewController viewDidAppear" );
	
	[self clear];
	
	Notification *uploadingNotification = [[NotificationManager manager] uploadingNotification];
	if( uploadingNotification )
	{
		DLog( @"업로드중인 새로운 피드가 있음!!" );
		[self addNotification:uploadingNotification];
	}
	
	//	NSInteger numNotifications = [[NotificationManager manager] numNotifications];
	//	for( NSInteger i = 0; i < numNotifications; i++ )
	//	{
	//		
	//	}
	
	[self webViewDidFinishReloading];
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addNotification:(Notification *)notification
{
	NSString *func = [NSString stringWithFormat:@"addNotification( %d, '%@', '%@', '%@' )",
					  notification.notificationId,
					  notification.imageURL,
					  notification.sentence,
					  @"지금"];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
}

@end
