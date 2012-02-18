//
//  UIWebViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImTravelingViewController.h"

@interface UIWebViewController : ImTravelingViewController <UIWebViewDelegate>
{
	UIWebView *webView;
	NSString *messagePrefix;
}

- (void)loadLocalPage:(NSString *)htmlFileName;
- (void)loadRemotePage:(NSString *)urlString;
- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments;

- (void)clear;

@property (nonatomic, retain) UIWebView *webView;

@end
