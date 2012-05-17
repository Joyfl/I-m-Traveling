//
//  Loader.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingLoader.h"

@implementation ImTravelingLoaderToken

@synthesize request=_request, tokenId=_tokenId, data=_data;

- (id)initWithRequeust:(NSMutableURLRequest *)request andTokenId:(NSInteger)tokenId
{
	self.request = request;
	self.tokenId = tokenId;
	
	return self;
}

@end



@implementation ImTravelingLoader

@synthesize delegate;

- (id)init
{
	_responseData = [[NSMutableData alloc] init];
	_queue = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)loadURL:(NSString *)url withData:(NSDictionary *)data andId:(NSInteger)tokenId
{
	if( data )
	{
		url = [url stringByAppendingFormat:@"?"];
		
		for( id key in data )
			url = [url stringByAppendingFormat:@"%@=%@&", key, [data objectForKey:key]];
		
		url = [url substringToIndex:url.length - 1];
		url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	NSLog( @"%@", url );
	
	[self loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] andTokenId:tokenId];
}

- (void)loadURLPOST:(NSString *)url withData:(NSDictionary *)data andId:(NSInteger)tokenId
{
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
	
    NSMutableData *body = [NSMutableData data];
	
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	for( id key in data )
	{
		id object = [data objectForKey:key];
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		
		if( [object isKindOfClass:[NSString class]] )
		{
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[object dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else if( [object isKindOfClass:[NSNumber class]] )
		{
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];	
			[body appendData:[[NSString stringWithFormat:@"%@", object] dataUsingEncoding:NSUTF8StringEncoding]];
		}
		else if( [object isKindOfClass:[UIImage class]] )
		{
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"picture\"; filename=\"xoulzzang\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithString:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[NSData dataWithData:UIImageJPEGRepresentation( object, 1.0 )]];
		}
		else
		{
			NSLog( @"other class : %@=%@", key, [object class] );
		}
		
		[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
    [request setHTTPBody:body];
	
	[self loadRequest:request andTokenId:tokenId];
}

- (void)loadRequest:(NSMutableURLRequest *)request andTokenId:(NSInteger)tokenId
{
	if( _queue.count == 0 )
	{
		[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	}
	
	ImTravelingLoaderToken *token = [[ImTravelingLoaderToken alloc] initWithRequeust:request andTokenId:tokenId];
	[_queue addObject:token];
}

#pragma mark -
#pragma mark NSURLConnection

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
	_responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[_responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if( _queue.count == 0 )
	{
		NSLog( @"Loading queue is empty!" );
		return;
	}
	
	ImTravelingLoaderToken *token = [[_queue objectAtIndex:0] retain];
	[_queue removeObjectAtIndex:0];
	
	token.data = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	[self.delegate loadingDidFinish:token];
	[token release];
	
	if( _queue.count > 0 )
	{
		ImTravelingLoaderToken *nextToken = [_queue objectAtIndex:0];
		if( [delegate shouldLoadWithToken:nextToken] )
		{
			[[[NSURLConnection alloc] initWithRequest:nextToken.request delegate:self] autorelease];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog( @"Loading Error : %@", error );
}

- (void)continueLoading
{
	if( _queue.count == 0 ) return;
	
	ImTravelingLoaderToken *token = [_queue objectAtIndex:0];
	if( [delegate shouldLoadWithToken:token] )
	{
		[[[NSURLConnection alloc] initWithRequest:token.request delegate:self] autorelease];
	}
}


#pragma mark -
#pragma mark Getter

- (NSInteger)queueLength
{
	return _queue.count;
}

@end
