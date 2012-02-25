//
//  FeedListView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPullDownWebViewController.h"
#import "FeedDetailViewController.h"
#import "MapViewController.h"

@interface FeedListViewController : UIPullDownWebViewController
{
	MapViewController *_mapViewController;
	
	NSMutableDictionary *_feedListObjects;	
	NSInteger _orderType;
	
	// 로드된 적이 있는지 (viewDidAppear는 다른 탭으로 전환했다가 다시 돌아와도 호출되기 때문에 중복 로드 방지)
	BOOL loaded;
}

@end
