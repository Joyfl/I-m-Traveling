//
//  PrivacyViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "TemsAndConditionsViewController.h"
#import "ImTravelingBarButtonItem.h"

@implementation TemsAndConditionsViewController

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		ImTravelingBarButtonItem *closeButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeNormal title:NSLocalizedString( @"CLOSE", @"" ) target:self action:@selector(closeButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = closeButton;
		self.navigationItem.title = NSLocalizedString( @"TERMS_AND_CONDITIONS", @"" );
		
		UITextView *termsAndConditionsView = [[UITextView alloc] initWithFrame:CGRectMake( 10, 10, 300, 300 )];
		NSString *path = [[NSBundle mainBundle] pathForResource:NSLocalizedString( @"TERMS_AND_CONDITIONS_FILE", @"" ) ofType:@"txt"];
		termsAndConditionsView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		termsAndConditionsView.editable = NO;
		[self.view addSubview:termsAndConditionsView];
		[termsAndConditionsView release];
	}
	
	return self;
}

- (void)closeButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
