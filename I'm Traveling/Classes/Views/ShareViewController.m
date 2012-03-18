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
#import "Info.h"
#import "InfoCell.h"

@interface ShareViewController()

- (void)scrollToKeyboardPosition:(id)object;
- (void)updateRowOfInfoCell:(InfoCell *)cell row:(NSInteger)row;
- (void)updateRowOfInfoCells;
- (void)resizeLabelHeight:(UILabel *)label;
- (void)upload;

@end


@implementation ShareViewController

@synthesize selectedTrip, selectedPlace, selectedDate, selectedTime;

enum {
	kSectionImage = 0,
	kSectionTripPlaceDate = 1,
	kSectionReview = 2,
	kSectionInfo = 3,
	kSectionAddInfo = 4,
	kSectionSaveToLocal = 5
};

-(id)initWithImage:(UIImage *)image
{
    if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor grayColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(uploadButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = uploadButton;
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 416 ) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor darkGrayColor];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:_tableView];
		
		_image = [image retain];
		
		_info = [[NSMutableArray alloc] init];
		
		selectedDate = [[NSDate alloc] init];
		selectedTime = [[NSDate alloc] init];
		
		_dismissKeyboardButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		_dismissKeyboardButton.frame = CGRectMake( 320-80-10, 416-216-37+10, 80, 37 );
		[_dismissKeyboardButton addTarget:self action:@selector(dismissKeyboardButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
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
	[[[[UIAlertView alloc] initWithTitle:@"Cancel" message:@"Do you really want to cancel?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] autorelease] show];
}

- (void)uploadButtonDidTouchUpInside
{
	[self upload];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( buttonIndex == 1 )
		[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	// 0 : Image
	// 1 : Trip, Place, Date
	// 2 : Review
	// 3 : Info
	// 4 : Add Info
	// 5 : Save to local
	return 6;
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
	switch( indexPath.section )
	{
		case kSectionImage:
			return _image.size.height * 321 / _image.size.width;
			
		case kSectionTripPlaceDate:
			return 150;
			
		case kSectionReview:
			return 190;
			
		case kSectionInfo:
			return 80;
			
		case kSectionAddInfo:
			return 80;
	}
	
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = nil;
	
	// Image
	if( indexPath.section == kSectionImage )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.imageView.image = _image;
		
		if( _imageTopBorder == nil )
		{
			_imageTopBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_image_top_border.png"]];
			_imageTopBorder.hidden = YES;
		}
		[cell addSubview:_imageTopBorder];
	}
	
	// Trip, Date, Place
	else if( indexPath.section == kSectionTripPlaceDate )
	{
		cell = [[UITableViewCell alloc] init];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_top_bg.png"]];
		
		// Trip
		UIButton *tripButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		tripButton.frame = CGRectMake( 15, 16, 85, 86 );
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_trip.png"] forState:UIControlStateNormal];
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_trip_selected.png"] forState:UIControlStateSelected];
		[tripButton addTarget:self action:@selector(tripButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:tripButton];
		
		if( _tripLabel == nil )
		{
			_tripLabel = [[UILabel alloc] initWithFrame:CGRectMake( 15, 102, 85, 40 )];
			_tripLabel.backgroundColor = [UIColor clearColor];
			_tripLabel.numberOfLines = 2;
			_tripLabel.font = [UIFont boldSystemFontOfSize:13];
			_tripLabel.textAlignment = UITextAlignmentCenter;
			_tripLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
			_tripLabel.text = @"여행을 선택해주세요.";
		}
		[cell addSubview:_tripLabel];
		
		// Place
		UIButton *placeButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		placeButton.frame = CGRectMake( 118, 16, 85, 86 );
		[placeButton setBackgroundImage:[UIImage imageNamed:@"button_place.png"] forState:UIControlStateNormal];
		[tripButton setBackgroundImage:[UIImage imageNamed:@"button_place_selected.png"] forState:UIControlStateSelected];
		[placeButton addTarget:self action:@selector(placeButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:placeButton];
		
		if( _placeLabel == nil )
		{
			_placeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 118, 102, 85, 40 )];
			_placeLabel.backgroundColor = [UIColor clearColor];
			_placeLabel.numberOfLines = 2;
			_placeLabel.font = [UIFont boldSystemFontOfSize:13];
			_placeLabel.textAlignment = UITextAlignmentCenter;
			_placeLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
			_placeLabel.text = @"장소를 선택해주세요.";
		}
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
		
		if( _dateButtonLabel == nil )
		{
			_dateButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake( 13, 22, 60, 52 )];
			_dateButtonLabel.font = [UIFont boldSystemFontOfSize:36];
			_dateButtonLabel.textColor = [UIColor colorWithRed:0.90 green:0.77 blue:0.66 alpha:1.0];
			_dateButtonLabel.textAlignment = UITextAlignmentCenter;
			_dateButtonLabel.text = [Utils onlyDateWithDate:[NSDate date]];
			_dateButtonLabel.backgroundColor = [UIColor clearColor];
			_dateButtonLabel.shadowColor = [UIColor whiteColor];
			_dateButtonLabel.shadowOffset = CGSizeMake( 0, 0.3 );
			_dateButtonLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
			_dateButtonLabel.layer.shadowOpacity = 0.3;
			_dateButtonLabel.layer.shadowRadius = 0.2;
			_dateButtonLabel.layer.shadowOffset = CGSizeMake( 0, -1 );
			_dateButtonLabel.layer.masksToBounds = YES;
		}
		[dateButton addSubview:_dateButtonLabel];
		
		if( _dateLabel == nil )
		{
			_dateLabel = [[UILabel alloc] initWithFrame:CGRectMake( 221, 102, 85, 40 )];
			_dateLabel.backgroundColor = [UIColor clearColor];
			_dateLabel.numberOfLines = 2;
			_dateLabel.font = [UIFont boldSystemFontOfSize:13];
			_dateLabel.textAlignment = UITextAlignmentCenter;
			_dateLabel.textColor = [UIColor colorWithRed:0.17 green:0.15 blue:0.20 alpha:1.0];
		}
		[cell addSubview:_dateLabel];
		[self updateDateLabelText];
	}
	
	// Review
	else if( indexPath.section == kSectionReview )
	{
		_reviewCell = cell = [[UITableViewCell alloc] init];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_review_bg.png"]];
		[cell addSubview:bg];
		
		if( _reviewInput == nil )
		{
			_reviewInput = [[UITextView alloc] initWithFrame:CGRectMake( 4, 25, 312, 136 )];
			_reviewInput.font = [UIFont systemFontOfSize:14];
			_reviewInput.backgroundColor = [UIColor clearColor];
			_reviewInput.editable = YES;
			_reviewInput.textColor = [UIColor colorWithRed:0.317 green:0.239 blue:0.168 alpha:1.0];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditting:) name:UITextViewTextDidBeginEditingNotification object:nil];
		}
		[cell addSubview:_reviewInput];
	}
	
	// Info
	else if( indexPath.section == kSectionInfo )
	{
		static NSString *infoCellId = @"infoCellId";
		cell = [_tableView dequeueReusableCellWithIdentifier:infoCellId];
		if( cell == nil )
		{
			cell = [[InfoCell alloc] initWithRow:indexPath.row shareViewController:self andReuseIdentifier:infoCellId];
			
			UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
			bg.backgroundColor = [UIColor colorWithRed:0.937 green:0.831 blue:0.737 alpha:1.0];
			cell.backgroundView = bg;
		}
		else
		{
			Info *info = (Info *)[_info objectAtIndex:indexPath.row];
			[(InfoCell *)cell itemInput].text = info.item;
			[(InfoCell *)cell valueInput].text = [NSString stringWithFormat:@"%d", info.value];
			[(InfoCell *)cell unitButton].titleLabel.text = info.unit;
			
			[self updateRowOfInfoCell:(InfoCell *)cell row:indexPath.row];
		}
	}
	
	// Add Info
	else if( indexPath.section == kSectionAddInfo )
	{
		cell = [[UITableViewCell alloc] init];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
		bg.backgroundColor = [UIColor colorWithRed:0.937 green:0.831 blue:0.737 alpha:1.0];
		cell.backgroundView = bg;
		[bg release];
		
		UIButton *plusButton = [[UIButton alloc] initWithFrame:CGRectMake( 9, 27, 20, 20 )];
		[plusButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
		[plusButton addTarget:self action:@selector(plusButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:plusButton];
		[plusButton release];
		
		UIButton *postIt = [[UIButton alloc] initWithFrame:CGRectMake( 39, 6, 260, 68 )];
		[postIt setBackgroundImage:[UIImage imageNamed:@"postit_empty.png"] forState:UIControlStateNormal];
		[postIt addTarget:self action:@selector(plusButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:postIt];
		[postIt release];
	}
	
	// Save to local
	else if( indexPath.section == kSectionSaveToLocal )
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.textLabel.text = @"Save to local";
		cell.textLabel.backgroundColor = [UIColor clearColor];
		cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
		bg.backgroundColor = [UIColor colorWithRed:0.937 green:0.831 blue:0.737 alpha:1.0];
		cell.backgroundView = bg;
		[bg release];
		
		UISwitch *saveToLocalSwitch = [[UISwitch alloc] init];
		CGRect frame = saveToLocalSwitch.frame;
		frame.origin.x = 220;
		frame.origin.y = 7;
		saveToLocalSwitch.frame = frame;
		[saveToLocalSwitch addTarget:self action:@selector(saveToLocalSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
		[cell addSubview:saveToLocalSwitch];
		[saveToLocalSwitch release];
	}
	
	return cell;
}


#pragma mark -
#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = YES;
}


#pragma mark -
#pragma mark Selectors

- (void)tripButtonDidTouchUpInside
{
	TripListViewController *tripSelectionViewController = [[TripListViewController alloc] initWithShareViewController:self];
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:tripSelectionViewController];
	[self presentModalViewController:navigationController animated:YES];
}

- (void)placeButtonDidTouchUpInside
{
	PlaceSelectionViewController *placeSelectionViewController = [[PlaceSelectionViewController alloc] initWithShareViewController:self];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:placeSelectionViewController];
	[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar_no_line.png"] forBarMetrics:UIBarMetricsDefault];
	[self presentModalViewController:navigationController animated:YES];
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

- (void)plusButtonDidTouchUpInside
{
	NSInteger row = _info.count;
	Info *info = [[Info alloc] init];
	info.unit = @"KRW";
	[_info addObject:info];
	
	[_tableView beginUpdates];
	[_tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:kSectionInfo]] withRowAnimation:UITableViewRowAnimationNone];
	[_tableView endUpdates];
}

- (void)minusButtonDidTouchUpInside:(id)sender
{
	NSInteger row = [sender tag];
	NSLog( @"minus button (row : %d)", row );
	
	[_info removeObjectAtIndex:row];
	
	[_tableView beginUpdates];
	[_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:kSectionInfo]] withRowAnimation:UITableViewRowAnimationBottom];
	[_tableView endUpdates];
	
	[self updateRowOfInfoCells];
}

