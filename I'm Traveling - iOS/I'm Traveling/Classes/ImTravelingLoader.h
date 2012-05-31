//
//  Loader.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	ImTravelingLoaderMethodGET = 0,
	ImTravelingLoaderMethodPOST = 1
};

@interface ImTravelingLoaderToken : NSObject
{	
	NSInteger _tokenId;
	NSString *_url;
	NSInteger _method;
	NSMutableDictionary *_params;
	NSString *_data;
}

- (id)initWithTokenId:(NSInteger)tokenId url:(NSString *)url method:(NSInteger)method params:(NSMutableDictionary *)params;

@property (nonatomic, assign) NSInteger tokenId;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, assign) NSInteger method;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, retain) NSString *data;

@end



@protocol ImTravelingLoaderDelegate;

@interface ImTravelingLoader : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLAuthenticationChallengeSender>
{
	NSMutableData *_responseData;
	NSMutableArray *_queue;
	
	id<ImTravelingLoaderDelegate> delegate;
	BOOL loading;
}

- (void)addTokenWithTokenId:(NSInteger)tokenId url:(NSString *)url method:(NSInteger)method params:(NSMutableDictionary *)params;
- (void)addToken:(ImTravelingLoaderToken *)token;
- (void)startLoading;
- (ImTravelingLoaderToken *)tokenAtIndex:(NSInteger)index;

@property (retain, nonatomic) id<ImTravelingLoaderDelegate> delegate;
@property (nonatomic, readonly) NSInteger queueLength;
@property (nonatomic, readonly) BOOL loading;

@end


@protocol ImTravelingLoaderDelegate

- (BOOL)shouldLoadWithToken:(ImTravelingLoaderToken *)token;

@required
- (void)loadingDidFinish:(ImTravelingLoaderToken *)token;

@end


