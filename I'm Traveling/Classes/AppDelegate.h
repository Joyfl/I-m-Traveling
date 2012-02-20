//
//  AppDelegate.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
	UITabBarController *tabBarController;
}

@property (strong, nonatomic) UIWindow *window;

- (void)showActionSheet;

@end
