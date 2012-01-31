//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import "ThumbnailView.h"

@interface FeedDetailViewController : UIPullDownWebViewController
{
	ThumbnailView *thumbView;
	
	NSString *feedId;
}

@property (nonatomic, retain) NSString *feedId;

@end
