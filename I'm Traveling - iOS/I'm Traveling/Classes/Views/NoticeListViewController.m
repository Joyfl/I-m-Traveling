//
//  NoticeListViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeDetailViewController.h"
#import "ImTravelingBarButtonItem.h"
#import "Const.h"
#import "Utils.h"

@implementation NoticeListViewController

- (id)init
{
	if( self = [super init] )
	{
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		
		self.navigationItem.title = NSLocalizedString( @"NOTICE", @"" );
		
		_notices = [[NSMutableArray alloc] init];
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
		
		[self.loader loadURL:[NSString stringWithFormat:@"%@?from=%d&to=%d", API_NOTICE_LIST, 0, 100] withData:nil andId:0];
	}
	
	return self;
}


#pragma mark -
#pragma mark Loading

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [self isError:json] )
	{
		NSLog( @"Error!" );
		return;
	}
	
	[_notices removeAllObjects];
	[_notices addObjectsFromArray:[json objectForKey:@"result"]];
	[_tableView reloadData];
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _notices.count;
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
	
	NSDictionary *notice = [_notices objectAtIndex:indexPath.row];
	cell.textLabel.text = [notice objectForKey:@"title"];
	cell.detailTextLabel.text = [notice objectForKey:@"time"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[_tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	NSInteger noticeId = [[[_notices objectAtIndex:indexPath.row] objectForKey:@"notice_id"] integerValue];
	NoticeDetailViewController *noticeDetailViewController = [[NoticeDetailViewController alloc] initWithNoticeId:noticeId];
	[self.navigationController pushViewController:noticeDetailViewController animated:YES];
	[noticeDetailViewController release];
}


#pragma mark -
#pragma mark Navigation Selector

 - (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
