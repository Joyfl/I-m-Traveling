//
//  Feed.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedObject : NSObject
{
	NSInteger feedId;
	NSInteger userId;
	NSString *name;
	NSString *profileImageURL;
	NSString *place;
	NSString *region;
	NSString *time;
	NSString *pictureURL;
	NSString *review;
	NSInteger numLikes;
	NSInteger numComments;
}

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *profileImageURL;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *region;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *pictureURL;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, assign) NSInteger numLikes;
@property (nonatomic, assign) NSInteger numComments;

@end
