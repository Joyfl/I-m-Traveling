//
//  PlaceAddViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 15..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "ImTravelingViewController.h"
#import <MapKit/MapKit.h>

@class PlaceSelectionViewController;

@interface PlaceAddViewController : ImTravelingViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
	PlaceSelectionViewController *placeSelectionViewController;
	
	MKMapView *_mapView;
	UIImageView *_pin;
	UIButton *_upDownButton;
	
	UIView *_container;
	UITextField *_nameInput;
	UILabel *_categoryLabel;
	UIPickerView *_picker;
	
	BOOL _wasEditingName;
}

@property (nonatomic, retain) PlaceSelectionViewController *placeSelectionViewController;

@end
