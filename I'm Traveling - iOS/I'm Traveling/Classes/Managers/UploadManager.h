//
//  UploadManager.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 17..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImTravelingLoader.h"

@class Uploading;

@interface UploadManager : NSObject <ImTravelingLoaderDelegate>
{
	NSMutableArray *_uploadings;
	ImTravelingLoader *_loader;
}

+ (UploadManager *)manager;
- (void)addUploading:(NSDictionary *)uploading;

@property (nonatomic, readonly) NSInteger numUploadings;

@end
