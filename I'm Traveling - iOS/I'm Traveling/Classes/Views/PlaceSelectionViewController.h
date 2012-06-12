//
//  PlaceSelectionViewController.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 27..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "UIPullDownWebViewController.h"
#import <MapKit/MapKit.h>
#import "Place.h"

@class ShareViewController;

@interface PlaceSelectionViewController : UIPullDownWebViewController <MKMapViewDelegate, UISearchBarDelegate>
{
	ShareViewController *_shareViewController;
	MKMapView *_mapView;
	NSInteger _lastCellId;
	NSMutableDictionary *_places;
	UISearchBar *_searchBar;
	
	BOOL _placeSelected;
	
	NSArray *category;
}

- (id)initWithShareViewController:(ShareViewController *)shareViewController;
- (void)regionDidChangeToLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void)selectPlace:(Place *)place;
- (NSString *)categoryForNumber:(NSInteger)no;

@property (nonatomic, readonly) NSArray *category;

@end
