//
//  Feed.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FeedObject : NSObject <MKAnnotation>
{
	NSInteger feedId;
	NSInteger tripId;
	NSInteger userId;
	NSString *name;
	NSString *profileImageURL;
	NSString *place;
	NSString *region;
	NSString *time;
	NSString *pictureURL;
	NSString *pictureThumbURL;
	CGFloat pictureRatio;
	NSString *review;
	NSArray *info;
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	NSInteger numAllFeeds;
	NSInteger numLikes;
	NSInteger numComments;
	NSMutableArray *comments;
	
	// 모든 내용이 채워져있는지 여부
	BOOL complete;
}

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger tripId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *profileImageURL;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *pictureURL;
@property (nonatomic, retain) NSString *pictureThumbURL;
@property (nonatomic, assign) CGFloat pictureRatio;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, retain) NSArray *info;
@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) NSInteger numAllFeeds;
@property (nonatomic, assign) NSInteger numLikes;
@property (nonatomic, assign) NSInteger numComments;
@property (nonatomic, retain) NSMutableArray *comments;

@property (nonatomic, assign) BOOL complete;

@end
