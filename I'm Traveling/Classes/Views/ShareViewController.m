//
//  UploadView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 24..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ShareViewController.h"
#import "Const.h"

@implementation ShareViewController

- (id)init
{
    if( self = [super init] )
	{
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onCancelButtonTouch)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onUploadButtonTouch)];
		self.navigationItem.rightBarButtonItem = uploadButton;
		
		self.webView.frame = CGRectMake( 0, 0, 320, 416 );
//		[self loadHtmlFile:@"feed_list"];
		[self loadURL:HTML_FEED_SHARE];
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

#pragma mark - selectors

- (void)onCancelButtonTouch
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)onUploadButtonTouch
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
