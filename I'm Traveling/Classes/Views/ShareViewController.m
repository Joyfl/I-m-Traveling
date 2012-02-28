//
//  UploadView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 24..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ShareViewController.h"
#import "Const.h"
#import "QuartzCore/CALayer.h"
#import "ImTravelingNavigationController.h"
#import "TripListViewController.h"
#import "TimeSelectionViewController.h"
#import "PlaceSelectionViewController.h"
#import "Utils.h"

@implementation ShareViewController

@synthesize selectedDate, selectedTime;

-(id)initWithImage:(UIImage *)image
{
    if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(uploadButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = uploadButton;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 440 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		[self.view addSubview:_tableView];
		
		_image = [image retain];
		
		_info = [[NSDictionary alloc] init];
		
		selectedDate = [[NSDate alloc] init];
		selectedTime = [[NSDate alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)uploadButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3 + _info.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( section == 1 ) return 3;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 0 )
		return _image.size.height * 300 / _image.size.width;
	
	else if( indexPath.section == 2 )
		return 200;
	
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell;
	
	// Image
	if( indexPath.section == 0 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.imageView.image = _image;
		cell.imageView.layer.cornerRadius = 10;
		cell.imageView.layer.masksToBounds = YES;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Trip, Date, Place
	else if( indexPath.section == 1 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		if( indexPath.row == 0 )
		{
			_tripCell = cell;
			cell.textLabel.text = @"Trip";
		}
		if( indexPath.row == 1 )
		{
			_dateCell = cell;
			cell.textLabel.text = @"Date";
			[self fillDateCellDetailText];
			
		}
		else if( indexPath.row == 2 )
		{
			_placeCell = cell;
			cell.textLabel.text = @"Place";
		}
		
	}
	
	// Review
	else if( indexPath.section == 2 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake( 100, 12, cell.frame.size.width - 110, cell.frame.size.height - 24 )];
		[cell addSubview:textView];
		textView.editable = YES;
	}
	
	// Info
	else
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake( 100, 12, cell.frame.size.width - 110, cell.frame.size.height - 24 )];
		[cell addSubview:textField];
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 1 )
	{
		UIViewController *rootViewController;
		
		if( indexPath.row == 0 )
		{
			rootViewController = [[TripListViewController alloc] init];
		}
		else if( indexPath.row == 1 )
		{
			rootViewController = [[TimeSelectionViewController alloc] initWithShareViewController:self];
		}
		else
		{
			rootViewController = [[PlaceSelectionViewController alloc] init];
		}
		
		ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:rootViewController];
		[self presentModalViewController:navigationController animated:YES];
	}
}


#pragma mark -
#pragma mark Utils

- (void)fillDateCellDetailText
{
	_dateCell.detailTextLabel.text = [Utils stringWithDate:selectedDate andTime:selectedTime];
}

@end
