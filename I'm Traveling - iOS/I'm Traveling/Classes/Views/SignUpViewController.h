//
//  SignUpViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface SignUpViewController : ImTravelingViewController <UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
	UIImageView *_imageTopBorder;
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	UIImageView *_profileImageView;
	
	UITextField *_nameInput;
	UIButton *_nationButton;
	UITextField *_emailInput;
	UITextField *_passwordInput;
	UITextField *_passwordVerifyInput;
	UIButton *_birthdayButton;
	UIButton *_maleButton;
	UIButton *_femaleButton;
	NSInteger selectedSex;
	
	UIView *_currentFirstResponder;
	NSInteger _originalOffset;
	
	UIButton *_keyboardHideButton;
	UIPickerView *_nationPicker;
	UIDatePicker *_birthdayPicker;
}

@end
