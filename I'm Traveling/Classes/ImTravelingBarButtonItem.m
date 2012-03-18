//
//  ImTravelingBarButtonItem.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingBarButtonItem.h"

@implementation ImTravelingBarButtonItem

- (id)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	[button setTitle:title forState:UIControlStateNormal];
	[button setBackgroundImage:[[UIImage imageNamed:@"button.png"] retain] forState:UIControlStateNormal];
	[button setFrame:CGRectMake( 0, 0, 60, 31 )];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return [super initWithCustomView:button];
}

@end
