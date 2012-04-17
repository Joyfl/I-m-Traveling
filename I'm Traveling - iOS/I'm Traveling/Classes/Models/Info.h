//
//  Info.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Info : NSObject
{
	NSString *item;
	NSInteger value;
	NSString *unit;
}

@property (nonatomic, retain) NSString *item;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, retain) NSString *unit;

- (NSDictionary *)dictionary;

@end
