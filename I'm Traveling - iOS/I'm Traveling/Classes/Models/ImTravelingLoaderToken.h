//
//  ImTravelingLoaderToken.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImTravelingLoaderToken : NSObject
{
	NSMutableURLRequest *_request;
	NSInteger _tokenId;
	NSString *_data;
}

- (id)initWithRequeust:(NSMutableURLRequest *)request andTokenId:(NSInteger)tokenId;

@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, assign) NSInteger tokenId;
@property (nonatomic, retain) NSString *data;

@end
