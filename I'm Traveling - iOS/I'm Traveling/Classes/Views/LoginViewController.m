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
#import "SignUpViewController.h"
#import "ImTravelingNavigationController.h"
#import "QuartzCore/CALayer.h"

@implementation LoginViewController

- (id)init
{
	if( self = [super init] )
	{
		UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
		gestureRecognizer.cancelsTouchesInView = NO;
		[self.view addGestureRecognizer:gestureRecognizer];
		[gestureRecognizer release];
		
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imtraveling_bg.png"]];
		[self.view addSubview:bg];
		[bg release];
		
		UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
		cancelButton.frame = CGRectMake( 16, 32, 26, 26 );
		[cancelButton setBackgroundImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
		[cancelButton addTarget:self action:@selector(cancelButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:cancelButton];
		
		UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imtraveling_logo.png"]];
		logo.frame = CGRectMake( 104, 55, 115, 75 );
		[self.view addSubview:logo];
		[logo release];
		
		UIImageView *loginBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_box.png"]];
		loginBox.frame = CGRectMake( 22, 148, 277, 90 );
		[self.view addSubview:loginBox];
		[loginBox release];
		
		_emailInput = [[UITextField alloc] initWithFrame:CGRectMake( 38, 162, 245, 31 )];
		_emailInput.delegate = self;
		_emailInput.placeholder = NSLocalizedString( @"EMAIL", @"" );
		_emailInput.font = [UIFont boldSystemFontOfSize:15];
		_emailInput.textColor = [UIColor colorWithRed:0.392 green:0.313 blue:0.250 alpha:1.0];
		_emailInput.layer.shadowOffset = CGSizeMake( 0, 1 );
		_emailInput.layer.shadowColor = [UIColor whiteColor].CGColor;
		_emailInput.layer.shadowOpacity = 0.5;
		_emailInput.layer.shadowRadius = 0;
		_emailInput.keyboardType = UIKeyboardTypeEmailAddress;
		_emailInput.returnKeyType = UIReturnKeyNext;
		_emailInput.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[_emailInput setValue:[UIColor colorWithRed:0.788 green:0.635 blue:0.517 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
		[_emailInput addTarget:self action:@selector(inputEditChanged:) forControlEvents:UIControlEventEditingChanged];
		[self.view addSubview:_emailInput];
		[_emailInput release];
		
		_passwordInput = [[UITextField alloc] initWithFrame:CGRectMake( 38, 203, 245, 31 )];
		_passwordInput.delegate = self;
		_passwordInput.placeholder = NSLocalizedString( @"PASSWORD", @"" );
		_passwordInput.font = [UIFont boldSystemFontOfSize:15];
		_passwordInput.textColor = [UIColor colorWithRed:0.392 green:0.313 blue:0.250 alpha:1.0];
		_passwordInput.layer.shadowOffset = CGSizeMake( 0, 1 );
		_passwordInput.layer.shadowColor = [UIColor whiteColor].CGColor;
		_passwordInput.layer.shadowOpacity = 0.5;
		_passwordInput.layer.shadowRadius = 0;
		_passwordInput.secureTextEntry = YES;
		_passwordInput.returnKeyType = UIReturnKeyGo;
		[_passwordInput setValue:[UIColor colorWithRed:0.788 green:0.635 blue:0.517 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
		[_passwordInput addTarget:self action:@selector(inputEditChanged:) forControlEvents:UIControlEventEditingChanged];
		[self.view addSubview:_passwordInput];
		[_passwordInput release];
		
		UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		signUpButton.frame = CGRectMake( 22, 235, 277, 37 );
		signUpButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
		signUpButton.titleLabel.shadowOffset = CGSizeMake( 0, 1 );
		[signUpButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
		[signUpButton setTitleColor:[UIColor colorWithRed:0.811 green:0.658 blue:0.541 alpha:1.0] forState:UIControlStateNormal];
		[signUpButton setTitle:NSLocalizedString( @"DO_NOT_HAVE_AN_ACCOUNT", @"" ) forState:UIControlStateNormal];
		[signUpButton addTarget:self action:@selector(signUpButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:signUpButton];
		[signUpButton release];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	self.navigationController.navigationBarHidden = YES;
}

- (void)dismissKeyboard
{
	DLog( @"bg" );
	[_emailInput resignFirstResponder];
	[_passwordInput resignFirstResponder];
}


#pragma mark -
#pragma mark Navigation Button Selectors

- (void)cancelButtonDidTouchUpInside
{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void)inputEditChanged:(id)sender
{
	UITextField *input = (UITextField *)sender;
	
	if( input.text.length > 0 )
		input.font = [UIFont systemFontOfSize:15];
	else
		input.font = [UIFont boldSystemFontOfSize:15];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if( textField == _emailInput )
	{
		[_passwordInput becomeFirstResponder];
		return NO;
	}
	
	NSString *email = _emailInput.text;
	if( email.length == 0 )
	{
		[_emailInput becomeFirstResponder];
		return NO;
	}
	
	NSString *password = _passwordInput.text;
	if( password.length == 0 )
	{
		[_passwordInput becomeFirstResponder];
		return NO;
	}
	
	[self loginWithEmail:email andPassword:[Utils sha1:password]];
	[textField resignFirstResponder];
	return NO;
}


#pragma mark -
#pragma mark Login

- (void)signUpButtonDidTouchUpInside
{
	SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
	[self.navigationController pushViewController:signUpViewController animated:YES];
	[signUpViewController release];
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password
{
	[self startBusy];
	
	[[SettingsManager manager] setSetting:email forKey:SETTING_KEY_EMAIL];
	[[SettingsManager manager] setSetting:password forKey:SETTING_KEY_PASSWORD];
	
	[self.loader addTokenWithTokenId:0 url:[NSString stringWithFormat:@"%@?email=%@&password=%@", API_LOGIN, email, password] method:ImTravelingLoaderMethodGET params:nil];
	[self.loader startLoading];
}

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	[self stopBusy];
	
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
