//
//  ImTravelingViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImTravelingLoader.h"

@class Reachability;

@interface ImTravelingViewController : UIViewController </*NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLAuthenticationChallengeSender,*/ ImTravelingLoaderDelegate>
{
	Reachability *internetReachability;
	BOOL networkAvailable;
	
	ImTravelingLoader *loader;
	
//	NSMutableData *responseData;
}

- (void)networkAvailabilityDidChange:(BOOL)available;
- (void)loadingDidFinish:(ImTravelingLoaderToken *)token;
- (BOOL)isError:(NSDictionary *)json;
- (NSInteger)errorCode:(NSDictionary *)json;

- (void)startBusy;
- (void)stopBusy;
- (void)showOopsAlertWithMessage:(NSString *)message;

@property (nonatomic, retain) ImTravelingLoader *loader;

@end
