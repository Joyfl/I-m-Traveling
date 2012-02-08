//
//  RegionView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 26..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "RegionViewController.h"
#import "SettingsManager.h"
#import "Const.h"

@implementation RegionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
		self.title = @"Select Region";
		
		regions = [[NSArray alloc] initWithObjects:@"All", @"Korea", @"USA", @"Japan", @"China", nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return regions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSString *region = [regions objectAtIndex:indexPath.row];
	cell.textLabel.text = region;
	
	NSString static *key = SETTING_KEY_REGION;
	NSString *selectedRegion = [[SettingsManager manager] getSettingForKey:key];
	if( [region isEqualToString:selectedRegion] )
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		lastCell = cell;
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( lastCell )
		lastCell.accessoryType = UITableViewCellAccessoryNone;
	
	NSString static *key = SETTING_KEY_REGION;
	NSString *region = [regions objectAtIndex:indexPath.row];
	[[SettingsManager manager] setSetting:region forKey:key];
	[[SettingsManager manager] flush];
	
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	if( cell.accessoryType != UITableViewCellAccessoryCheckmark )
	{
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
	{
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	lastCell = cell;
	
//	NSLog( @"%@", selectedRegions );
}

@end
