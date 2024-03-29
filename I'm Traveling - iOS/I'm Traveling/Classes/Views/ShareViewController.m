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
#import "ImTravelingBarButtonItem.h"
#import "TripListViewController.h"
#import "TimeSelectionViewController.h"
#import "PlaceSelectionViewController.h"
#import "Utils.h"
#import "Info.h"
#import "InfoCell.h"
#import "UploadManager.h"
#import "FacebookManager.h"
#import "AccountsViewController.h"


@implementation ShareViewController

@synthesize selectedTrip, selectedPlace, selectedDate, selectedTime;

enum {
	kSectionImage = 0,
	kSectionTripPlaceDate = 1,
	kSectionReview = 2,
	kSectionInfo = 3,
	kSectionAddInfo = 4,
	kSectionSNS = 5
};

-(id)initWithImage:(UIImage *)image
{
    if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_SHARE", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *uploadButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"UPLOAD", @"" ) target:self action:@selector(uploadButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = uploadButton;
		[uploadButton release];
		
		
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, 320, 416 ) style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.83 blue:0.73 alpha:1.0];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		[self.view addSubview:_tableView];		
		
		UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0, -300, 320, 300 )];
		topBackgroundView.backgroundColor = [UIColor darkGrayColor];
		[_tableView addSubview:topBackgroundView];
		[topBackgroundView release];
		
		UIImageView *grayLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_gray.png"]];
		grayLogo.center = CGPointMake( 160, -60 );
		[_tableView addSubview:grayLogo];
		[grayLogo release];
		
		_image = [image retain];
		
		_info = [[NSMutableArray alloc] init];
		
		selectedDate = [[NSDate alloc] init];
		selectedTime = [[NSDate alloc] init];
		
		CGFloat imageHeight = _image.size.height * 320 / _image.size.width;
		if( imageHeight > 240 )
			[_tableView setContentOffset:CGPointMake( 0, imageHeight - 240 ) animated:YES];
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

- (void)viewDidAppear:(BOOL)animated
{
	// presentModalViewController로 modalView 띄우고 다시 돌아오면 observer가 모두 제거되어있는 것 같음.
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditting:) name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];

	// 이거 작동이 안됨... 왜그런지 모르겠음.. 슈ㅣ발 ㅠㅠ
//	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tripLoadingDidFinish:) name:kTripLoadingFinishNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
//	[[NSNotificationCenter defaultCenter] removeObserver:self name:kTripLoadingFinishNotification object:nil];
}

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
	[[[[UIAlertView alloc] initWithTitle:@"Cancel" message:NSLocalizedString( @"ASK_CANCEL", @"Do you really want to cancel?" ) delegate:self cancelButtonTitle:NSLocalizedString( @"NO", @"No" ) otherButtonTitles:NSLocalizedString( @"YES", @"Yes" ), nil] autorelease] show];
}

// 업로드를 모두 UploadManager에서 관리하도록 한다.
// 업로드 버튼을 누르면 UploadManager로 넘어가고, UploadManager에서 네트워크 연결이 끊어지는 등의 오류도 함께 관리한다.
- (void)uploadButtonDidTouchUpInside
{
	[self startBusy];
	
	NSThread *uploadThread = [[NSThread alloc] initWithTarget:self selector:@selector(addFeedToUploadManager:) object:nil];
	[uploadThread start];
	[uploadThread release];
}

