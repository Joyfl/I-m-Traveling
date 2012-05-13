//
//  LoginViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 25..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsManager.h"
#import "Const.h"
#import "Utils.h"
#import "PrivacyViewController.h"
#import "ImTravelingNavigationController.h"

@implementation LoginViewController

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		
		_emailInput = [[UITextField alloc] initWithFrame:CGRectMake( 60, 30, 200, 31 )];
		_emailInput.borderStyle = UITextBorderStyleRoundedRect;
		_emailInput.placeholder = @"Email";
		_emailInput.keyboardType = UIKeyboardTypeEmailAddress;
		_emailInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self.view addSubview:_emailInput];
		[_emailInput release];
		
		_passwordInput = [[UITextField alloc] initWithFrame:CGRectMake( 60, 70, 200, 31 )];
		_passwordInput.borderStyle = UITextBorderStyleRoundedRect;
		_passwordInput.placeholder = @"Password";
		_passwordInput.secureTextEntry = YES;
		_passwordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self.view addSubview:_passwordInput];
		[_passwordInput release];
		
		UIButton *loginButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		loginButton.frame = CGRectMake( 60, 110, 200, 37 );
		[loginButton setTitle:@"Login" forState:UIControlStateNormal];
		[loginButton addTarget:self action:@selector(loginButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:loginButton];
		[loginButton release];
		
		UIButton *signUpButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		signUpButton.frame = CGRectMake( 60, 150, 200, 37 );
		[signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
		[signUpButton addTarget:self action:@selector(signUpButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:signUpButton];
		[signUpButton release];
	}
	
	return self;
}


#pragma mark -
#pragma mark Navigation Button Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Login

- (void)loginButtonDidTouchUpInside
{
	NSString *email = _emailInput.text;
	if( email.length == 0 )
	{
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"INVALID_EMAIL", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSString *password = _passwordInput.text;
	if( password.length == 0 )
	{
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"INVALID_PASSWORD", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	[self loginWithEmail:email andPassword:[Utils sha1:password]];
}

- (void)signUpButtonDidTouchUpInside
{
	PrivacyViewController *privacyViewController = [[PrivacyViewController alloc] init];	
	[self.navigationController pushViewController:privacyViewController animated:YES];
	[privacyViewController release];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
	[[SettingsManager manager] setSetting:email forKey:SETTING_KEY_EMAIL];
	[[SettingsManager manager] setSetting:password forKey:SETTING_KEY_PASSWORD];
	
	[self.loader loadURL:[NSString stringWithFormat:@"%@?email=%@&password=%@", API_LOGIN, email, password] withData:nil andId:0];
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [self isError:json] )
	{
		[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"LOGIN_FAILED_MSG", @"" ) delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSDictionary *result = [json objectForKey:@"result"];
	
	NSNumber *userId = (NSNumber *)[result objectForKey:@"user_id"];
	NSString *name = [result objectForKey:@"name"];
	[[SettingsManager manager] setSetting:userId forKey:SETTING_KEY_USER_ID];
	[[SettingsManager manager] setSetting:name forKey:SETTING_KEY_USER_NAME];
	[[SettingsManager manager] flush];
	
	[self dismissModalViewControllerAnimated:YES];
}

@end
