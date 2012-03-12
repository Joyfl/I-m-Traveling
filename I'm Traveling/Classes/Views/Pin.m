//
//  Pin.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 13..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "Pin.h"

@implementation Pin

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier] )
	{
		UIImageView *pin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
		pin.frame = CGRectMake( -10, -27, 21, 32 );
		[self addSubview:pin];
		[pin release];
    }
	
    return self;
}

@end
