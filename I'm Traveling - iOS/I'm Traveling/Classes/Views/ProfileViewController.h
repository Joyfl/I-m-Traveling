//
//  ProfileView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "UserObject.h"

@interface ProfileViewController : UIWebViewController <UIScrollViewDelegate>
{
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	
	UserObject *user;
	NSMutableArray *trips;
	NSMutableArray *followings;
	NSMutableArray *followers;
	
	/**
	 * 0 : Trips
	 * 1 : Following
	 * 2 : Followers
	 */
	NSInteger currentTab;
	
	/**
	 * 0 : Profile 로딩중
	 * 1 : Trips 로딩중
	 * 2 : Following 로딩중
	 * 3 : Followers 로딩중
	 * 4 : 완료
	 */
	NSInteger loadingProgress;
	
	BOOL activated;
}

- (void)activateWithUserId:(NSInteger)userId;

@property (nonatomic, assign) BOOL activated;

@end