//
//  ProfileWebView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 23..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ProfileWebView.h"
#import "Const.h"

@implementation ProfileWebView

- (id)init
{
	if( self = [super init] )
	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.scrollView.scrollEnabled = NO;
		
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark UIWebView

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
}


#pragma mark -
#pragma mark Javascript Function

- (void)createProfile:(UserObject *)userObj
{
	[self clear];
	
	NSString *func = [[NSString stringWithFormat:@"createProfile(%d, '%@', '%@', '%@', %d, %d, %d, '%@', %d, %d, %d, %d )",
					   userObj.userId,
					   userObj.profileImageURL,
					   userObj.name,
					   userObj.nation,
					   userObj.numFollowers,
					   userObj.numFollowings,
					   /*userObj.numBadges"*/0,
					   @"[]",
					   /*notice*/0,
					   userObj.numFeeds,
					   userObj.numTrips,
					   0] retain];
	
	[self stringByEvaluatingJavaScriptFromString:func];
	[func release];
	
	NSLog( @"%@", func );
}

@end
