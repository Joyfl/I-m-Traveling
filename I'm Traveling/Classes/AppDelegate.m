//
//  AppDelegate.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 1. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "AppDelegate.h"
#import "FeedListView.h"
#import "ShareView.h"
#import "PeopleView.h"
#import "ProfileView.h"

@implementation AppDelegate

@synthesize window = _window;

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
	tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bar.png"];
	
	UINavigationController *feedNavigationController = [[UINavigationController alloc] initWithRootViewController:[[FeedListView alloc] init]];
	feedNavigationController.title = @"Feed";
	feedNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_feed.png"] retain];
	
	UINavigationController *tripNavigationController = [[UINavigationController alloc] initWithRootViewController:[[FeedListView alloc] init]];
	tripNavigationController.title = @"Trip";
	tripNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_trip.png"] retain];
	
	UINavigationController *shareNavigationController = [[UINavigationController alloc] init];
	shareNavigationController.title = @"Upload";
	
	UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake( 130.0, -6.0, 64.0, 60.0 )];
	[uploadButton setImage:[[UIImage imageNamed:@"tab_share.png"] retain] forState:UIControlStateNormal];
	[uploadButton addTarget:self action:@selector(onUploadButtonTouch) forControlEvents:UIControlEventTouchUpInside];
	
	UINavigationController *peopleNavigationController = [[UINavigationController alloc] initWithRootViewController:[[PeopleView alloc] init]];
	peopleNavigationController.title = @"People";
	peopleNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_people.png"] retain]; 
	
	UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:[[ProfileView alloc] init]];
	profileNavigationController.title = @"Profile";
	profileNavigationController.tabBarItem.image = [[UIImage imageNamed:@"tab_profile.png"] retain];
	
	tabBarController.viewControllers = [[NSArray alloc] initWithObjects:feedNavigationController, tripNavigationController, [[UINavigationController alloc] init], peopleNavigationController, profileNavigationController, nil];
	[tabBarController.tabBar addSubview:uploadButton];
	
	[feedNavigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	[tripNavigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	[peopleNavigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	[profileNavigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	
	[self.window addSubview:tabBarController.view];
	
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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

#pragma mark - selectors

- (void)onUploadButtonTouch
{
	ShareView *shareView = [[ShareView alloc] init];
	UINavigationController *shareViewController = [[UINavigationController alloc] initWithRootViewController:shareView];
	[shareViewController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"navigation_bar.png"] retain] forBarMetrics:UIBarMetricsDefault];
	[tabBarController presentModalViewController:shareViewController animated:YES];
}

@end
