//
//  ImTravelingViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface ImTravelingViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, NSURLAuthenticationChallengeSender>
{
	Reachability *internetReachability;
	BOOL networkAvailable;
	
	NSMutableData *responseData;
}

- (void)networkAvailabilityDidChange:(BOOL)available;
- (void)loadURL:(NSString *)url;
- (void)loadURL:(NSString *)url withData:(NSDictionary *)data;
- (void)loadURLPOST:(NSString *)url withData:(NSDictionary *)data;
- (void)loadingDidFinish:(NSString *)data;
- (BOOL)isError:(NSDictionary *)json;

- (void)startBusy;
- (void)stopBusy;

@end
