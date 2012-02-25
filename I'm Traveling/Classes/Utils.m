//
//  Utils.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Utils.h"
#import "SettingsManager.h"
#import "Const.h"

@implementation Utils

+ (BOOL)loggedIn
{
	NSString *key = SETTING_KEY_USER_ID;
	return [[SettingsManager manager] getSettingForKey:key] != nil;
}

+ (NSString *)getHtmlFromUrl:(NSString *)url
{
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)parseJSON:(NSString *)json
{
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	return [parser objectWithString:json];
}

@end
