//
//  SettingsManager.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 22..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

+ (SettingsManager *)manager
{
	static SettingsManager *manager;
	
	if( !manager )
	{
		manager = [[SettingsManager alloc] init];
	}
	
	return manager;
}

- (id)init
{
//	settings = [NSMutableDictionary dictionaryWithContentsOfFile:[(NSString *)[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0] stringByAppendingPathComponent:@"Settings.plist"]];
	
	if( settings == nil )
	{
		settings = [[NSMutableDictionary alloc] init];
		[self flush];
	}
	
	NSLog( @"%@", settings );
	
	return self;
}

- (id)getSettingForKey:(NSString *)key
{
	return [settings objectForKey:key];
}

- (void)setSetting:(id)data forKey:(NSString *)key
{
	[settings setObject:data forKey:key];
}

- (BOOL)flush
{
	return [settings writeToFile:[[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0] stringByAppendingPathComponent:@"Settings.plist"] atomically:YES];
}

- (void)dealloc
{
	[settings dealloc];
	[super dealloc];
}

@end
