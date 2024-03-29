//
//  Uploading.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPLOADING_PROGRESS_PENDING		0
#define UPLOADING_PROGRESS_UPLOADING	1

@interface Uploading : NSObject
{
	UIImage *picture;
	NSInteger tripId;
	NSInteger placeId;
	NSString *time;
	double latitude;
	double longitude;
	NSString *nation;
	NSString *review;
	NSString *info;
	
	NSInteger progress;
}

@property (nonatomic, retain) UIImage *picture;
@property (nonatomic, assign) NSInteger tripId;
@property (nonatomic, assign) NSInteger placeId;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSString *nation;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, retain) NSString *info;
@property (nonatomic, assign) NSInteger progress;

- (NSDictionary *)dictionary;

@end
