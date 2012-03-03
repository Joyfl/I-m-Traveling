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

@interface ShareViewController()

- (void)scrollToKeyboardPosition;

@end


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
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 440 ) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor grayColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
	return 5;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( section == 3 ) return _info.count;
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if( indexPath.section == 0 )
		return _image.size.height * 321 / _image.size.width;
	
	else if( indexPath.section == 1 )
		return 150;
	
	else if( indexPath.section == 2 )
		return 180;
	
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
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	// Trip, Date, Place
	else if( indexPath.section == 1 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_top_bg.png"]];
		
		// Trip
		UIButton *tripButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		tripButton.frame = CGRectMake( 15, 16, 85, 86 );
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_trip.png"] forState:UIControlStateNormal];
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_trip_selected.png"] forState:UIControlStateSelected];
		[tripButton addTarget:self action:@selector(tripButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:tripButton];
		
		_tripLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, 102, 85, 40 )];
		_tripLabel.backgroundColor = [UIColor clearColor];
		_tripLabel.numberOfLines = 2;
		_tripLabel.font = [UIFont boldSystemFontOfSize:13];
		_tripLabel.textAlignment = UITextAlignmentCenter;
		_tripLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
		_tripLabel.text = @"스테이크 무한리필 탐험대";
		[cell addSubview:_tripLabel];
		
		// Place
		UIButton *placeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		placeButton.frame = CGRectMake( 118, 16, 85, 86 );
		[placeButton setBackgroundImage:[UIImage imageNamed:@"button_place.png"] forState:UIControlStateNormal];
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_place_selected.png"] forState:UIControlStateSelected];
		[placeButton addTarget:self action:@selector(placeButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:placeButton];
		
		_placeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 118, 102, 85, 40 )];
		_placeLabel.backgroundColor = [UIColor clearColor];
		_placeLabel.numberOfLines = 2;
		_placeLabel.font = [UIFont boldSystemFontOfSize:13];
		_placeLabel.textAlignment = UITextAlignmentCenter;
		_placeLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
		_placeLabel.text = @"까르니 두 브라질 강남점";
		[cell addSubview:_placeLabel];
		
		// Date
		UIButton *dateButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		dateButton.frame = CGRectMake( 221, 16, 85, 86 );
		dateButton.selected = YES;
		[dateButton setBackgroundImage:[UIImage imageNamed:@"button_date.png"] forState:UIControlStateNormal];
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_date_selected.png"] forState:UIControlStateSelected];
		[dateButton addTarget:self action:@selector(dateButtonDidTouchDown:) forControlEvents:UIControlEventTouchDown];
		[dateButton addTarget:self action:@selector(dateButtonDidTouchDown:) forControlEvents:UIControlEventTouchDragEnter];
		[dateButton addTarget:self action:@selector(dateButtonDidTouchCancel:) forControlEvents:UIControlEventTouchCancel];
		[dateButton addTarget:self action:@selector(dateButtonDidTouchCancel:) forControlEvents:UIControlEventTouchDragOutside];
		[dateButton addTarget:self action:@selector(dateButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:dateButton];
		
		_dateButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake( 13, 22, 60, 52 )];
		_dateButtonLabel.font = [UIFont boldSystemFontOfSize:36];
		_dateButtonLabel.textColor = [UIColor colorWithRed:0.90 green:0.77 blue:0.66 alpha:1.0];
		_dateButtonLabel.textAlignment = UITextAlignmentCenter;
		_dateButtonLabel.text = @"30";
		_dateButtonLabel.backgroundColor = [UIColor clearColor];
		_dateButtonLabel.shadowColor = [UIColor whiteColor];
		_dateButtonLabel.shadowOffset = CGSizeMake( 0, 0.3 );
		_dateButtonLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		_dateButtonLabel.layer.shadowOpacity = 0.3;
		_dateButtonLabel.layer.shadowRadius = 0.2;
		_dateButtonLabel.layer.shadowOffset = CGSizeMake( 0, -1 );
		_dateButtonLabel.layer.masksToBounds = YES;
		[dateButton addSubview:_dateButtonLabel];
		
		_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 221, 102, 85, 40 )];
		_dateLabel.backgroundColor = [UIColor clearColor];
		_dateLabel.numberOfLines = 2;
		_dateLabel.font = [UIFont boldSystemFontOfSize:13];
		_dateLabel.textAlignment = UITextAlignmentCenter;
		_dateLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
		[cell addSubview:_dateLabel];
		[self fillDateLabelText];
	}
	
	// Review
	else if( indexPath.section == 2 )
	{
		_reviewCell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		
		_reviewInput = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake( 12, 7, 296, 166 )];
		_reviewInput.font = [UIFont systemFontOfSize:15];
		_reviewInput.backgroundColor = [UIColor clearColor];
		_reviewInput.placeholder = @"Review";
		_reviewInput.editable = YES;
		[cell addSubview:_reviewInput];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToKeyboardPosition) name:UITextViewTextDidBeginEditingNotification object:nil];
	}
	
	// Info
	else if( indexPath.section == 3 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake( 100, 12, cell.frame.size.width - 110, cell.frame.size.height - 24 )];
		[cell addSubview:textField];
	}
	
	// Save to local
	else if( indexPath.section == 4 )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.textLabel.text = @"Save to local";
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [[tableView cellForRowAtIndexPath:indexPath] retain];
	cell.selected = NO;
	
	if( indexPath.section == 2 )
	{
		[self scrollToKeyboardPosition];
	}
	else if( indexPath.section == 4 )
	{
		if( cell.accessoryType == UITableViewCellAccessoryCheckmark )
			cell.accessoryType = UITableViewCellAccessoryNone;
		else
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
	[cell release];
}


#pragma mark -
#pragma mark Selectors

- (void)tripButtonDidTouchUpInside
{
	
}

- (void)placeButtonDidTouchUpInside
{
	
}

- (void)dateButtonDidTouchDown:(id)sender
{
	[_dateButtonLabel setTextColor:[UIColor colorWithRed:0.48 green:0.41 blue:0.35 alpha:1.0]];
}

- (void)dateButtonDidTouchCancel:(id)sender
{
	[_dateButtonLabel setTextColor:[UIColor colorWithRed:0.90 green:0.77 blue:0.66 alpha:1.0]];
}

- (void)dateButtonDidTouchUpInside:(id)sender
{
	[self dateButtonDidTouchCancel:sender];
	
	UIViewController *rootViewController = [[TimeSelectionViewController alloc] initWithShareViewController:self];
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:rootViewController];
	[self presentModalViewController:navigationController animated:YES];
}


#pragma mark -
#pragma mark Utils

- (void)fillDateLabelText
{
	_dateLabel.text = [Utils stringWithDate:selectedDate andTime:selectedTime];
	_dateButtonLabel.text = [Utils onlyDateWithDate:selectedDate];
}

- (void)scrollToKeyboardPosition
{
	[_tableView setContentOffset:CGPointMake( 0, _reviewCell.frame.origin.y - 7 ) animated:YES];
}

@end
