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

+ (NSInteger)userId
{
	NSString *key = SETTING_KEY_USER_ID;
	return [[[SettingsManager manager] getSettingForKey:key] integerValue];
}

+ (NSString *)email
{
	NSString *key = SETTING_KEY_EMAIL;
	return [[SettingsManager manager] getSettingForKey:key];
}

// hashed password
+ (NSString *)password
{
	NSString *key = SETTING_KEY_PASSWORD;
	return [[SettingsManager manager] getSettingForKey:key];
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

+ (NSString *)writeJSON:(id)object
{
	SBJsonWriter *writer = [[SBJsonWriter alloc] init];
	return [writer stringWithObject:object];
}

+ (NSInteger)getCellIdWithLatitude:(double)latitude longitude:(double)longitude
{
	// ((ABS(ROUND(경도 + 90,2)) * 100) * 36000) + ((ABS(ROUND(위도 + 180,2)) * 100));
	return ABS( round( ( latitude + 90 ) * 100 ) / 100 ) * 100 * 36000 + ABS( round( ( longitude + 180 ) * 100 ) / 100 ) * 100;
}

+ (NSString *)dateWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateStyle = NSDateFormatterMediumStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)dateWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeZone = timezone;
	formatter.dateStyle = NSDateFormatterMediumStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)onlyDateWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"d";
	return [formatter stringFromDate:date];
}

+ (NSString *)timeWithDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeStyle = NSDateFormatterShortStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)timeWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.timeZone = timezone;
	formatter.timeStyle = NSDateFormatterShortStyle;
	return [formatter stringFromDate:date];
}

+ (NSString *)stringWithDate:(NSDate *)date andTime:(NSDate *)time
{
	NSTimeZone *timezone = [[NSTimeZone localTimeZone] autorelease];
	return [NSString stringWithFormat:@"%@\n%@", [Utils dateWithDate:date andTimezone:timezone], [Utils timeWithDate:time andTimezone:timezone]];
}

// Upload를 위한 Date 형식
+ (NSString *)dateStringForUpload:(NSDate *)date
{
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
	return [formatter stringFromDate:date];
}

@end
