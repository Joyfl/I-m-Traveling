//
//  PlaceSelectionViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "PlaceSelectionViewController.h"

@implementation PlaceSelectionViewController

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 440 ) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Bar Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)doneButtonDidTouchUpInside
{
	
}

@end
