//
//  SettingsViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SettingsViewController.h"
#import "ImTravelingBarButtonItem.h"
#import "Utils.h"
#import "NoticeListViewController.h"

@implementation SettingsViewController

enum {
	kTagNotice,
	kTagFeedback,
	kTagGuide,
	kTagAccounts,
	kTagNotifications,
	kTagLogout,
	kTagWithdrawal
};

- (id)init
{
	if( self = [super init] )
	{
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
		
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		
		self.navigationItem.title = NSLocalizedString( @"SETTINGS", @"" );
	}
	
	return self;
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch( section )
	{
		case 0:
			return 3;
			
		case 1:
			return 2;
			
		case 2:
			return 2;
	}
	
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"cellId";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( cell == nil )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	switch( indexPath.section )
	{
		case 0:
			if( indexPath.row == 0 )
				cell.textLabel.text = NSLocalizedString( @"NOTICE", @"" );
			
			else if( indexPath.row == 1 )
				cell.textLabel.text = NSLocalizedString( @"FEEDBACK", @"" );
			
			else if( indexPath.row == 2 )
				cell.textLabel.text = NSLocalizedString( @"GUIDE", @"" );
			
			break;
			
		case 1:
			if( indexPath.row == 0 )
				cell.textLabel.text = NSLocalizedString( @"ACCOUNTS", @"" );
			
			else if( indexPath.row == 1 )
				cell.textLabel.text = NSLocalizedString( @"NOTIFICATIONS", @"" );
			
			break;
			
		case 2:
			if( indexPath.row == 0 )
				cell.textLabel.text = NSLocalizedString( @"LOGOUT", @"" );
			
			else if( indexPath.row == 1 )
				cell.textLabel.text = NSLocalizedString( @"WITHDRAWAL", @"" );
			
			break;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	switch( indexPath.section )
	{
		case 0:
			if( indexPath.row == 0 )
			{
				NoticeListViewController *noticeListViewController = [[NoticeListViewController alloc] init];
				[self.navigationController pushViewController:noticeListViewController animated:YES];
				[noticeListViewController release];
			}
			else if( indexPath.row == 1 )
			{
				
			}
			else if( indexPath.row == 2 )
			{
				
			}
			break;
			
		case 1:
			if( indexPath.row == 0 )
			{
				
			}
			else if( indexPath.row == 1 )
			{
				
			}	
			
			break;
			
		case 2:
			if( indexPath.row == 0 )
			{
				[Utils logout];
				[[[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString( @"LOGGED_OUT", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"OK", @"" ) otherButtonTitles:nil] autorelease] show];
			}
			else if( indexPath.row == 1 )
			{
				
			}
			
			break;
	}
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.tabBarController.selectedIndex = 0;
	[self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark Navigaion Selector

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