- (void)textDidBeginEditting:(id)sender
{
	// Review
	if( ![sender isKindOfClass:[UITextField class]] )
		_currentFirstResponder = _reviewInput;
	
	// Info
	else
		_currentFirstResponder = sender;
	
	[self scrollToKeyboardPosition:sender];
}

- (void)itemInputEdittingChanged:(id)sender
{
	UITextField *itemInput = (UITextField *)sender;
	NSInteger row = itemInput.tag;
	
	Info *info = [_info objectAtIndex:row];
	info.item = itemInput.text;
	
	[_info replaceObjectAtIndex:row withObject:info];
}

- (void)valueInputEdittingChanged:(id)sender
{
	UITextField *valueInput = (UITextField *)sender;
	NSInteger row = valueInput.tag;
	NSInteger value = [[valueInput.text stringByReplacingOccurrencesOfString:@"," withString:@""] integerValue];
	
	Info *info = [_info objectAtIndex:row];
	info.value = value;
	[_info replaceObjectAtIndex:row withObject:info];
	
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	formatter.numberStyle = NSNumberFormatterDecimalStyle;
	
	// valueInputEdittingChanged가 한번 더 호출되지 않도록 지웠다가 다시 추가
	[valueInput removeTarget:self action:@selector(valueInputEdittingChanged:) forControlEvents:UIControlEventEditingChanged];
	valueInput.text = [formatter stringFromNumber:[NSNumber numberWithInteger:value]];
	[valueInput addTarget:self action:@selector(valueInputEdittingChanged:) forControlEvents:UIControlEventEditingChanged];
	
	[formatter release];
}

