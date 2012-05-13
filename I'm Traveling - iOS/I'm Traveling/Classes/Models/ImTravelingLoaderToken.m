//
//  ImTravelingLoaderToken.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingLoaderToken.h"

@implementation ImTravelingLoaderToken

@synthesize request=_request, tokenId=_tokenId, data=_data;

- (id)initWithRequeust:(NSMutableURLRequest *)request andTokenId:(NSInteger)tokenId
{
	_request = request;
	_tokenId = tokenId;
	
	return self;
}

@end
