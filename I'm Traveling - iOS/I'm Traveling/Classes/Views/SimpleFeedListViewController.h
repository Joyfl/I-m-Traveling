//
//  SimpleFeedListViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 16..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "FeedObject.h"

@class FeedDetailViewController;

@interface SimpleFeedListViewController : UIWebViewController
{
	// 0 : FeedDetailViewController
	// 1 : Profile
	NSInteger _ref;
	
	NSMutableArray *_feeds;
	NSInteger _lastFeedIndex;
}

- (id)initFromFeedDetailViewControllerFeeds:(NSMutableArray *)feeds lastFeedIndex:(NSInteger)lastFeedIndex;
- (id)initFromProfile;

@end
