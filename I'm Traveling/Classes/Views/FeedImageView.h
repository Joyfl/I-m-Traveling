//
//  ThumbnailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"

@interface FeedImageView : UIWebViewController
{
	NSInteger currentFeedIndex;
}

@property (nonatomic, assign) NSInteger currentFeedIndex;

- (void)loadFeedImage:(NSInteger)index url:(NSString *)url;
- (void)scrollToCurrentFeed;

@end
