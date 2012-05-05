//
//  SignUpViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SignUpViewController.h"


@implementation SignUpViewController

- (id)init
{
	if( self = [super init] )
	{
		_emailInput = [[UITextField alloc] initWithFrame:CGRectMake( 10, 10, 300, 31 )];
		_emailInput.borderStyle = UITextBorderStyleRoundedRect;
		_emailInput.placeholder = @"Email";
		_emailInput.keyboardType = UIKeyboardTypeEmailAddress;
		[self.view addSubview:_emailInput];
		
		_passwordInput = [[UITextField alloc] initWithFrame:CGRectMake( 10, 50, 300, 31 )];
		_passwordInput.borderStyle = UITextBorderStyleRoundedRect;
		_passwordInput.secureTextEntry = YES;
		_passwordInput.placeholder = @"Password";
		[self.view addSubview:_passwordInput];
		
		_passwordCheckInput = [[UITextField alloc] initWithFrame:CGRectMake( 10, 90, 300, 31 )];
		_passwordCheckInput.borderStyle = UITextBorderStyleRoundedRect;
		_passwordCheckInput.secureTextEntry = YES;
		_passwordCheckInput.placeholder = @"Verify Password";
		[self.view addSubview:_passwordCheckInput];
	}
	
	return self;
}

@end
