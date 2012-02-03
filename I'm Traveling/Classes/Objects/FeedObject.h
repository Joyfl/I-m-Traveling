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
	NSString *review;
	CLLocationCoordinate2D mapInfo;
	NSInteger numLikes;
	NSInteger numComments;
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
@property (nonatomic, retain) NSString *review;
@property (nonatomic, assign) CLLocationCoordinate2D *mapInfo;
@property (nonatomic, assign) NSInteger numLikes;
@property (nonatomic, assign) NSInteger numComments;

// MKAnnotation
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
