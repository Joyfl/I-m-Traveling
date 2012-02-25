//
//  ProfileView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import "ProfileWebView.h"
#import "UserObject.h"

@interface ProfileViewController : ImTravelingViewController <UIScrollViewDelegate>
{
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	ProfileWebView *_webView;
	
	UserObject *userObject;
	
	// 생성된 적이 있는지 (viewDidAppear는 다른 탭으로 전환했다가 다시 돌아와도 호출되기 때문에 중복 생성 방지)
	BOOL created;
}

@end