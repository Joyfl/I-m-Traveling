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
+ (NSInteger)userId;
+ (NSString *)userName;
+ (NSString *)email;
+ (NSString *)password;
+ (NSString *)getHtmlFromUrl:(NSString *)url;
+ (id)parseJSON:(NSString *)json;
+ (NSString *)writeJSON:(id)object;
+ (NSInteger)getCellIdWithLatitude:(double)latitude longitude:(double)longitude;
+ (NSString *)dateWithDate:(NSDate *)date;
+ (NSString *)dateWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone;
+ (NSString *)onlyDateWithDate:(NSDate *)date;
+ (NSString *)timeWithDate:(NSDate *)date;
+ (NSString *)timeWithDate:(NSDate *)date andTimezone:(NSTimeZone *)timezone;
+ (NSString *)stringWithDate:(NSDate *)date andTime:(NSDate *)time;
+ (NSString *)dateStringForUpload:(NSDate *)date;

@end
