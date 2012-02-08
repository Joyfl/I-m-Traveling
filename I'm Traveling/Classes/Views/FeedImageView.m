//
//  ThumbnailView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 29..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedImageView.h"
#import "Const.h"

@implementation FeedImageView

- (id)init
{
	if( self = [super init] )
	{
		webView.frame = CGRectMake( 0, 38.0, 320.0, 200.0 );
		webView.scrollView.showsHorizontalScrollIndicator = NO;
		webView.scrollView.showsVerticalScrollIndicator = NO;
		webView.scrollView.alwaysBounceHorizontal = NO;
		webView.scrollView.alwaysBounceVertical = NO;
		webView.scrollView.pagingEnabled = YES;
//		[self loadHtmlFile:@"feed_detail"];
		[self loadURL:HTML_INDEX];
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

# pragma mark - Javascript Functions

- (void)loadFeedImage
{
	
}

@end
