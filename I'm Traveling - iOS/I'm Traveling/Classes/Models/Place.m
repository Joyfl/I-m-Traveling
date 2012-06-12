//
//  Place.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 7..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Place.h"
#import "Utils.h"

@implementation Place

@synthesize placeId, name, latitude, longitude, category;

- (NSString *)title
{
	return name;
}

- (NSString *)subtitle
{
	return [Utils categoryForNumber:category];
}

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake( latitude, longitude );
}

@end