- (void)unitButtonDidTouchUpInside
{
	NSLog( @"unit" );
}

- (void)keyboardDidShow
{
	[self.view addSubview:_dismissKeyboardButton];
}

- (void)keyboardWillHide
{
	[_dismissKeyboardButton removeFromSuperview];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	[_tableView setFrame:CGRectMake( 0, 0, 320, 416 )];
	[UIView commitAnimations];
}

- (void)dismissKeyboardButtonDidTouchUpInside
{
	if( _currentFirstResponder != nil )
	{
		[_currentFirstResponder resignFirstResponder];
	}
}

- (void)saveToLocalSwitchValueChanged:(id)sender
{
	_saveToLocal = [(UISwitch *)sender isOn];
}


#pragma mark -
#pragma mark Utils

- (void)updateTripLabelText
{
	_tripLabel.text = selectedTrip.title;
	[self resizeLabelHeight:_tripLabel];
}

- (void)updatePlaceLabelText
{
	_placeLabel.text = selectedPlace.name;
	[self resizeLabelHeight:_placeLabel];
}

- (void)updateDateLabelText
{
	_dateLabel.text = [Utils stringWithDate:selectedDate andTime:selectedTime];
	[self resizeLabelHeight:_dateLabel];
	
	_dateButtonLabel.text = [Utils onlyDateWithDate:selectedDate];
}

