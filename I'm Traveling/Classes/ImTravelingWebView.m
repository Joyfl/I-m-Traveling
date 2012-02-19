//
//  ImTravelingWebView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 19..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingWebView.h"

@implementation ImTravelingWebView

- (id)init
{
	if( self = [super init] )
	{
		messagePrefix = @"imtraveling:";
		
		self = [super initWithFrame:CGRectMake( 0, 0, 320, 367 )];
		self.delegate = self;
		self.scrollView.showsHorizontalScrollIndicator = NO;
	}
	
	return self;
}

- (void)loadLocalPage:(NSString *)htmlFileName
{
	NSURL *url = [[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:htmlFileName ofType:@"html" inDirectory:@"www"] isDirectory:NO] retain];
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
	[self loadRequest:req];
	
	[url release];
	[req release];
	
}

- (void)loadRemotePage:(NSString *)urlString
{
	NSURL *url = [[NSURL URLWithString:urlString] retain];
	NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
	[self loadRequest:req];
	
	[url release];
	[req release];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if ( messagePrefix != nil && [[[request URL] absoluteString] hasPrefix:messagePrefix] )
	{
		NSString *data = [[NSMutableArray arrayWithArray:[[[request URL] absoluteString] componentsSeparatedByString:messagePrefix]] objectAtIndex:1];
		NSMutableArray *arguments = [[NSMutableArray alloc] initWithArray:[data componentsSeparatedByString:@":"]];
		
		NSString *message = [arguments objectAtIndex:0];
		[arguments removeObjectAtIndex:0];
		
		[self messageFromWebView:message arguements:arguments];
		
		return NO;
    }
	
	return YES;
}

- (void)messageFromWebView:(NSString *)message arguements:(NSMutableArray *)arguments
{
	//	NSLog( @"Overriding is needed." );
}

#pragma mark - Javascript Functions

- (void)clear
{
	[self stringByEvaluatingJavaScriptFromString:@"clear();"];
}

@end
