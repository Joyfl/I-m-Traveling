//
//  FeedDetailView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedDetailView.h"
#import "Const.h"

@implementation FeedDetailView

@synthesize feedId;

- (id)init
{
    if( self = [super init] )
	{
		messagePrefix = @"imtraveling:";
		
		thumbView = [[ThumbnailView alloc] init];
		[self.webView.scrollView addSubview:thumbView.view];
		
		[self loadURL:URL_FEED_DETAIL];
    }
	
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self reloadWebView];
}

- (void)reloadWebView
{
//	NSString *json = [self getHtmlFromUrl:[NSString stringWithFormat:@"%@?feed_id=%@", API_FEED_DETAIL, feedId]];
	
	[self webViewDidFinishReloading];
}

#pragma mark - javascript functions


// createFeedDetail(feed_id, user_id, profile_image_url, name, place, region, time, pictures, info, review, map_info, num_likes, comments, liked)

@end
