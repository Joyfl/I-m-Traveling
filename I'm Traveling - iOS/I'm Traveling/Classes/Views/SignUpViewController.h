//
//  SignUpViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 5. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface SignUpViewController : ImTravelingViewController <UIScrollViewDelegate, UITextFieldDelegate>
{
	UIImageView *_imageTopBorder;
	UIImageView *_coverImageView;
	UIScrollView *_scrollView;
	UIImageView *_profileImageView;
	
	UITextField *_nameInput;
	UILabel *_nationLabel;
	UITextField *_emailInput;
	UITextField *_passwordInput;
	UITextField *_passwordVerifyInput;
	UILabel *_birthdayLabel;
	UIButton *_maleButton;
	UIButton *_femaleButton;
	NSInteger selectedSex;
	
	UIView *_currentFirstResponder;
}

@end
