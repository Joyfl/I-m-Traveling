//
//  Utils.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface Utils : NSObject

+ (BOOL)loggedIn;
+ (NSString *)getHtmlFromUrl:(NSString *)url;
+ (id)parseJSON:(NSString *)json;
+ (NSString *)dateWithDate:(NSDate *)date;
+ (NSString *)dateWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone;
+ (NSString *)timeWithDate:(NSDate *)date;
+ (NSString *)timeWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone;
+ (NSString *)stringWithDate:(NSDate *)date andTime:(NSDate *)time;

@end
