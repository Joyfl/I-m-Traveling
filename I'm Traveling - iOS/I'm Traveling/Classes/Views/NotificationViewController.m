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
#import "Utils.h"
#import "ImTravelingBarButtonItem.h"

@implementation NotificationViewController

- (id)initWithUserId:(NSInteger)userId
{
	if( self = [super init] )
	{
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		
		_userId = userId;
		_notifications = [[NSMutableArray alloc] init];
		[self loadPage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark NavigationBarSelectors

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ImTravelingWebView

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self reloadWebView];
}

- (void)reloadWebView
{
	NSLog( @"NotificationViewController viewDidAppear" );
	
	[self clear];
	
	Notification *uploadingNotification = [[NotificationManager manager] uploadingNotification];
	if( uploadingNotification )
	{
		NSLog( @"업로드중인 새로운 피드가 있음!!" );
		[self addNotification:uploadingNotification];
	}
	
	[self.loader addTokenWithTokenId:0 url:[NSString stringWithFormat:@"%@?user_id=%d", API_NOTIFICATION, _userId] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader startLoading];
	
	[self webViewDidFinishReloading];
}


#pragma mark -
#pragma mark ImTravelingLoaderDelegate

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [self isError:json] )
	{
		NSLog( @"[NotificationViewController]		Error : %@", token.data );
		return;
	}
	
	NSArray *result = [json objectForKey:@"result"];
	for( NSDictionary *n in result )
	{
		Notification *notification = [[Notification alloc] init];
		notification.notificationId = [[n objectForKey:@"notification_id"] integerValue];
		notification.source = [n objectForKey:@"src_id"];
		notification.userId = [[n objectForKey:@"dst_id"] integerValue];
		notification.userName = [n objectForKey:@"dst_name"];
		notification.numOthers = [[n objectForKey:@"other_counts"] integerValue];
		notification.imageURL = [NSString stringWithFormat:@"%@%d.jpg", API_PROFILE_IMAGE, notification.userId];
		notification.checked = [[n objectForKey:@"other_counts"] integerValue] == 1;
		
		NSString *type = [n objectForKey:@"type"];
		if( [type isEqualToString:@"feed_like"] )
		{
			notification.type = NOTIFICATION_TYPE_LIKE;
		}
		else if( [type isEqualToString:@"feed_comment"] )
		{
			notification.type = NOTIFICATION_TYPE_COMMENT;
		}
		else if( [type isEqualToString:@"follow"] )
		{
			notification.type = NOTIFICATION_TYPE_FOLLOW;
		}
		
		[self addNotification:notification];
	}
}


#pragma mark -
#pragma mark Javascript Functions

- (void)addNotification:(Notification *)notification
{
	[_notifications addObject:notification];
	
	NSString *func = [NSString stringWithFormat:@"addNotification( %d, '%@', '%@', '%@' )",
					  notification.notificationId,
					  /*notification.imageURL*/@"http://imtraveling.joyfl.kr/profile/2.jpg",
					  notification.sentence,
					  @"지금"];
	[self.webView stringByEvaluatingJavaScriptFromString:func];
}

@end
