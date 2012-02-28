//
//  FeedLineAnnotationView.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 2. 9..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "FeedLineAnnotationView.h"

@implementation FeedLineAnnotationView

- (id)initWithAnnotation:(FeedLineAnnotation *)annotation mapView:(MKMapView *)mapView
{
	if( self = [super init] )
	{
		self.annotation = annotation;
		_locations = [(FeedLineAnnotation *)annotation locations];
		
		_mapView = [mapView retain];
		self.frame = CGRectMake( 0, 0, _mapView.frame.size.width, _mapView.frame.size.height );
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	CGContextSetStrokeColorWithColor( context, [UIColor blueColor].CGColor );
	CGContextSetAlpha( context, 0.5 );
	CGContextSetLineWidth( context, 4.0 );
	
	for( NSInteger i = 0; i < _locations.count; i++ )
	{
		CLLocation *location = [_locations objectAtIndex:i];
		CGPoint point = [_mapView convertCoordinate:location.coordinate toPointToView:self];
		
		if( i == 0 )
			CGContextMoveToPoint( context, point.x, point.y );
		else
			CGContextAddLineToPoint( context, point.x, point.y );
	}
	
	CGContextStrokePath( context );
}

@end
