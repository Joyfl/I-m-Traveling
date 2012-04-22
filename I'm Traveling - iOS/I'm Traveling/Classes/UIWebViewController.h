//
//  UIWebViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImTravelingViewController.h"
#import "ImTravelingWebView.h"

@interface UIWebViewController : ImTravelingViewController <UIWebViewDelegate>
{
	UIWebView *webView;
	NSString *messagePrefix;
}

- (void)loadPage:(NSString *)page;
- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments;
- (void)resizeWebViewHeight:(UIWebView *)wv;
- (void)clear;

@property (nonatomic, retain) UIWebView *webView;

@end
