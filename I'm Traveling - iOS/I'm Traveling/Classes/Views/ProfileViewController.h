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
	UIImageView *_imageTopBorder;
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	UIImageView *_arrow;
	
	UserObject *user;
	NSMutableArray *trips;
	NSMutableArray *followings;
	NSMutableArray *followers;
	NSInteger _numNotifications;
	
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
//	NSInteger loadingProgress;
	
	BOOL activated;
}

- (void)activateWithUserId:(NSInteger)userId userName:(NSString *)name;
- (void)activateFromTabBarWithUserId:(NSInteger)userId userName:(NSString *)name;
- (void)deactivate;

@property (nonatomic, assign) BOOL activated;

@end