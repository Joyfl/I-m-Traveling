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
	
	// 피드를 로드할 때 중복 로드를 방지하기 위한 변수.
	// YES일 경우 현재 로딩중.
	BOOL loading;
	
	// reload일 경우 로드한 피드들이 위에 추가되어야하고,
	// 아래로 스크롤할 경우 로드한 피드들이 아래에 추가되어야 하므로
	// 위에 추가할지 아래에 추가할지를 구별하는 변수를 둠.
	// YES일 경우 위에 추가.
	BOOL reloading;
}

@end
