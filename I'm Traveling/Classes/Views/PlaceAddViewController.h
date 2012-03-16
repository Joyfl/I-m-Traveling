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

@interface PlaceAddViewController : ImTravelingViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
	PlaceSelectionViewController *placeSelectionViewController;
	
	UITableView *_tableView;
	MKMapView *_mapView;
	UITextField *_nameInput;
	UITableViewCell *_categoryCell;
	UIPickerView *_picker;
}

@property (nonatomic, retain) PlaceSelectionViewController *placeSelectionViewController;

@end
