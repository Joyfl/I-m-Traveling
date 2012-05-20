//
//  UploadManager.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 17..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImTravelingLoader.h"

#define kTripLoadingFinishNotification	@"kTripLoadingFinishNotification"

@class Uploading;

@interface UploadManager : NSObject <ImTravelingLoaderDelegate>
{
	NSMutableArray *_trips;
	NSMutableArray *_feeds;
	
	ImTravelingLoader *_tripUploader;
	ImTravelingLoader *_feedUploader;
}

+ (UploadManager *)manager;
- (NSInteger)addTrip:(NSMutableDictionary *)trip;
- (void)addFeed:(NSMutableDictionary *)feed;

@property (nonatomic, readonly) NSInteger numUploadings;
@property (nonatomic, readonly) NSDictionary *currentUploading;

@end
