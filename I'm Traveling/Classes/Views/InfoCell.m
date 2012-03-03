//
//  InfoCell.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 4..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell()

- (UILabel *)createInfoLabelWithText:(NSString *)text andFrame:(CGRect)frame;
- (UITextField *)createInfoInputWithPlaceholder:(NSString *)placeholder row:(NSInteger)row andFrame:(CGRect)frame;

@end


@implementation InfoCell

@synthesize row=_row, itemInput, valueInput, unitButton;

- (id)initWithRow:(NSInteger)row shareViewController:(ShareViewController *)shareViewController andReuseIdentifier:(NSString *)reuseIdentifier
{
    if( self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] )
	{
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		_shareViewController = shareViewController;
		_row = row;
		
		UIButton *minusButton = [[UIButton alloc] initWithFrame:CGRectMake( 9, 26, 20, 20 )];
		[minusButton setBackgroundImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
		[minusButton addTarget:_shareViewController action:@selector(minusButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:minusButton];
		
		UIImageView *postIt = [[UIImageView alloc] initWithFrame:CGRectMake( 40, 0, 260, 68 )];
		postIt.image = [UIImage imageNamed:@"postit.png"];
		[self addSubview:postIt];
		
		// Item
		UILabel *itemLabel = [self createInfoLabelWithText:@"Item" andFrame:CGRectMake( 54, 7, 50, 20 )];
		[self addSubview:itemLabel];
		
		itemInput = [self createInfoInputWithPlaceholder:@"Item" row:row andFrame:CGRectMake( 105, 8, 200, 20 )];
		itemInput.textColor = [UIColor colorWithRed:0.419 green:0.258 blue:0.098 alpha:1.0];
		[itemInput addTarget:_shareViewController action:@selector(itemInputEdittingChanged:) forControlEvents:UIControlEventEditingChanged];
		[self addSubview:itemInput];
		
		// Value
		UILabel *valueLabel = [self createInfoLabelWithText:@"Value" andFrame:CGRectMake( 54, 32, 50, 20 )];
		[self addSubview:valueLabel];
		
		valueInput = [self createInfoInputWithPlaceholder:@"Value" row:row andFrame:CGRectMake( 105, 33, 70, 20 )];
		valueInput.textColor = [UIColor colorWithRed:0.678 green:0.243 blue:0.337 alpha:1.0];
		valueInput.keyboardType = UIKeyboardTypeNumberPad;
		[valueInput addTarget:_shareViewController action:@selector(valueInputEdittingChanged:) forControlEvents:UIControlEventEditingChanged];
		[self addSubview:valueInput];
		
		// Unit
		UILabel *unitLabel = [self createInfoLabelWithText:@"Unit" andFrame:CGRectMake( 185, 32, 50, 20 )];
		[self addSubview:unitLabel];
		
		unitButton = [[UIButton alloc] initWithFrame:CGRectMake( 210, 32, 70, 20 )];
		unitButton.titleLabel.font = [UIFont systemFontOfSize:14];
		[unitButton setTitle:@"KRW" forState:UIControlStateNormal];
		[unitButton setTitleColor:[UIColor colorWithRed:0.231 green:0.180 blue:0.262 alpha:1.0] forState:UIControlStateNormal];
		[unitButton addTarget:_shareViewController action:@selector(unitButtonDidTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:unitButton];
    }
    return self;
}


#pragma mark -
#pragma mark Utils

- (UILabel *)createInfoLabelWithText:(NSString *)text andFrame:(CGRect)frame
{
	UILabel *infoLabel = [[UILabel alloc] initWithFrame:frame];
	infoLabel.text = text;
	infoLabel.backgroundColor = [UIColor clearColor];
	infoLabel.font = [UIFont boldSystemFontOfSize:14];
	infoLabel.textColor = [UIColor colorWithWhite:0.14 alpha:1.0];
	
	return infoLabel;
}

- (UITextField *)createInfoInputWithPlaceholder:(NSString *)placeholder row:(NSInteger)row andFrame:(CGRect)frame;
{
	UITextField *infoInput = [[UITextField alloc] initWithFrame:frame];
	infoInput.placeholder = placeholder;
	infoInput.tag = row; // tag에 indexPath.row를 저장시켜놓고, scrollToKeyboardPosition에서 그 row에 해당하는 cell의 y좌표로 이동시킨다.
	infoInput.font = [UIFont systemFontOfSize:14];
	[infoInput addTarget:_shareViewController action:@selector(scrollToKeyboardPosition:) forControlEvents:UIControlEventEditingDidBegin];
	
	return infoInput;
}

@end
