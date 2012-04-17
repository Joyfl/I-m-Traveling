//
//  LoginViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 25..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"

@interface LoginViewController : ImTravelingViewController
{
	UITextField *_emailInput;
	UITextField *_passwordInput;
}

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password;

@end