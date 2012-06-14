//
//  FacebookManager.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 6. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FacebookManager.h"
#import "SettingsManager.h"
#import "Const.h"

@implementation FacebookManager

@synthesize facebook;

+ (FacebookManager *)manager
{
	static FacebookManager *manager;
	
	if( !manager )
	{
		manager = [[FacebookManager alloc] init];
	}
	
	return manager;
}

- (id)init
{
	if( self = [super init] )
	{
		facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
		SettingsManager *manager = [SettingsManager manager];
		if( [[manager getSettingForKey:SETTING_KEY_FACEBOOK_LINKED] boolValue] )
		{
			facebook.accessToken = [manager getSettingForKey:SETTING_KEY_FACEBOOK_ACCESS_TOKEN];
			facebook.expirationDate = [manager getSettingForKey:SETTING_KEY_FACEBOOK_EXPIRATION_DATE];
		}
	}
	
	return self;
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)storeAccessToken:(NSString *)accessToken andExpirationDate:(NSDate *)expirationDate
{
	SettingsManager *manager = [SettingsManager manager];
	[manager setSetting:[NSNumber numberWithBool:YES] forKey:SETTING_KEY_FACEBOOK_LINKED];
	[manager setSetting:accessToken forKey:SETTING_KEY_FACEBOOK_ACCESS_TOKEN];
	[manager setSetting:expirationDate	forKey:SETTING_KEY_FACEBOOK_EXPIRATION_DATE];
	[manager flush];
}

- (void)fbDidLogin
{
	[self storeAccessToken:facebook.accessToken andExpirationDate:facebook.expirationDate];
}

- (void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt
{
	NSLog( @"token extended" );
	[self storeAccessToken:accessToken andExpirationDate:expiresAt];
}


#pragma mark -
#pragma mark FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
	NSLog( @"receive response" );
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
	NSLog( @"Fail!!" );
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
	NSLog( @"FBReulst : %@", result );
}


#pragma mark -
#pragma mark Graph API

- (void)makeAlbumWithName:(NSString *)name andDescription:(NSString *)desc
{
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   name, @"name",
								   desc, @"message", nil];
	[facebook requestWithGraphPath:@"me/albums" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)postPhoto
{
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Test", @"message", nil];
	[facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

@end
