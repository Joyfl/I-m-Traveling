//
//  UserObject.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserObject : NSObject
{
	NSInteger userId;
	NSString *profileImageURL;
	NSString *name;
	NSString *nation;
	NSInteger numFollowers;
	NSInteger numFollowings;
	NSInteger numBadges;
	
	BOOL complete;
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *profileImageURL;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nation;
@property (nonatomic, assign) NSInteger numFollowers;
@property (nonatomic, assign) NSInteger numFollowings;
@property (nonatomic, assign) BOOL complete;

@end
