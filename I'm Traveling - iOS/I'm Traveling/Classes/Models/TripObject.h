//
//  TripObject.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripObject : NSObject
{
	NSInteger tripId;
	NSInteger userId;
	NSString *title;
	NSString *startDate;
	NSString *endDate;
	NSString *summary;
	NSInteger numFeeds;
	NSInteger firstFeedId;
	NSString *facebookAlbumId;
}

@property (nonatomic, assign) NSInteger tripId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *summary;
@property (nonatomic, assign) NSInteger numFeeds;
@property (nonatomic, assign) NSInteger firstFeedId;
@property (nonatomic, retain) NSString *facebookAlbumId;

@end
