//
//  Uploading.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Uploading.h"

@implementation Uploading

@synthesize picture, tripId, placeId, time, latitude, longitude, nation, review, info, progress;

- (NSDictionary *)dictionary
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			picture, @"picture",
			[NSNumber numberWithInteger:tripId], @"trip_id",
			[NSNumber numberWithInteger:placeId], @"place_id",
			time, @"time",
			[NSNumber numberWithDouble:latitude], @"latitude",
			[NSNumber numberWithDouble:longitude], @"longitude",
			nation, @"nation",
			review, @"review",
			info, @"info", nil];
}

@end
