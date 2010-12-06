    //
//  LogoViewCtrl.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/07/09.
//  Copyright 2010 3di. All rights reserved.
//

#import "LogoViewCtrl.h"
#import "Define.h"

#define ANIMATION_START @"animation_start"
#define ANIMATION_END @"animation_end"

@implementation LogoViewCtrl
@synthesize logoView = _logoView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[_logoView setAlpha:0.0f];
	
	[self initAnimation:ANIMATION_START duration:0.75f delay:0.75f];
	[_logoView setAlpha:1.0f];
	[UIView commitAnimations];
}

- (void)requestEnd {
	[self initAnimation:ANIMATION_END duration:0.75f delay:0.0f];
	[_logoView setAlpha:0.0f];
	[UIView commitAnimations];
}

- (void)initAnimation:(NSString *)animationID duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:animationID context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:duration];
	[UIView setAnimationDelay:delay];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector:@selector(onAnimationEnd:finished:context:)];	
}

-(void)onAnimationEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	
	if ([animationID isEqualToString:ANIMATION_START]) {
	}
	
	else if ([animationID isEqualToString:ANIMATION_END]) {
		NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
		[notificationCenter postNotificationName:LOGO_END_EVENT object:nil userInfo:nil];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)dealloc {
	[self.logoView release];
    [super dealloc];
}


@end
