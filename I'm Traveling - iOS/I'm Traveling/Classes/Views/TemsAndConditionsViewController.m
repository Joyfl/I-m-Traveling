//
//  PrivacyViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "PrivacyViewController.h"
#import "SignUpViewController.h"

@implementation PrivacyViewController

- (id)init
{
	if( self = [super init] )
	{
		UITextView *privacyView = [[UITextView alloc] initWithFrame:CGRectMake( 10, 10, 300, 300 )];
		NSString *path = [[NSBundle mainBundle] pathForResource:NSLocalizedString( @"PRIVACY_FILE", @"" ) ofType:@"txt"];
		privacyView.text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		privacyView.editable = NO;
		[self.view addSubview:privacyView];
		[privacyView release];
		
		UIButton *checkBox = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		checkBox.frame = CGRectMake( 10, 320, 20, 20 );
		[checkBox addTarget:self action:@selector(checkBoxDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:checkBox];
		
		UILabel *agreeLabel = [[UILabel alloc] initWithFrame:CGRectMake( 40, 320, 280, 20 )];
		agreeLabel.text = NSLocalizedString( @"PRIVACY_AGREE", @"" );
		[self.view addSubview:agreeLabel];
		[agreeLabel release];
	}
	
	return self;
}

- (void)checkBoxDidTouchUpInside
{
	SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
	[self.navigationController pushViewController:signUpViewController animated:YES];
}

@end
