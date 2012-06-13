//
//  AppDelegate.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class ShareViewController, ProfileViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FBSessionDelegate>
{
	UITabBarController *tabBarController;
	ShareViewController *shareViewController;
	ProfileViewController *profileViewController;
	
	Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ShareViewController *shareViewController;
@property (nonatomic, retain) ProfileViewController *profileViewController;
@property (nonatomic, retain) Facebook *facebook;

- (void)presentLoginViewController;
- (void)presentActionSheet;

@end
