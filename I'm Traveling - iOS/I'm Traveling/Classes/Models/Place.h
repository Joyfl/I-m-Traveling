//
//  Place.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 7..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject
{
	NSInteger placeId;
	NSString *name;
	double latitude;
	double longitude;
	NSInteger category;
}

@property (nonatomic, assign) NSInteger placeId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) NSInteger category;

@end
