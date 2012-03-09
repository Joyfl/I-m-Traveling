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

- (void)loadURL:(NSString *)url withData:(NSDictionary *)data
{
	for( id key in data )
		url = [url stringByAppendingFormat:@"?%@=%@", key, [data objectForKey:key]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)loadURLPOST:(NSString *)url withData:(NSDictionary *)data
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
	
    NSMutableData *body = [NSMutableData data];
	
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	for( id key in data )
	{
		id object = [data objectForKey:key];
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		if( [object isKindOfClass:[UIImage class]] )
		{
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[NSData dataWithData:UIImageJPEGRepresentation( object, 100 )]];
		}
		else
		{
			[body appendData:[object dataUsingEncoding:NSUTF8StringEncoding]];
		}
		[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [request setHTTPBody:body];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
}

- (void)continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
}

- (void)cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
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
	[self loadingDidFinish:result];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog( @"Loading Error : %@", error );
}

- (void)loadingDidFinish:(NSString *)result
{
	NSLog( @"loadingDidFinish : Overriding is needed." );
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
