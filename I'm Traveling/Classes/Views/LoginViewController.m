//
//  LoginViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 25..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingsManager.h"
#import "CommonCrypto/CommonDigest.h"
#import "Const.h"
#import "Utils.h"

@interface LoginViewController (Private)

- (NSString *)sha1:(NSString *)input;

@end


@implementation LoginViewController

- (id)init
{
	if( self = [super init] )
	{
		self.view.backgroundColor = [UIColor whiteColor];
		
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		
		_emailInput = [[UITextField alloc] initWithFrame:CGRectMake( 60, 30, 200, 31 )];
		_emailInput.borderStyle = UITextBorderStyleRoundedRect;
		_emailInput.placeholder = @"Email";
		_emailInput.keyboardType = UIKeyboardTypeEmailAddress;
		_emailInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self.view addSubview:_emailInput];
		
		_passwordInput = [[UITextField alloc] initWithFrame:CGRectMake( 60, 70, 200, 31 )];
		_passwordInput.borderStyle = UITextBorderStyleRoundedRect;
		_passwordInput.placeholder = @"Password";
		_passwordInput.secureTextEntry = YES;
		_passwordInput.clearButtonMode = UITextFieldViewModeWhileEditing;
		[self.view addSubview:_passwordInput];
		
		UIButton *loginButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		loginButton.frame = CGRectMake( 60, 110, 200, 37 );
		[loginButton setTitle:@"Login" forState:UIControlStateNormal];
		[loginButton addTarget:self action:@selector(loginButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:loginButton];
		
		UIButton *signUpButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		signUpButton.frame = CGRectMake( 60, 150, 200, 37 );
		[signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
		[signUpButton addTarget:self action:@selector(signUpButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:signUpButton];
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
		[[[[UIAlertView alloc] initWithTitle:@"Invalid Email" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSString *password = _passwordInput.text;
	if( password.length == 0 )
	{
		[[[[UIAlertView alloc] initWithTitle:@"Invalid Password" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	[self loginWithEmail:email andPassword:[self sha1:password]];
}

- (void)signUpButtonDidTouchUpInside
{
	NSLog( @"sign up" );
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
	[[SettingsManager manager] setSetting:email forKey:SETTING_KEY_EMAIL];
	[[SettingsManager manager] setSetting:password forKey:SETTING_KEY_PASSWORD];
	
	[self loadURL:[NSString stringWithFormat:@"%@?email=%@&password=%@", API_LOGIN, email, password]];
}

- (void)loadingDidFinish:(NSString *)result
{
	NSDictionary *json = [Utils parseJSON:result];
	if( [json objectForKey:@"ERROR"] )
	{
		[[[[UIAlertView alloc] initWithTitle:@"ERROR" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
		return;
	}
	
	NSNumber *userId = (NSNumber *)[json objectForKey:@"RESULT"];
	[[SettingsManager manager] setSetting:userId forKey:SETTING_KEY_USER_ID];
	[[SettingsManager manager] flush];
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Crypto

- (NSString *)sha1:(NSString *)input
{
	NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1( data.bytes, data.length, digest );
	
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	for( int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++ )
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

@end
