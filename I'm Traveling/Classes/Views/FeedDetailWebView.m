//
//  FeedDetailWebView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailWebView.h"
#import "FeedDetailViewController.h"
#import "Const.h"
#import "Comment.h"

@implementation FeedDetailWebView

@synthesize loaded;

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
	if( [message isEqualToString:@"all_feed"] )
	{
		[_detailViewController seeAllFeeds];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self clear];
	self.loaded = YES;
}

#pragma mark - Javascript Function

- (void)createFeedDetail:(FeedObject *)feedObj
{
	[self clear];
	
	// WebView 로딩이 덜됬으면 로딩이 완료될 때까지 기다린다.
	// 로딩이 완료되면 loaded 프로퍼티가 YES로 변경되고,
	// 변경을 감지하는 메서드에서 createFeedDetail을 다시 호출한다.
	if( !self.loaded )
	{
		_feed = [feedObj retain];
		[self addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:nil];
		return;
	}
	
	NSString *func = [[NSString stringWithFormat:@"createFeedDetail(%d, %d, %d, '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %d, %d)",
					   feedObj.tripId,
					   feedObj.feedId,
					   feedObj.userId,
					   feedObj.profileImageURL,
					   feedObj.name,
					   feedObj.time,
					   feedObj.place,
					   feedObj.region,
					   feedObj.pictureURL,
					   feedObj.review,
					   /*feedObj.info*/@"[{\"item\":\"도미\",\"value\":5000,\"unit\":\"KRW\"}]",
					   feedObj.numAllFeeds,
					   feedObj.numLikes] retain];
	
	[self stringByEvaluatingJavaScriptFromString:func];
//	NSLog( @"%@", func );
//	[_detailViewController feedDetailDidFinishCreating:self];
	[_detailViewController performSelector:@selector(feedDetailDidFinishCreating:) withObject:self afterDelay:0.5];
	
}

- (void)addComment:(Comment *)comment
{
	NSString *func = [NSString stringWithFormat:@"addComment( %d, '%@', '%@', '%@', '%@' )",
					   comment.userId,
					   comment.profileImgUrl,
					   comment.name,
					   comment.time,
					   comment.comment];
	[self stringByEvaluatingJavaScriptFromString:func];
	[_detailViewController commentDidAdd:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	[self createFeedDetail:_feed];
	[_feed release];
}

@end
