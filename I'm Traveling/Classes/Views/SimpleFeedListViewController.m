//
//  SimpleFeedListViewController.m
//  I'm Traveling
//
//  Created by 전 수열 on 12. 3. 14..
//  Copyright (c) 2012년 Joyfl. All rights reserved.
//

#import "SimpleFeedListViewController.h"

@interface SimpleFeedListViewController ()

@end

@implementation SimpleFeedListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