- (void)addFeedToUploadManager:(NSThread *)thread
{
	NSMutableArray *info = [NSMutableArray array];
	for( NSInteger i = 0; i < _info.count; i++ )
		[info addObject:[[_info objectAtIndex:i] dictionary]];
	
	NSInteger width = _image.size.width;
	NSInteger height = _image.size.height;	
	if( width > 1024 )
	{
		height = height * 1024 / width;
		width = 1024;
	}
	
	if( height > 1024 )
	{
		width = width * 1024 / height;
		height = 1024;
	}
	
	UIGraphicsBeginImageContext( CGSizeMake( width, height ) );
	[_image drawInRect:CGRectMake( 0, 0, width, height )];
	UIImage *picture = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSMutableDictionary *feed = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								 UIImagePNGRepresentation( picture ), @"picture",
								 [NSNumber numberWithInteger:selectedTrip.tripId], @"trip_id",
								 [NSNumber numberWithInteger:selectedPlace.placeId], @"place_id",
								 [Utils dateStringForUpload:selectedDate], @"time",
								 [NSNumber numberWithDouble:selectedPlace.latitude], @"latitude",
								 [NSNumber numberWithDouble:selectedPlace.longitude], @"longitude",
#warning 임시 nation!!
								 @"KOR", @"nation",
								 _reviewInput.text, @"review",
								 [Utils writeJSON:info], @"info", nil];
	
	if( _shareToFacebook )
	{
		[feed setObject:[NSNumber numberWithBool:YES] forKey:@"share_to_facebook"];
		[feed setObject:selectedTrip.facebookAlbumId forKey:@"facebook_album_id"];
	}
	
	[[UploadManager manager] performSelectorOnMainThread:@selector(addFeed:) withObject:feed waitUntilDone:NO];
	
	[self stopBusy];
	[self performSelectorOnMainThread:@selector(finishAddingFeedToUploadManager) withObject:nil waitUntilDone:NO];
}

- (void)finishAddingFeedToUploadManager
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)tripLoadingDidFinishWithTripId:(NSInteger)tripId andLocalTripId:(NSInteger)localTripId
{
	NSLog( @"tripLoadingDidFinish (localTripId=%d, tripId=%d)", localTripId, tripId );
	
	if( selectedTrip.tripId == localTripId )
		selectedTrip.tripId = tripId;
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if( ( [alertView.message isEqualToString:NSLocalizedString( @"ASK_CANCEL", @"" )] && buttonIndex == 1 )
	   || [alertView.message isEqualToString:NSLocalizedString( @"NETWORK_CONNECTION_LOST_WHILE_UPLOADING", @"" )] )
	{
		[self dismissModalViewControllerAnimated:YES];
	}
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
	// 5 : SNS
	return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if( section == kSectionInfo ) return _info.count;
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
			
		case kSectionSNS:
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
			_tripLabel.text = NSLocalizedString( @"SELECT_A_TRIP", @"여행을 선택해주세요." );
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
			_placeLabel.text = NSLocalizedString( @"SELECT_A_PLACE", @"장소를 선택해주세요." );
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
			_dateButtonLabel.text = [Utils onlyDateWithDate:selectedDate];
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
	
	else if( indexPath.section == kSectionSNS )
	{
		cell = [[UITableViewCell alloc] init];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_facebookButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		_facebookButton.frame = CGRectMake( 10, 0, 50, 50 );
		[_facebookButton addTarget:self action:@selector(facebookButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[cell addSubview:_facebookButton];
	}
	
	return cell;
}


#pragma mark -
#pragma mark UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = NO;
	if( _currentFirstResponder )
		[_currentFirstResponder resignFirstResponder];
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

- (void)keyboardWillHide
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	[_tableView setFrame:CGRectMake( 0, 0, 320, 416 )];
	[UIView commitAnimations];
}

- (void)facebookButtonDidTouchUpInside
{
	if( !_shareToFacebook )
	{
		if( [[FacebookManager manager] connected] )
		{
			_shareToFacebook = YES;
			[_facebookButton setTitle:@"F" forState:UIControlStateNormal];
		}
		else
		{
			AccountsViewController *accountsViewController = [[AccountsViewController alloc] init];
			[self.navigationController pushViewController:accountsViewController animated:YES];
			[accountsViewController release];
		}
	}
	else
	{
		_shareToFacebook = NO;
		[_facebookButton setTitle:@"" forState:UIControlStateNormal];
	}
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
#pragma mark Reachability

/*- (void)networkAvailabilityDidChange:(BOOL)available
{
	NSLog( @"networkAvailabilityDidChange" );
	
	if( _uploading ) NSLog( @"uploading" );
	if( available ) NSLog( @"available" );
	
	if( _uploading && !available )
	{
		_uploading = NO;
		[self stopBusy];
		
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"NETWORK_CONNECTION_LOST_WHILE_UPLOADING", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
	}
}*/

@end
