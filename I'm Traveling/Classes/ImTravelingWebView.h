//
//  ImTravelingWebView.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 19..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImTravelingWebView : UIWebView <UIWebViewDelegate>
{
	NSString *messagePrefix;
}

- (void)loadLocalPage:(NSString *)htmlFileName;
- (void)loadRemotePage:(NSString *)urlString;

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments;

- (void)clear;

@end
