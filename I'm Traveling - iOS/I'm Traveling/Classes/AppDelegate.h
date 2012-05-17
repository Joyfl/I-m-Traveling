//
//  AppDelegate.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareViewController, ProfileViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	UITabBarController *tabBarController;
	ShareViewController *shareViewController;
	ProfileViewController *profileViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) ShareViewController *shareViewController;
@property (nonatomic, retain) ProfileViewController *profileViewController;

- (void)presentLoginViewController;
- (void)presentActionSheet;

@end