- (void)resizeLabelHeight:(UILabel *)label
{
	CGRect frame = label.frame;
	frame.size.height = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake( 85, 40 ) lineBreakMode:label.lineBreakMode].height;
	label.frame = frame;
}

- (void)scrollToKeyboardPosition:(id)object
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	[_tableView setFrame:CGRectMake( 0, 0, 320, 200 )];
	[UIView commitAnimations];
	
	CGFloat y;
	
	// Review
	if( ![object isKindOfClass:[UITextField class]] )
		y = _reviewCell.frame.origin.y - 7;
	
	// Info
	else
		y = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[object tag] inSection:kSectionInfo]].frame.origin.y - 7;
	
	[_tableView setContentOffset:CGPointMake( 0, y ) animated:YES];
}

- (void)updateRowOfInfoCell:(InfoCell *)cell row:(NSInteger)row
{
	cell.minusButton.tag = row;
	cell.itemInput.tag = row;
	cell.valueInput.tag = row;
	cell.unitButton.tag = row;
}

- (void)updateRowOfInfoCells
{
	NSInteger numberOfRows = [_tableView numberOfRowsInSection:kSectionInfo];
	for( NSInteger i = 0; i < numberOfRows; i++ )
	{
		InfoCell *cell = (InfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:kSectionInfo]];
		[self updateRowOfInfoCell:cell row:i];
	}
}


#pragma mark -
#pragma mark Upload

- (void)upload
{
	NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
	
	// user id
	[data setObject:[NSNumber numberWithInteger:[Utils userId]] forKey:@"user_id"];
	
	// email
	[data setObject:[Utils email] forKey:@"email"];
	
	// password
	[data setObject:[Utils password] forKey:@"password"];
	
	// picture
	[data setObject:_image forKey:@"picture"];
	
	// trip id
	[data setObject:[NSNumber numberWithInteger:selectedTrip.tripId] forKey:@"trip_id"];
	
	// place id
	[data setObject:[NSNumber numberWithInteger:selectedPlace.placeId] forKey:@"place_id"];
	
	// time
//	[data setObject:[_dateLabel.text stringByReplacingOccurrencesOfString:@"\n" withString:@" "] forKey:@"time"];
	[data setObject:[Utils dateStringForUpload:selectedDate] forKey:@"time"];
	
	// latitude, longitude
	if( selectedPlace != nil )
	{
		[data setObject:[NSNumber numberWithDouble:selectedPlace.latitude] forKey:@"latitude"];
		[data setObject:[NSNumber numberWithDouble:selectedPlace.longitude] forKey:@"longitude"];
	}
	else
	{
		[data setObject:[NSNumber numberWithDouble:selectedPlace.latitude] forKey:@"latitude"];
		[data setObject:[NSNumber numberWithDouble:selectedPlace.longitude] forKey:@"longitude"];
	}
	
	// nation
#warning nation 임시
	[data setObject:@"KOR" forKey:@"nation"];
	
	// review
	[data setObject:_reviewInput.text forKey:@"review"];
	
	// info
	NSMutableArray *info = [[NSMutableArray alloc] init];
	for( NSInteger i = 0; i < _info.count; i++ )
		[info addObject:[[_info objectAtIndex:i] dictionary]];
	
	[data setObject:[Utils writeJSON:info] forKey:@"info"];
	
	NSLog( @"%@", data );
	[self loadURLPOST:API_UPLOAD withData:data];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSLog( @"upload result : %@", result );
	[self dismissModalViewControllerAnimated:YES];
}

@end
