//
//  InfoCell.h
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"

@interface InfoCell : UITableViewCell
{
	ShareViewController *_shareViewController;
	NSInteger _row;
	
	UITextField *itemInput;
	UITextField *valueInput;
	UIButton *unitButton;
}

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) UITextField *itemInput;
@property (nonatomic, retain) UITextField *valueInput;
@property (nonatomic, retain) UIButton *unitButton;

- (id)initWithRow:(NSInteger)row shareViewController:(ShareViewController *)shareViewController andReuseIdentifier:(NSString *)reuseIdentifier;

@end
