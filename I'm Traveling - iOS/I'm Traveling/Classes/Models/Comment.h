//
//  Comment.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{
	NSInteger commentId;
	NSInteger userId;
	NSString *profileImgUrl;
	NSString *name;
	NSString *time;
	NSString *comment;
}

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString *profileImgUrl;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *comment;

@end
