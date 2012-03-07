//
//  PlaceSelectionViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import <MapKit/MapKit.h>

@class ShareViewController;

@interface PlaceSelectionViewController : UIPullDownWebViewController <CLLocationManagerDelegate, UITextFieldDelegate>
{
	ShareViewController *_shareViewController;
	CLLocationManager *_locationManager;
	NSInteger _lastCellId;
	NSMutableDictionary *_places;
}

- (id)initWithShareViewController:(ShareViewController *)shareViewController;

@end
