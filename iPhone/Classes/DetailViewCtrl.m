    //
//  DetailViewCtrl.m
//  iTestRotation
//
//  Created by Yusuke Kikkawa on 10/06/25.
//  Copyright 2010 3di. All rights reserved.
//

#import "DetailViewCtrl.h"
#import "Define.h"

@implementation DetailViewCtrl
@synthesize frontImage = _frontImage;
@synthesize titleText = _titleText;
@synthesize authorText = _authorText;
@synthesize reviewView = _reviewView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (IBAction)clickBack:(UIButton*)sender {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:DETAIL_DISAPPEAR_EVENT object:nil userInfo:nil];
}

- (IBAction)clickRead:(UIButton*)sender {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:DETAIL_TO_READ_EVENT object:nil userInfo:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[self.frontImage release];
	[self.reviewView release];
	[self.titleText release];
	[self.authorText release];
    [super dealloc];
}


@end
