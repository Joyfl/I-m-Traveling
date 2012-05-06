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
	_settings = [[NSMutableDictionary alloc] initWithDictionary:[NSDictionary dictionaryWithContentsOfFile:[(NSString *)[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0] stringByAppendingPathComponent:@"Settings.plist"]]];
	
	if( _settings == nil )
	{
		_settings = [[NSMutableDictionary alloc] init];
		[self flush];
	}
	
	return self;
}

- (id)getSettingForKey:(id)key
{
	return [_settings objectForKey:key];
}

- (void)setSetting:(id)data forKey:(id)key
{
	[_settings setObject:data forKey:key];
}

- (void)clearSettingForKey:(id)key
{
	[_settings removeObjectForKey:key];
}

- (BOOL)flush
{
	return [_settings writeToFile:[[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) objectAtIndex:0] stringByAppendingPathComponent:@"Settings.plist"] atomically:YES];
}

- (void)dealloc
{
	[_settings dealloc];
	[super dealloc];
}

@end
