//
//  ImTravelingBarButtonItem.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 18..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImTravelingBarButtonItem : UIBarButtonItem

enum {
	ImTravelingBarButtonItemTypeNormal = 0,
	ImTravelingBarButtonItemTypeBack = 1
};

- (id)initWithType:(NSInteger)type title:(NSString *)title target:(id)target action:(SEL)action;

@end
