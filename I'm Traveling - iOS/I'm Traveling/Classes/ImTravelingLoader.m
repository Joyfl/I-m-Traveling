//
//  Loader.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingLoader.h"

@implementation ImTravelingLoaderToken

@synthesize tokenId=_tokenId, url=_url, method=_method, params=_params, data=_data;


#pragma mark -
#pragma mark Public methods

- (id)initWithTokenId:(NSInteger)tokenId url:(NSString *)url method:(NSInteger)method params:(NSMutableDictionary *)params
{
	self.tokenId = tokenId;
	self.url = url;
	self.method = method;
	self.params = params;
	
	return self;
}

@end



@implementation ImTravelingLoader

@synthesize delegate, loading;

- (id)init
{
	_responseData = [[NSMutableData alloc] init];
	_queue = [[NSMutableArray alloc] init];
	
	return self;
}

- (void)addTokenWithTokenId:(NSInteger)tokenId url:(NSString *)url method:(NSInteger)method params:(NSMutableDictionary *)params
{
	ImTravelingLoaderToken *token = [[ImTravelingLoaderToken alloc] initWithTokenId:tokenId url:url method:method params:params];
	[self addToken:token];
	[token release];
}

- (void)addToken:(ImTravelingLoaderToken *)token
{
	[token retain];
	[_queue addObject:token];
}

- (void)startLoading
{
	if( loading ) return;
	if( _queue.count > 0 )
	{
		ImTravelingLoaderToken *token = [_queue objectAtIndex:0];
		if( [delegate shouldLoadWithToken:token] )
		{
			[self loadToken:token];
			loading = YES;
		}
	}
}


#pragma mark -
#pragma mark Private methods

- (void)loadToken:(ImTravelingLoaderToken *)token
{
	NSMutableURLRequest *request;
	
	if( token.method == ImTravelingLoaderMethodGET )
	{
		request = [self GETRequest:token];
	}
	else
	{
		request = [self POSTRequest:token];
	}
	
	[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	[request release];
}

- (NSMutableURLRequest *)GETRequest:(ImTravelingLoaderToken *)token
{
	NSString *url = token.url;
	
	if( token.params )
	{
		url = [token.url stringByAppendingFormat:@"?"];
		
		for( id key in token.params )
			url = [url stringByAppendingFormat:@"%@=%@&", key, [token.params objectForKey:key]];
		
		url = [url substringToIndex:url.length - 1];
		url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	}
	
	return [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]] retain];
}

- (NSMutableURLRequest *)POSTRequest:(ImTravelingLoaderToken *)token
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:token.url]];
	[request setHTTPMethod:@"POST"];
	
	NSMutableData *body = [NSMutableData data];
	
	NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	
	for( id key in token.params )
	{
		id object = [token.params objectForKey:key];
		
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
	
	return request;
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
	
	loading = NO;
	
	ImTravelingLoaderToken *token = [[_queue objectAtIndex:0] retain];
	[_queue removeObjectAtIndex:0];
	
	token.data = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
	[self.delegate loadingDidFinish:token];
	[token release];
	
	[self startLoading];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog( @"Loading Error : %@", error );
	loading = NO;
}


#pragma mark -
#pragma mark Getters

- (ImTravelingLoaderToken *)tokenAtIndex:(NSInteger)index
{
	return [_queue objectAtIndex:index];
}

- (NSInteger)queueLength
{
	return _queue.count;
}


@end
