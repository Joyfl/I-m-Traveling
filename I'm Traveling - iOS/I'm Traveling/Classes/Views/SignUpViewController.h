//
//  SignUpViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface SignUpViewController : ImTravelingViewController <UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIAlertViewDelegate>
{
	UIImageView *_imageTopBorder;
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	UIButton *_profileImageButton;
	
	UITextField *_nameInput;
	NSArray *_nations;
	UIButton *_nationButton;
	UITextField *_emailInput;
	UITextField *_passwordInput;
	UITextField *_passwordVerifyInput;
	UIButton *_birthdayButton;
	NSDate *_selectedBirthday;
	UIButton *_maleButton;
	UIButton *_femaleButton;
	NSInteger _selectedSex;
	UIButton *_agreeButton;
	BOOL _agreed;
	
	UIView *_currentFirstResponder;
	NSInteger _originalOffset;
	
	UIPickerView *_nationPicker;
	UIDatePicker *_birthdayPicker;
	
	// 0 : Cover Image
	// 1 : Profile Image
	NSInteger _actionSheetType;
	
	// [가입하기]를 눌러 올바르지 않은 필드일 경우 해당 위치로 포커스 이동
	UIView *_invalidField;
}

@end
