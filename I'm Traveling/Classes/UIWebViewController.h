//
//  UIWebViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebViewController : UIViewController <UIWebViewDelegate>
{
	UIWebView *webView;
	NSString *messagePrefix;
	
	UIAlertView *_loadingAlert;
}

- (void)loadHtmlFile:(NSString *)htmlFileName;
- (void)loadURL:(NSString *)urlString;
- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments;

- (void)clear;

- (void)startBusy;
- (void)stopBusy;

@property (nonatomic, retain) UIWebView *webView;

@end
