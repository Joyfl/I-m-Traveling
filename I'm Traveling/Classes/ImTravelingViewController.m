//
//  ImTravelingViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@implementation ImTravelingViewController

- (id)init
{
	if( self = [super init] )
	{
		responseData = [[NSMutableData alloc] init];
		
		UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake( 125, 50, 30, 40 )];
		indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		[indicatorView startAnimating];
		
		_loadingAlert = [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
		[_loadingAlert addSubview:indicatorView];
	}
	
	return self;
}

#pragma mark -
#pragma mark NSURLConnection

- (void)loadURL:(NSString *)url
{
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[self didFinishLoading:result];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog( @"Loading Error : %@", error );
}

- (void)didFinishLoading:(NSString *)result
{
	NSLog( @"didFinishLoading : Overriding is needed." );
}


#pragma mark -
#pragma mark Utils

- (void)startBusy
{
	[_loadingAlert show];
}

- (void)stopBusy
{
	[_loadingAlert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
