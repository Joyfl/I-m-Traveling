//
//  Info.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 3..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Info.h"

@implementation Info

@synthesize item, value, unit;

- (NSDictionary *)dictionary
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
			item, @"item",
			[NSNumber numberWithInteger:value], @"value",
			unit, @"unit",
			nil];
}

@end
