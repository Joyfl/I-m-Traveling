//
//  ImTravelingBarButtonItem.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingBarButtonItem.h"

@implementation ImTravelingBarButtonItem

- (id)initWithType:(NSInteger)type title:(NSString *)title target:(id)target action:(SEL)action
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
	button.titleLabel.shadowOffset = CGSizeMake( 0, -1 );
	[button setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.3] forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
	
	UIImage *bg;
	switch( type )
	{
		case ImTravelingBarButtonItemTypeNormal:
			bg = [UIImage imageNamed:@"button.png"];
			button.frame = CGRectMake( 0, 0, 60, 31 );
			break;
			
		case ImTravelingBarButtonItemTypeBack:
			bg = [UIImage imageNamed:@"button_back.png"];
			button.frame = CGRectMake( 0, 0, 50, 31 );
			button.titleEdgeInsets = UIEdgeInsetsMake( 0, 6, 0, 0 );
			break;
	}
	
	[button setBackgroundImage:bg forState:UIControlStateNormal];
	[button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	
	return [super initWithCustomView:button];
}


#pragma mark -
#pragma mark Getter/Setter

- (NSString *)title
{
	UIButton *button = (UIButton *)self.customView;
	return [button titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
	UIButton *button = (UIButton *)self.customView;
	[button setTitle:title forState:UIControlStateNormal];
}

@end
