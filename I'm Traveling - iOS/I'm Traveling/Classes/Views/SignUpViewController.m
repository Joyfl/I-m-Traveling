//
//  SignUpViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SignUpViewController.h"
#import "ImTravelingBarButtonItem.h"
#import "QuartzCore/CALayer.h"
#import "ImTravelingNavigationController.h"
#import "TemsAndConditionsViewController.h"
#import "Const.h"
#import "Utils.h"
#import "SettingsManager.h"


@implementation SignUpViewController

- (id)init
{
	if( self = [super init] )
	{
		ImTravelingBarButtonItem *backButton = [[ImTravelingBarButtonItem alloc] initWithType:ImTravelingBarButtonItemTypeBack title:NSLocalizedString( @"BACK", @"" ) target:self action:@selector(backButtonDidTouchUpInside)];
		self.navigationItem.leftBarButtonItem = backButton;
		[backButton release];
		
		self.navigationItem.title = NSLocalizedString( @"SIGN_UP", @"" );
		
		UIView *topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, 320, 100 )];
		topBackgroundView.backgroundColor = [UIColor darkGrayColor];
		[self.view addSubview:topBackgroundView];
		[topBackgroundView release];
		
		_coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover_temp.jpg"]];
		_coverImageView.frame = CGRectMake( 0, -85, 320, 320 );
		[self.view addSubview:_coverImageView];
		[_coverImageView release];
		
		_imageTopBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_image_top_border.png"]];
		_imageTopBorder.hidden = YES;
		[_coverImageView addSubview:_imageTopBorder];
		
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake( 0, 0, 320, 416 )];
		_scrollView.delegate = self;
		_scrollView.contentSize = CGSizeMake( 320, 507 );
		[self.view addSubview:_scrollView];
		[_scrollView release];
		
		_profileImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_profileImageButton.frame = CGRectMake( 25, 162, 67, 67 );
		[_profileImageButton setBackgroundImage:[UIImage imageNamed:@"temp_profile_image.png"] forState:UIControlStateNormal];
		[_profileImageButton addTarget:self action:@selector(profileImageButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_profileImageButton];
		
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signup_bg.png"]];
		bg.frame = CGRectMake( 0, 142, 320, 365 );
		[_scrollView addSubview:bg];
		[bg release];
		
		UIView *bottomBg = [[UIView alloc] initWithFrame:CGRectMake( 0, 507, 320, 500 )];
		bottomBg.backgroundColor = [UIColor colorWithRed:247/255.0 green:221/255.0 blue:199/255.0 alpha:1];
		[_scrollView addSubview:bottomBg];
		[bottomBg release];
		
		UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
		addButton.frame = CGRectMake( 230, 135, 26, 27 );
		[addButton setBackgroundImage:[UIImage imageNamed:@"button_add_cover.png"] forState:UIControlStateNormal];
		[addButton addTarget:self action:@selector(addCoverImageButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:addButton];
		
		UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
		refreshButton.frame = CGRectMake( 276, 135, 26, 28 );
		[refreshButton setBackgroundImage:[UIImage imageNamed:@"button_refresh_cover.png"] forState:UIControlStateNormal];
		[refreshButton addTarget:self action:@selector(refreshCoverImageButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:refreshButton];
		
		
		// name
		_nameInput = [[UITextField alloc] initWithFrame:CGRectMake( 101, 185, 300, 24 )];
		_nameInput.delegate = self;
		_nameInput.placeholder = NSLocalizedString( @"ENTER_YOUR_NAME", @"" );
		_nameInput.font = [UIFont boldSystemFontOfSize:20];
		_nameInput.textColor = [UIColor colorWithRed:48/255.0 green:41/255.0 blue:53/255.0 alpha:1];
		_nameInput.layer.shadowColor = [UIColor whiteColor].CGColor;
		_nameInput.layer.shadowOffset = CGSizeMake( 0, 1 );
		_nameInput.layer.shadowOpacity = 0.5;
		_nameInput.layer.shadowRadius = 0;
		[_nameInput setValue:[UIColor colorWithRed:191/255.0 green:150/255.0 blue:119/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
		[_scrollView addSubview:_nameInput];
		[_nameInput release];
		
		
		// nation
		_nations = [[Utils parseJSON:[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nations" ofType:@"json"] encoding:NSUTF8StringEncoding error:nil]] retain];
		
		_nationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_nationButton.frame = CGRectMake( 104, 214, 200, 13 );
		_nationButton.titleLabel.font = [UIFont systemFontOfSize:13];
		_nationButton.titleLabel.shadowOffset = CGSizeMake( 0, 1 );
		_nationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_nationButton setTitle:NSLocalizedString( @"SELECT_NATION", @"" ) forState:UIControlStateNormal];
		[_nationButton setTitleColor:[UIColor colorWithRed:203/255.0 green:166/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
		[_nationButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
		[_nationButton addTarget:self action:@selector(nationButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_nationButton];
		
		_nationPicker = [[UIPickerView alloc] initWithFrame:CGRectMake( 0, 416, 320, 218 )];
		_nationPicker.delegate = self;
		_nationPicker.dataSource = self;
		_nationPicker.showsSelectionIndicator = YES;
		[self.view addSubview:_nationPicker];
		[_nationPicker release];
		
		
		// email
		UILabel *emailTitleLabel = [self makeTitleLabelWithTitle:NSLocalizedString( @"EMAIL", @"" ) location:CGPointMake( 13, 272 )];
		[_scrollView addSubview:emailTitleLabel];
		[emailTitleLabel release];
		
		_emailInput = [self makeInputWithFrame:CGRectMake( 80, 270, 230, 18 ) placeholder:@"email@example.com"];
		_emailInput.keyboardType = UIKeyboardTypeEmailAddress;
		_emailInput.autocorrectionType = UITextAutocorrectionTypeNo;
		_emailInput.autocapitalizationType = UITextAutocapitalizationTypeNone;
		[_scrollView addSubview:_emailInput];
		[_emailInput release];
		
		
		// password
		UILabel *passwordTitleLabel = [self makeTitleLabelWithTitle:NSLocalizedString( @"PASSWORD", @"" ) location:CGPointMake( 13, 317 )];
		[_scrollView addSubview:passwordTitleLabel];
		[passwordTitleLabel release];
		
		_passwordInput = [self makeInputWithFrame:CGRectMake( 80, 315, 90, 18 ) placeholder:@"****"];
		_passwordInput.secureTextEntry = YES;
		[_scrollView addSubview:_passwordInput];
		[_passwordInput release];
		
		
		// password verify
		UILabel *passwordVerifyTitleLabel = [self makeTitleLabelWithTitle:NSLocalizedString( @"PASSWORD_VERIFY", @"" ) location:CGPointMake( 182, 317 )];
		[_scrollView addSubview:passwordVerifyTitleLabel];
		[passwordVerifyTitleLabel release];
		
		_passwordVerifyInput = [self makeInputWithFrame:CGRectMake( 220, 315, 90, 18 ) placeholder:@"****"];
		_passwordVerifyInput.secureTextEntry = YES;
		[_scrollView addSubview:_passwordVerifyInput];
		[_passwordVerifyInput release];
		
		
		// birthday
		_selectedBirthday = [[NSDate alloc] init];
		
		UILabel *birthdayTitleLabel = [self makeTitleLabelWithTitle:NSLocalizedString( @"BIRTHDAY", @"" ) location:CGPointMake( 13, 362 )];
		[_scrollView addSubview:birthdayTitleLabel];
		[birthdayTitleLabel release];
		
		_birthdayButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_birthdayButton.frame = CGRectMake( 80, 360, 90, 18 );
		_birthdayButton.titleLabel.font = [UIFont systemFontOfSize:14];
		_birthdayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_birthdayButton setTitle:[Utils dateWithDate:_selectedBirthday] forState:UIControlStateNormal];
		[_birthdayButton setTitleColor:[UIColor colorWithRed:123/255.0 green:89/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
		[_birthdayButton addTarget:self action:@selector(birthdayButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_birthdayButton];
		
		_birthdayPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake( 0, 416, 320, 218 )];
		_birthdayPicker.datePickerMode = UIDatePickerModeDate;
		[_birthdayPicker addTarget:self action:@selector(birthdayPickerValueChanged) forControlEvents:UIControlEventValueChanged];
		[self.view addSubview:_birthdayPicker];
		[_birthdayPicker release];
		
		
		// sex
		UILabel *sexTitleLabel = [self makeTitleLabelWithTitle:NSLocalizedString( @"SEX", @"" ) location:CGPointMake( 182, 362 )];
		[_scrollView addSubview:sexTitleLabel];
		[sexTitleLabel release];
		
		_maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_maleButton.frame = CGRectMake( 220, 362, 35, 15 );
		_maleButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_maleButton setTitle:NSLocalizedString( @"MALE", @"" ) forState:UIControlStateNormal];
		[_maleButton addTarget:self action:@selector(sexButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_maleButton];
		
		_femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_femaleButton.frame = CGRectMake( 265, 362, 35, 15 );
		_femaleButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[_femaleButton setTitle:NSLocalizedString( @"FEMALE", @"" ) forState:UIControlStateNormal];
		[_femaleButton addTarget:self action:@selector(sexButtonDidTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_femaleButton];
		
		[_maleButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		
		
		// terms and conditions
		UIButton *termsAndConditionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
		termsAndConditionsButton.frame = CGRectMake( 13, 407, 204, 15 );
		termsAndConditionsButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
		termsAndConditionsButton.titleLabel.shadowOffset = CGSizeMake( 0, 1 );
		termsAndConditionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[termsAndConditionsButton setTitle:NSLocalizedString( @"READ_AND_ACCEPT_TERMS_AND_CONDITIONS", @"" ) forState:UIControlStateNormal];
		[termsAndConditionsButton setTitleColor:[UIColor colorWithRed:0.188 green:0.160 blue:0.207 alpha:1] forState:UIControlStateNormal];
		[termsAndConditionsButton setTitleShadowColor:[UIColor colorWithWhite:1 alpha:0.5] forState:UIControlStateNormal];
		[termsAndConditionsButton addTarget:self action:@selector(termsAndConditionsButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:termsAndConditionsButton];
		
		_agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_agreeButton.frame = CGRectMake( 274, 407, 20, 16 );
		[_agreeButton setBackgroundImage:[UIImage imageNamed:@"button_check.png"] forState:UIControlStateNormal];
		[_agreeButton addTarget:self action:@selector(agreeButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:_agreeButton];
		
		
		// sign up
		UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
		signUpButton.frame = CGRectMake( 47, 455, 226, 31 );
		signUpButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
		signUpButton.titleLabel.shadowOffset = CGSizeMake( 0, 1 );
		[signUpButton setBackgroundImage:[UIImage imageNamed:@"button_signup.png"] forState:UIControlStateNormal];
		[signUpButton setTitle:NSLocalizedString( @"SIGN_UP", @"" ) forState:UIControlStateNormal];
		[signUpButton setTitleShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] forState:UIControlStateNormal];
		[signUpButton addTarget:self action:@selector(signUpButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:signUpButton];
	}
	
	return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark -
#pragma mark Navigation bar selectors

- (void)backButtonDidTouchUpInside
{
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark 

- (UILabel *)makeTitleLabelWithTitle:(NSString *)title location:(CGPoint)location
{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( location.x, location.y, 80, 15 )];
	label.backgroundColor = [UIColor clearColor];
	label.text = title;
	label.font = [UIFont boldSystemFontOfSize:15];
	label.textColor = [UIColor colorWithRed:0.188 green:0.160 blue:0.207 alpha:1];
	label.shadowOffset = CGSizeMake( 0, 1 );
	label.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
	label.userInteractionEnabled = NO;
	return label;
}

- (UITextField *)makeInputWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
	UITextField *input = [[UITextField alloc] initWithFrame:frame];
	input.delegate = self;
	input.placeholder = placeholder;
	input.font = [UIFont systemFontOfSize:14];
	input.textColor = [UIColor colorWithRed:123/255.0 green:89/255.0 blue:56/255.0 alpha:1];
	[input setValue:[UIColor colorWithRed:201/255.0 green:162/255.0 blue:132/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
	return input;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	_currentFirstResponder = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if( textField == _nameInput )
	{
		[_nationButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
	else if( textField == _emailInput )
	{
		[_passwordInput becomeFirstResponder];
	}
	else if( textField == _passwordInput )
	{
		[_passwordVerifyInput becomeFirstResponder];
	}
	else if( textField == _passwordVerifyInput )
	{
		[_birthdayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
	
	return YES;
}


#pragma mark -
#pragma mark Keyboard

- (void)keyboardWillShow
{
	_originalOffset = _scrollView.contentOffset.y;
	
	[_scrollView setContentOffset:CGPointMake( 0, _currentFirstResponder.frame.origin.y - 20 ) animated:YES];
	
	CGRect frame = _scrollView.frame;
	frame.size.height = 200;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	_scrollView.frame = frame;
	[UIView commitAnimations];
}

- (void)keyboardWillHide
{
	CGRect frame = _scrollView.frame;
	frame.size.height = 416;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:0];
	[UIView setAnimationDuration:0.25];
	_scrollView.frame = frame;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGRect frame = _coverImageView.frame;
	
	if( _scrollView.contentOffset.y > 0 )
	{
		frame.origin.y = -85 - _scrollView.contentOffset.y;
	}
	else
	{
		if( _scrollView.contentOffset.y > -122 )
			frame.origin.y = -85 - _scrollView.contentOffset.y / 2;
		else
			frame.origin.y = -146 - _scrollView.contentOffset.y;
	}
	
	_coverImageView.frame = frame;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = NO;
	if( _currentFirstResponder )
		[_currentFirstResponder resignFirstResponder];
	[self hidePicker:_nationPicker];
	[self hidePicker:_birthdayPicker];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	_imageTopBorder.hidden = YES;
}


#pragma mark -
#pragma mark Selectors

- (void)addCoverImageButtonDidTouchUpInside
{
	_actionSheetType = 0;
	[self presentActionSheet];
}

- (void)refreshCoverImageButtonDidTouchUpInside
{
	
}

- (void)profileImageButtonDidTouchUpInside
{
	_actionSheetType = 1;
	[self presentActionSheet];
}

- (void)nationButtonDidTouchUpInside
{
	[_currentFirstResponder resignFirstResponder];
	[self hidePicker:_birthdayPicker];
	_currentFirstResponder = _nationButton;
	[self showPicker:_nationPicker];
}

- (void)birthdayButtonDidTouchUpInside
{
	[_currentFirstResponder resignFirstResponder];
	[self hidePicker:_nationButton];
	_currentFirstResponder = _birthdayButton;
	[self showPicker:_birthdayPicker];
}

- (void)sexButtonDidTouchUpInside:(UIButton *)sender
{
	if( sender == _maleButton )
	{
		_selectedSex = 1;
		[_maleButton setTitleColor:[UIColor colorWithRed:123/255.0 green:89/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
		[_femaleButton setTitleColor:[UIColor colorWithRed:201/255.0 green:162/255.0 blue:132/255.0 alpha:1] forState:UIControlStateNormal];
	}
	else
	{
		_selectedSex = 2;
		[_femaleButton setTitleColor:[UIColor colorWithRed:123/255.0 green:89/255.0 blue:56/255.0 alpha:1] forState:UIControlStateNormal];
		[_maleButton setTitleColor:[UIColor colorWithRed:201/255.0 green:162/255.0 blue:132/255.0 alpha:1] forState:UIControlStateNormal];
	}
}

- (void)termsAndConditionsButtonDidTouchUpInside
{
	TemsAndConditionsViewController *termsAndConditionsViewController = [[TemsAndConditionsViewController alloc] init];
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:termsAndConditionsViewController];
	[self presentModalViewController:navigationController animated:YES];
}

- (void)agreeButtonDidTouchUpInside
{
	if( _agreed )
	{
		[_agreeButton setBackgroundImage:[UIImage imageNamed:@"button_check.png"] forState:UIControlStateNormal];
		_agreed = NO;
	}
	else
	{
		[_agreeButton setBackgroundImage:[UIImage imageNamed:@"button_check_checked.png"] forState:UIControlStateNormal];
		_agreed = YES;
	}
}

- (void)signUpButtonDidTouchUpInside
{
	_invalidField = nil;
	
	if( !_nameInput.text.length )
	{
		[self showAlertWithMessage:@"ENTER_YOUR_NAME"];
		_invalidField = _nameInput;
		return;
	}
	
	if( [_nationButton.titleLabel.text isEqualToString:NSLocalizedString( @"SELECT_NATION", @"" )] )
	{
		[self showAlertWithMessage:@"SELECT_NATION"];
		_invalidField = _nationButton;
		return;
	}
	
	if( !_emailInput.text )
	{
		[self showAlertWithMessage:@"ENTER_EMAIL"];
		_invalidField = _emailInput;
		return;
	}
	
	if( _passwordInput.text.length < 4 )
	{
		[self showAlertWithMessage:@"SHORT_PASSWORD"];
		_invalidField = _passwordInput;
		return;
	}
	
	if( ![_passwordInput.text isEqualToString:_passwordVerifyInput.text] )
	{
		[self showAlertWithMessage:@"PASSWORD_NOT_MATCH"];
		_invalidField = _passwordVerifyInput;
		return;
	}
	
	if( !_agreed )
	{
		[self showAlertWithMessage:@"PLEASE_READ_AND_ACCEPT_TERMS_AND_CONDITIONS"];
		return;
	}
	
	NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   _emailInput.text, @"email",
								   [Utils sha1:_passwordInput.text], @"password",
								   _nameInput.text, @"name",
								   [NSNumber numberWithInteger:_selectedSex], @"sex",
								   [Utils dateStringForUpload:_selectedBirthday], @"birthday",
								   _nationButton.titleLabel.text, @"nation",
								   [_profileImageButton backgroundImageForState:UIControlStateNormal], @"profile_image",
								   _coverImageView.image, @"cover_image",
								   nil];
	NSLog( @"data : %@", params );
	[self.loader addTokenWithTokenId:0 url:API_SIGN_UP method:ImTravelingLoaderMethodPOST params:params];
	[self.loader startLoading];
	
	[self startBusy];
}


#pragma mark -
#pragma mark Loader

- (void)loadingDidFinish:(ImTravelingLoaderToken *)token
{
	[self stopBusy];
	
	NSDictionary *json = [Utils parseJSON:token.data];
	if( [self isError:json] )
	{
		NSLog( @"%@", json );
#warning temp code
		[self showAlertWithMessage:@"Error"];
		return;
	}
	
	NSDictionary *result = [json objectForKey:@"result"];
	
	[[SettingsManager manager] setSetting:[result objectForKey:@"ID"] forKey:SETTING_KEY_USER_ID];
	[[SettingsManager manager] setSetting:_emailInput.text forKey:SETTING_KEY_EMAIL];
	[[SettingsManager manager] setSetting:_nameInput.text forKey:SETTING_KEY_USER_NAME];
	[[SettingsManager manager] setSetting:_passwordInput.text forKey:SETTING_KEY_PASSWORD];
	[[SettingsManager manager] flush];

	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)presentActionSheet
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"CANCEL", @"" ) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"TAKE_A_PICTURE", @"Camera" ), NSLocalizedString( @"FROM_LIBRARY", @"Album" ), nil];
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
	
	if( buttonIndex == 0 ) // Camera
	{
		@try
		{
			pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
		}
		@catch (NSException *exception)
		{
			[self showAlertWithMessage:@"NO_SUPPORT_CAMERA"];
			return;
		}
		
		pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
	}
	else if( buttonIndex == 1 ) // Album
	{
		pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	else
	{
		return;
	}
	
	pickerController.delegate = self;
	[self presentModalViewController:pickerController animated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// 카메라로 찍은 경우 앨범에 저장
	if( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
		UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil );
	
	if( _actionSheetType == 0 )
	{
		_coverImageView.image = image;
	}
	else if( _actionSheetType == 1 )
	{
		[_profileImageButton setBackgroundImage:image forState:UIControlStateNormal];
	}
	
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIPicker

- (void)showPicker:(UIView *)picker
{
	if( [picker isKindOfClass:[UIPickerView class]] || [picker isKindOfClass:[UIDatePicker class]] )
	{
		CGRect frame = picker.frame;
		frame.origin.y = 200;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.25];
		picker.frame = frame;
		[UIView commitAnimations];
		
		[self keyboardWillShow];
	}
}

- (void)hidePicker:(UIView *)picker
{
	if( [picker isKindOfClass:[UIPickerView class]] || [picker isKindOfClass:[UIDatePicker class]] )
	{
		CGRect frame = picker.frame;
		frame.origin.y = 416;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:0];
		[UIView setAnimationDuration:0.25];
		picker.frame = frame;
		[UIView commitAnimations];
		
		[self keyboardWillHide];
	}
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return _nations.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [[_nations objectAtIndex:row] objectForKey:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	[_nationButton setTitle:[[_nations objectAtIndex:row] objectForKey:@"code"] forState:UIControlStateNormal];
}

- (void)birthdayPickerValueChanged
{
	_selectedBirthday = _birthdayPicker.date;
	[_birthdayButton setTitle:[Utils dateWithDate:_selectedBirthday] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark Utils

- (void)showAlertWithMessage:(NSString *)message
{
	[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( message, @"") delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if( !_invalidField ) return;
	if( [_invalidField isKindOfClass:[UITextField class]] )
	{
		[_invalidField becomeFirstResponder];
	}
	else if( [_invalidField isKindOfClass:[UIButton class]] )
	{
		[((UIButton *)_invalidField) sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
	
	_currentFirstResponder = _invalidField;
}

@end
