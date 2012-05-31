//
//  TripAddViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TripAddViewController.h"
#import "Utils.h"
#import "TripObject.h"
#import "TripListViewController.h"
#import "Const.h"
#import "ImTravelingBarButtonItem.h"
#import "UploadManager.h"


@implementation TripAddViewController

@synthesize tripListViewController;

- (id)init
{
	if( self = [super init] )
	{
		self.navigationItem.title = NSLocalizedString( @"TITLE_TRIP_ADD", @"" );
		
		ImTravelingBarButtonItem *cancelButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CANCEL", @"" ) target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		ImTravelingBarButtonItem *doneButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"DONE", @"" ) target:self action:@selector(doneButtonDidTouchUpInside)];
		self.navigationItem.rightBarButtonItem = doneButton;
		[doneButton release];
		
		UIImageView *titleInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_add_title_bg.png"]];
		[self.view addSubview:titleInputBackground];
		[titleInputBackground release];
		
		_titleInput = [[UITextField alloc] initWithFrame:CGRectMake( 20, 13, 300, 31 )];
		_titleInput.placeholder = NSLocalizedString( @"TRIP_TITLE", @"" );
		_titleInput.backgroundColor = [UIColor clearColor];
		_titleInput.font = [UIFont boldSystemFontOfSize:15];
		[_titleInput becomeFirstResponder];
		[self.view addSubview:_titleInput];
		
		UIImageView *summaryInputBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trip_add_summary_bg.png"]];
		summaryInputBackground.frame = CGRectMake( 0, 50, summaryInputBackground.frame.size.width, summaryInputBackground.frame.size.height );
		[self.view addSubview:summaryInputBackground];
		[summaryInputBackground release];
		
		_summaryInput = [[UITextView alloc] initWithFrame:CGRectMake( 10, 70, 300, 62 )];
		_summaryInput.editable = YES;
		_summaryInput.backgroundColor = [UIColor clearColor];
		_summaryInput.font = [UIFont systemFontOfSize:14];
		[self.view addSubview:_summaryInput];
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
	if( _titleInput.text.length == 0 || _summaryInput.text.length == 0 )
	{
		DLog( @"제목이나 요약이 비었음!!" );
		return;
	}
	
	NSMutableDictionary *trip = [[NSMutableDictionary alloc] init];
	[trip setObject:_titleInput.text forKey:@"trip_title"];
	[trip setObject:_summaryInput.text forKey:@"summary"];
	NSInteger localTripId = [[UploadManager manager] addTrip:trip];
	[trip release];
	
	// ShareViewController - TripListViewController에서 여행 추가 버튼을 눌러 들어온 경우
	// 여행을 추가하면 추가한 여행이 자동으로 선택되어지도록 한다.
	if( tripListViewController != nil )
	{
		// Upload할 때에는 trip id와 title밖에 필요가 없음.
		TripObject *trip = [[TripObject alloc] init];
		trip.tripId = localTripId;
		trip.title = _titleInput.text;
		[tripListViewController selectTrip:trip];
		[trip release];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
