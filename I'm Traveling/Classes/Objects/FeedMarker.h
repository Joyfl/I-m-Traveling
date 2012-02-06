//
//  FeedMarker.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedObject.h"

@interface FeedMarker : NSObject <MKAnnotation>
{
	NSInteger feedId;
	NSString *title;
	NSString *subtitle;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, assign) NSInteger feedId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end
