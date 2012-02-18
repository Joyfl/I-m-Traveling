//
//  Feed.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedObject.h"

@implementation FeedObject

@synthesize feedId, userId, tripId, name, profileImageURL, place, region, time, pictureURL, review, info, latitude, longitude, numAllFeeds, numLikes, numComments, complete;

- (NSString *)title
{
	return place;
}

- (NSString *)subtitle
{
	return name;
}

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake( latitude, longitude );
}

@end
