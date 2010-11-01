//
//  WePublishAppDelegate.m
//  WePublish
//
//  Created by Yusuke Kikkawa on 10/06/26.
//  Copyright 3di 2010. All rights reserved.
//

#import "WePublishAppDelegate.h"
#import "WePublishViewController.h"
#import "Define.h"
#import "Util.h"

#define MEMORY_CHECK NO
#define MEMORY_CHECK_INTERVAL_SEC 5

@implementation WePublishAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	if (MEMORY_CHECK) {
		[NSTimer scheduledTimerWithTimeInterval:1.00 * MEMORY_CHECK_INTERVAL_SEC
										 target:self
									   selector:@selector(onMemoryCheckTimer:)
									   userInfo:nil
										repeats:YES];
	}	

	return YES;
}

- (void)onMemoryCheckTimer:(NSTimer*)timer {
	NSUInteger rsm = [Util realMemory];
	NSUInteger rsm_mb = rsm / (1024 * 1024);
	NSLog(@"system memory: %u MB: %u", rsm, rsm_mb);
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:APP_FINISH_EVENT object:nil userInfo:nil];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
