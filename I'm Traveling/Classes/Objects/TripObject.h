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
	NSInteger feedId;
	NSInteger userId;
	NSString *title;
	NSString *startDate;
	NSString *endDate;
	NSString *review;
	NSInteger numFeeds;
}

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, assign) NSInteger numFeeds;

@end
