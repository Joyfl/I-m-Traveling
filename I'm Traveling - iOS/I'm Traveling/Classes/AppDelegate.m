//
//  AppDelegate.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "AppDelegate.h"
#import "ImTravelingNavigationController.h"
#import "FeedListViewController.h"
#import "ShareViewController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "Utils.h"
#import "UploadManager.h"
#import "Const.h"
#import "SettingsManager.h"

@implementation AppDelegate

@synthesize window = _window, shareViewController, profileViewController;

- (void)dealloc
{
	[_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	application.statusBarStyle = UIStatusBarStyleBlackOpaque;
	
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.delegate = self;
	tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bar.png"];
	
	ImTravelingNavigationController *feedNavigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:[[FeedListViewController alloc] init]];
	feedNavigationController.title = NSLocalizedString( @"TAB_FEED", @"Feed" );
	feedNavigationController.tabBarItem.image = [UIImage imageNamed:@"tab_feed.png"];
	
	ImTravelingNavigationController *shareNavigationController = [[ImTravelingNavigationController alloc] init];
	shareNavigationController.title = NSLocalizedString( @"TAB_UPLOAD", @"Upload" );
	
	UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake( 108.0, -8.0, 108.0, 60.0 )];
	[uploadButton setImage:[UIImage imageNamed:NSLocalizedString( @"TAB_SHARE", @"" )] forState:UIControlStateNormal];
	[uploadButton addTarget:self action:@selector(onUploadButtonTouch) forControlEvents:UIControlEventTouchUpInside];
	
	profileViewController = [[ProfileViewController alloc] init];
	if( [Utils loggedIn] ) [profileViewController activateFromTabBarWithUserId:[Utils userId] userName:[Utils userName]];
	ImTravelingNavigationController *profileNavigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:profileViewController];
	profileNavigationController.title = NSLocalizedString( @"TAB_PROFILE", @"Profile" );
	profileNavigationController.tabBarItem.image = [UIImage imageNamed:@"tab_profile.png"];
	[profileViewController release];
	
	tabBarController.viewControllers = [[NSArray alloc] initWithObjects:feedNavigationController, [[UIViewController alloc] init], profileNavigationController, nil];
	[tabBarController.tabBar addSubview:uploadButton];
	[uploadButton release];
	
	// FeedListViewController에서 MapViewController로 전환될 때 네비게이션바의 위쪽 둥근 모서리를 자연스럽게 처리하기 위해 배경을 검은색으로 설정.
	tabBarController.view.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:1.0];
	
	[self.window addSubview:tabBarController.view];
	[tabBarController.view release];
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
	
	[UploadManager manager];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	/*
	 Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	 */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	/*
	 Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	 */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}


#pragma mark -
#pragma mark Button Selector

- (void)onUploadButtonTouch
{
	if( ![Utils loggedIn] )
	{
		[self presentLoginViewController];
		return;
	}
	
	[self presentActionSheet];
}


#pragma mark -
#pragma mark LoginViewController

- (void)presentLoginViewController
{
	LoginViewController *loginViewController = [[LoginViewController alloc] init];
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:loginViewController];
	[tabBarController presentModalViewController:navigationController animated:YES];
	[loginViewController release];
	[navigationController release];
}


#pragma mark -
#pragma mark UITabBarDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
	// ProfileView 선택시
	if( [[(UINavigationController *)viewController viewControllers] objectAtIndex:0] == profileViewController )
	{
		// 로그인이 되어있지 않으면 LoginView를 띄움
		if( ![Utils loggedIn] )
		{
			[self presentLoginViewController];
			return NO;
		}
		else if( !profileViewController.activated )
		{
			NSLog( @"profile is not activated" );
			[profileViewController activateFromTabBarWithUserId:[Utils userId] userName:[Utils userName]];
			return YES;
		}
	}
	
	return YES;
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)presentActionSheet
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString( @"CANCEL", @"" ) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString( @"TAKE_A_PICTURE", @"Camera" ), NSLocalizedString( @"FROM_LIBRARY", @"Album" ), nil];
	[actionSheet showInView:self.window];
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
			[[[[UIAlertView alloc] initWithTitle:NSLocalizedString( @"OOPS", @"" ) message:NSLocalizedString( @"NO_SUPPORT_CAMERA", @"") delegate:self cancelButtonTitle:NSLocalizedString( @"I_GOT_IT", @"" ) otherButtonTitles:nil] autorelease] show];
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
	[tabBarController presentModalViewController:pickerController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog( @"Album : %@", info );
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// 카메라로 찍은 경우 앨범에 저장
	if( picker.sourceType == UIImagePickerControllerSourceTypeCamera )
		UIImageWriteToSavedPhotosAlbum( image, nil, nil, nil );
	
	[self performSelector:@selector(presentShareViewControllerWithImage:) withObject:image afterDelay:0.5];
}

- (void)presentShareViewControllerWithImage:(UIImage *)image
{
	[tabBarController dismissModalViewControllerAnimated:NO];
	
	shareViewController = [[ShareViewController alloc] initWithImage:image];
	ImTravelingNavigationController *navigationController = [[ImTravelingNavigationController alloc] initWithRootViewController:shareViewController];
	[navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bar.png"] forBarMetrics:UIBarMetricsDefault];
	[tabBarController presentModalViewController:navigationController animated:NO];
}

@end
