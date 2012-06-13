//
//  AccountsViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 6. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "AccountsViewController.h"
#import "Const.h"

@implementation AccountsViewController

- (id)init
{
	if( self = [super init] )
	{
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, WEBVIEW_HEIGHT ) style:UITableViewStyleGrouped];
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
	UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
	[facebookButton addTarget:self action:@selector(facebookButtonDidTouchUpInside) forControlEvents:UIControlEventTouchDragInside];
	
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	cell.textLabel.text = @"Facebook";
	cell.accessoryView = facebookButton;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	return cell;
}


#pragma mark -
#pragma mark ButtonSelectors

- (void)facebookButtonDidTouchUpInside
{
	
}

@end
