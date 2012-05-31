//
//  NoticeDetailViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 6..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "ImTravelingBarButtonItem.h"
#import "Const.h"
#import "Utils.h"

@implementation NoticeDetailViewController

- (id)initWithNoticeId:(NSInteger)noticeId
{
	if( self = [super init] )
	{
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		
		_noticeTitle = @"";
		_noticeContent = @"";
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 367 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.userInteractionEnabled = NO;
		[self.view addSubview:_tableView];
		
		[self.loader addTokenWithTokenId:0 url:[NSString stringWithFormat:@"%@?notice_id=%d", API_NOTICE_DETAIL, noticeId] method:ImTravelingLoaderMethodGET params:nil];
		[self.loader startLoading];
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
		NSLog( @"Error" );
		return;
	}
	
	NSDictionary *notice = [json objectForKey:@"result"];
	_noticeTitle = [[notice objectForKey:@"title"] retain];
	_noticeContent = [[notice objectForKey:@"content"] retain];
	[_tableView reloadData];
	
	self.navigationItem.title = _noticeTitle;
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 1 )
		return 280;
	
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	
	if( indexPath.section == 0 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
		cell.textLabel.text = _noticeTitle;
	}
	else
	{
		cell = [[UITableViewCell alloc] init];
		UITextView *contentView = [[UITextView alloc] initWithFrame:CGRectMake( 15, 5, 290, 270 )];
		contentView.text = _noticeContent;
		contentView.font = [UIFont systemFontOfSize:14];
		contentView.backgroundColor = [UIColor clearColor];
		[cell addSubview:contentView];
		[contentView release];
	}
	
	return cell;
}


#pragma mark -
#pragma mark Navigation Selector

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}

@end
