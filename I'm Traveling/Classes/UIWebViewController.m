//
//  UIWebViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"

@implementation UIWebViewController

@synthesize webView;

- (id)init
{
	if( self = [super init] )
	{
		messagePrefix = @"imtraveling:";
		
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		self.webView.delegate = self;
		self.webView.scrollView.showsHorizontalScrollIndicator = NO;
		[self.view addSubview:webView];
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

#pragma mark - WebView

- (void)loadHtmlFile:(NSString *)htmlFileName
{
	NSURL *url = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html" inDirectory:@"www"] isDirectory:NO] retain];
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
	[webView loadRequest:req];
	
	[url release];
	[req release];

}

- (void)loadURL:(NSString *)urlString
{
	NSURL *url = [[NSURL URLWithString:urlString] retain];
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
	[webView loadRequest:req];
	
	[url release];
	[req release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ( messagePrefix != nil && [[[request URL] absoluteString] hasPrefix:messagePrefix] )
	{
		NSString *msg = [[[[request URL] absoluteString] componentsSeparatedByString:messagePrefix] objectAtIndex:1];
		[self messageFromWebView:msg];
		
		return NO;
    }
	
	return YES;
}

- (void)messageFromWebView:(NSString *)msg
{
	
}

#pragma mark - Javascript Functions

- (void)clear
{
	NSLog( @"clear" );
	
	[webView stringByEvaluatingJavaScriptFromString:@"clear();"];
}

@end
