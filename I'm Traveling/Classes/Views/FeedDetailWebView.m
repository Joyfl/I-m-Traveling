//
//  FeedDetailWebView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailWebView.h"
#import "Const.h"

@implementation FeedDetailWebView

@synthesize feedObject;

- (id)initWithFeedDetailViewController:(FeedDetailViewController *)detailViewController
{
	if( self = [super init] )
	{
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.scrollView.scrollEnabled = NO;
		
//		self.webView.layer.shadowColor = [UIColor blackColor].CGColor;
//		self.webView.layer.shadowOpacity = 0.7f;
//		self.webView.layer.shadowOffset = CGSizeMake( 0, -4.0f );
//		self.webView.layer.shadowRadius = 5.0f;
		
		// 그림자 제거
//		for( NSInteger i = 9; i > 5; i-- )
//			[[self.webView.scrollView.subviews objectAtIndex:i] setHidden:YES];
		
		_detailViewController = detailViewController;
		
		[self loadRemotePage:HTML_INDEX];
	}
	
	return self;
}


#pragma mark -
#pragma mark UIWebView

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	if( [message isEqualToString:@"detail_finished"] )
	{
		[_detailViewController feedDetailDidFinishCreating];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
}

#pragma mark - Javascript Function

- (void)createFeedDetail:(FeedObject *)feedObj
{
	NSString *func = [[NSString stringWithFormat:@"createFeedDetail(%d, %d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   feedObj.tripId,
					   feedObj.feedId,
					   feedObj.userId,
					   feedObj.profileImageURL,
					   /*feedObj.name,*/@"Name",
					   feedObj.time,
					   /*feedObj.place,*/@"Place",
					   feedObj.region,
					   feedObj.pictureURL,
					   feedObj.review,
					   @"feedObj.info",
					   feedObj.numAllFeeds,
					   feedObj.numLikes] retain];
	
	[self stringByEvaluatingJavaScriptFromString:func];
	
	NSLog( @"%@", func );
}

@end
