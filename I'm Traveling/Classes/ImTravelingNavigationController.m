//
//  ImTravelingNavigationController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingNavigationController.h"

@implementation ImTravelingNavigationController

- (id)init
{
	if( self = [super init] )
		[self.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	
	return self;
}

@end
