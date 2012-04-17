//
//  TripListViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 28..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIWebViewController.h"
#import "TripObject.h"

@class ShareViewController;

@interface TripListViewController : UIWebViewController
{
	ShareViewController *_shareViewController;
	NSMutableDictionary *_trips;
	
	BOOL _tripSelected;
}

- (id)initWithShareViewController:(ShareViewController *)shareViewController;
- (void)selectTrip:(TripObject *)trip;

@end
