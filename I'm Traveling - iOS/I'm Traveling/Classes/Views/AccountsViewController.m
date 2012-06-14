//
//  AccountsViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 6. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "AccountsViewController.h"
#import "SettingsManager.h"
#import "FacebookManager.h"
#import "Const.h"

@implementation AccountsViewController

- (id)init
{
	if( self = [super init] )
	{
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, self.view.frame.size.height ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
	}
	
	return self;
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UISwitch *facebookSwitch = [[UISwitch alloc] init];
	facebookSwitch.on = [[FacebookManager manager] connected];
	[facebookSwitch addTarget:self action:@selector(facebookSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	cell.textLabel.text = @"Facebook";
	cell.accessoryView = facebookSwitch;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


#pragma mark -
#pragma mark ButtonSelectors

- (void)facebookSwitchValueChanged:(UISwitch *)facebookSwitch
{
	if( facebookSwitch.on )
	{
		NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", nil];
		[[FacebookManager manager].facebook authorize:permissions];
	}
	else
	{
		[[SettingsManager manager] setSetting:[NSNumber numberWithBool:NO] forKey:SETTING_KEY_FACEBOOK_LINKED];
		[[SettingsManager manager] flush];
	}
}

@end
