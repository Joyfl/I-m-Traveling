//
//  FeedDetailView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import "FeedImageView.h"
#import "FeedObject.h"

@interface FeedDetailViewController : UIPullDownWebViewController
{
	FeedImageView *feedImageView;
	
	FeedObject *feedObject;
}

@property (nonatomic, retain) FeedObject *feedObject;

@end
